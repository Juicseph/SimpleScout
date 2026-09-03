-- SimpleScout database schema
-- Target: PostgreSQL 15+ (Supabase)
--
-- Organized to match docs/ARCHITECTURE.md. Row Level Security (RLS) policy
-- stubs are included per privacy-sensitive table; actual policies should be
-- finalized alongside auth wiring, but the visibility columns they key off
-- are defined here so the schema itself never needs to change for privacy.

create extension if not exists "pgcrypto";
create extension if not exists "postgis"; -- geography(Point) for places

-- =========================================================================
-- ENUMS
-- =========================================================================

create type team_role as enum (
  'director_of_ops',
  'head_coach',
  'assistant_coach',
  'athletic_trainer',
  'equipment_manager',
  'sports_information',
  'admin'
);

create type sport as enum (
  'volleyball', 'basketball', 'football', 'soccer', 'baseball', 'softball',
  'track_and_field', 'swimming', 'tennis', 'golf', 'wrestling', 'other'
);

create type visibility_level as enum ('personal', 'team', 'department', 'network');

create type place_category as enum (
  'hotel', 'restaurant', 'store', 'caterer', 'venue', 'pharmacy', 'medical',
  'grocery', 'equipment', 'tech', 'transportation', 'other'
);

create type distance_anchor as enum (
  'university', 'venue', 'hotel', 'airport', 'current_location', 'custom'
);

create type attribution_mode as enum ('named_department', 'anonymous_count_only');

create type need_now_category as enum (
  'athletic', 'tech', 'team_essentials', 'food', 'pharmacy', 'medical',
  'printing', 'transportation', 'other'
);

-- =========================================================================
-- ORGANIZATION / TEAM / USER GRAPH
-- =========================================================================

create table organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now()
);

create table universities (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  city text not null,
  state text not null,
  location geography(Point, 4326) not null,
  primary_color text,
  logo_url text,
  created_at timestamptz not null default now()
);
create index universities_location_gix on universities using gist (location);

create table athletic_departments (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations(id) on delete cascade,
  university_id uuid not null references universities(id),
  name text not null, -- e.g. "Fresno State Athletics"
  network_participation boolean not null default false, -- Phase 6 opt-in
  created_at timestamptz not null default now()
);

create table teams (
  id uuid primary key default gen_random_uuid(),
  athletic_department_id uuid not null references athletic_departments(id) on delete cascade,
  name text not null, -- e.g. "Women's Volleyball"
  sport sport not null,
  created_at timestamptz not null default now(),
  unique (athletic_department_id, name)
);

create table users (
  id uuid primary key default gen_random_uuid(), -- mirrors auth.users(id) in Supabase
  email text not null unique,
  full_name text not null,
  avatar_url text,
  created_at timestamptz not null default now()
);

create table team_memberships (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  team_id uuid not null references teams(id) on delete cascade,
  role team_role not null,
  created_at timestamptz not null default now(),
  unique (user_id, team_id, role)
);
create index team_memberships_user_idx on team_memberships(user_id);
create index team_memberships_team_idx on team_memberships(team_id);

-- Department-level admin grant (separate from team_memberships because it is
-- not scoped to a single team; see ARCHITECTURE.md §7).
create table department_admins (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  athletic_department_id uuid not null references athletic_departments(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (user_id, athletic_department_id)
);

-- =========================================================================
-- VENUES / TRIPS / TRAVEL PARTIES
-- =========================================================================

create table venues (
  id uuid primary key default gen_random_uuid(),
  university_id uuid not null references universities(id) on delete cascade,
  name text not null, -- e.g. "Covelli Center"
  sport sport,
  location geography(Point, 4326) not null,
  created_at timestamptz not null default now()
);

create table trips (
  id uuid primary key default gen_random_uuid(),
  team_id uuid not null references teams(id) on delete cascade,
  destination_university_id uuid not null references universities(id),
  starting_university_id uuid references universities(id),
  venue_id uuid references venues(id),
  start_date date not null,
  end_date date not null,
  sport sport not null,
  current_hotel_place_id uuid, -- FK to places(id) attached below, once places exists
  status text not null default 'planning', -- planning | confirmed | active | completed | cancelled
  created_by uuid not null references users(id),
  created_at timestamptz not null default now(),
  check (end_date >= start_date)
);
create index trips_team_idx on trips(team_id);
create index trips_dates_idx on trips(start_date, end_date);

create table travel_parties (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null unique references trips(id) on delete cascade,
  athletes int not null default 0,
  coaches int not null default 0,
  staff int not null default 0,
  total int generated always as (athletes + coaches + staff) stored
);

-- =========================================================================
-- PLACES: canonical anchor + provider cache + proprietary profile
-- =========================================================================

create table places (
  id uuid primary key default gen_random_uuid(),
  category place_category not null,
  name text not null,
  address text not null,
  location geography(Point, 4326) not null,
  university_id uuid references universities(id), -- nearest/primary university for scoping
  created_at timestamptz not null default now()
);
create index places_location_gix on places using gist (location);
create index places_university_idx on places(university_id);

-- Now that `places` exists, attach the deferred FK from trips.
alter table trips
  add constraint trips_current_hotel_fk foreign key (current_hotel_place_id)
  references places(id);

-- Third-party cache (Google Places today; swappable per ARCHITECTURE.md §13).
create table place_external_refs (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null unique references places(id) on delete cascade,
  provider text not null default 'google_places',
  provider_place_id text not null,
  public_rating numeric(2,1),
  public_rating_count int,
  price_level int, -- 0-4, approximate
  phone text,
  website text,
  hours_json jsonb, -- normalized weekly hours
  photo_urls text[] not null default '{}',
  raw_payload jsonb,
  fetched_at timestamptz not null default now(),
  unique (provider, provider_place_id)
);

-- Proprietary, department-agnostic physical facts about a place.
create table place_athletics_profiles (
  place_id uuid primary key references places(id) on delete cascade,
  bus_parking boolean,
  bus_parking_notes text,
  max_recommended_group int,
  has_private_dining boolean,
  has_meeting_space boolean,
  group_sales_contact_id uuid, -- fk added after contacts table
  room_block_process text,
  early_breakfast_available boolean,
  late_checkout_available boolean,
  laundry_available boolean,
  fitness_room boolean,
  delivery_available boolean,
  pickup_available boolean,
  catering_available boolean,
  dietary_options text[] not null default '{}',
  updated_at timestamptz not null default now()
);

-- Type-specific detail tables (kept separate from the shared profile above
-- because hotel/restaurant/store/caterer attributes diverge quickly).
create table hotel_details (
  place_id uuid primary key references places(id) on delete cascade,
  total_rooms int,
  supports_room_blocks boolean default true
);

create table restaurant_details (
  place_id uuid primary key references places(id) on delete cascade,
  cuisine text,
  family_style boolean default false,
  buffet boolean default false,
  reservation_required boolean default false,
  quick_meal_friendly boolean default false
);

create table store_details (
  place_id uuid primary key references places(id) on delete cascade,
  store_type text -- sporting_goods | electronics | pharmacy | grocery | hardware | printing
);

create table caterer_details (
  place_id uuid primary key references places(id) on delete cascade,
  min_order_count int,
  lead_time_hours int,
  serves_breakfast boolean default false,
  serves_lunch boolean default false,
  serves_dinner boolean default false,
  boxed_meals boolean default false,
  buffet boolean default false,
  estimated_cost_per_person numeric(6,2)
);

create table contacts (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  name text not null,
  role text, -- e.g. "Group Sales Manager"
  email text,
  phone text,
  created_at timestamptz not null default now()
);

alter table place_athletics_profiles
  add constraint place_athletics_profiles_contact_fk
  foreign key (group_sales_contact_id) references contacts(id);

-- Precomputed capacity/compatibility used by the ranking engine so party-size
-- fit is an indexed lookup rather than a runtime calculation (ARCHITECTURE.md §9).
create table place_capacity (
  place_id uuid primary key references places(id) on delete cascade,
  max_party_size int,
  ideal_party_size_min int,
  ideal_party_size_max int,
  updated_at timestamptz not null default now()
);

create table party_size_compatibility (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  party_size_bucket text not null check (party_size_bucket in ('1-10','11-20','21-30','31-50','50+')),
  fit_score numeric(3,2) not null check (fit_score between 0 and 1),
  unique (place_id, party_size_bucket)
);

-- =========================================================================
-- REVIEWS (public vs. athletics — separate schemas/rubrics, see ARCHITECTURE.md §6)
-- =========================================================================

create table public_reviews (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  source text not null default 'google_places',
  author_name text,
  rating numeric(2,1) not null,
  body text,
  written_at timestamptz,
  created_at timestamptz not null default now()
);

create table athletics_reviews (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  author_id uuid not null references users(id),
  team_id uuid not null references teams(id),
  trip_id uuid references trips(id),
  visibility visibility_level not null default 'team',
  overall_rating numeric(2,1) not null check (overall_rating between 1 and 5),
  -- category ratings stored as jsonb since hotel vs restaurant rubrics differ:
  -- hotels: team_friendly, bus_access, breakfast, meeting_space, location,
  --         staff, room_blocks, laundry, value
  -- restaurants: large_group_friendly, speed, food_quality, bus_access,
  --              private_dining, dietary_options, team_friendly, value
  category_ratings jsonb not null default '{}',
  body text,
  created_at timestamptz not null default now()
);
create index athletics_reviews_place_idx on athletics_reviews(place_id);

-- =========================================================================
-- INSTITUTIONAL KNOWLEDGE: notes, visit history, network recommendations
-- =========================================================================

create table notes (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  author_id uuid not null references users(id),
  team_id uuid references teams(id),
  athletic_department_id uuid references athletic_departments(id),
  visibility visibility_level not null default 'team',
  body text not null,
  created_at timestamptz not null default now()
);
create index notes_place_idx on notes(place_id);

create table team_visits (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  team_id uuid not null references teams(id) on delete cascade,
  trip_id uuid references trips(id),
  visited_on date not null,
  visibility visibility_level not null default 'department',
  created_at timestamptz not null default now()
);
create index team_visits_place_idx on team_visits(place_id);
create index team_visits_team_idx on team_visits(team_id);

-- Rollup of team_visits at the department level, refreshed by a trigger/job
-- so "your department has stayed here 4 times" is a cheap read.
create table department_visits (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  athletic_department_id uuid not null references athletic_departments(id) on delete cascade,
  visit_count int not null default 0,
  last_visited_on date,
  unique (place_id, athletic_department_id)
);

create table network_recommendations (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  athletic_department_id uuid not null references athletic_departments(id),
  promoted_from_note_id uuid references notes(id),
  promoted_from_visit_id uuid references team_visits(id),
  attribution_mode attribution_mode not null default 'anonymous_count_only',
  visibility visibility_level not null default 'network',
  summary text,
  created_by uuid not null references users(id),
  created_at timestamptz not null default now()
);

create table ask_requests (
  id uuid primary key default gen_random_uuid(),
  requested_by uuid not null references users(id),
  athletic_department_id uuid not null references athletic_departments(id),
  university_id uuid references universities(id),
  sport sport,
  party_size int,
  question text not null,
  created_at timestamptz not null default now()
);

create table ask_request_responses (
  id uuid primary key default gen_random_uuid(),
  ask_request_id uuid not null references ask_requests(id) on delete cascade,
  network_recommendation_id uuid references network_recommendations(id),
  responder_id uuid not null references users(id),
  body text not null,
  created_at timestamptz not null default now()
);

-- Append-only audit log for visibility promotions/demotions (ARCHITECTURE.md §15).
create table knowledge_visibility_events (
  id uuid primary key default gen_random_uuid(),
  record_table text not null, -- 'notes' | 'team_visits' | 'athletics_reviews'
  record_id uuid not null,
  changed_by uuid not null references users(id),
  from_visibility visibility_level,
  to_visibility visibility_level not null,
  created_at timestamptz not null default now()
);

-- =========================================================================
-- FAVORITES / COLLECTIONS / TAGS / SHARING
-- =========================================================================

create table favorites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  place_id uuid not null references places(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (user_id, place_id)
);

create table collections (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references users(id) on delete cascade,
  team_id uuid references teams(id),
  name text not null,
  created_at timestamptz not null default now()
);

create table collection_places (
  collection_id uuid not null references collections(id) on delete cascade,
  place_id uuid not null references places(id) on delete cascade,
  added_at timestamptz not null default now(),
  primary key (collection_id, place_id)
);

create table place_tags (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  tag text not null, -- e.g. 'team_friendly', 'bus_parking', 'staff_favorite'
  unique (place_id, tag)
);

create table shared_recommendations (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  shared_by uuid not null references users(id),
  shared_with_user_id uuid references users(id),
  shared_with_team_id uuid references teams(id),
  message text,
  created_at timestamptz not null default now()
);

-- =========================================================================
-- TRIP BOARD / ITINERARY
-- =========================================================================

create table trip_places (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  place_id uuid not null references places(id) on delete cascade,
  section text not null, -- hotel | venue | team_dinner | pregame_meal | postgame_meal
                          -- | catering | grocery | airport | equipment | emergency
  notes text,
  added_by uuid not null references users(id),
  created_at timestamptz not null default now()
);

create table itinerary_items (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  place_id uuid references places(id),
  title text not null,
  starts_at timestamptz not null,
  ends_at timestamptz,
  notes text,
  created_at timestamptz not null default now()
);
create index itinerary_items_trip_idx on itinerary_items(trip_id, starts_at);

-- =========================================================================
-- SEARCH / TRAVEL MODE TELEMETRY
-- =========================================================================

create table search_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  trip_id uuid references trips(id),
  raw_query text not null,
  parsed_filters jsonb,
  created_at timestamptz not null default now()
);

create table travel_mode_sessions (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  user_id uuid not null references users(id),
  activated_at timestamptz not null default now(),
  deactivated_at timestamptz
);

-- =========================================================================
-- ROW LEVEL SECURITY (stubs — finalize policies with auth integration)
-- =========================================================================

alter table notes enable row level security;
alter table athletics_reviews enable row level security;
alter table team_visits enable row level security;
alter table network_recommendations enable row level security;
alter table trips enable row level security;

-- Example shape (implemented against Supabase auth.uid() at integration time):
-- create policy notes_select on notes for select using (
--   visibility = 'personal' and author_id = auth.uid()
--   or visibility = 'team' and team_id in (select team_id from team_memberships where user_id = auth.uid())
--   or visibility = 'department' and athletic_department_id in (
--        select t.athletic_department_id from teams t
--        join team_memberships tm on tm.team_id = t.id where tm.user_id = auth.uid()
--        union
--        select athletic_department_id from department_admins where user_id = auth.uid()
--     )
--   or visibility = 'network' and athletic_department_id in (
--        select athletic_department_id from athletic_departments where network_participation
--     )
-- );
