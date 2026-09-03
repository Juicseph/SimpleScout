# SimpleScout — Product & Technical Architecture

**SimpleScout** is the operating system for college athletics travel: a party-size-aware,
knowledge-driven trip planning and in-trip operations platform for Directors of Operations,
coaches, athletic trainers, equipment managers, and athletic department staff.

This document is the architect-level reference for the product. It is intentionally written
before feature code so that the MVP can be built without boxing out Phase 2+ systems
(Ask Another Team, the Athletics Network, AI Search, and advanced Travel Mode).

---

## 1. Recommended Overall Product Architecture

SimpleScout is a **thin, fast client over a knowledge-first backend**. The defining
architectural decision is that the platform is not a maps/places wrapper — it is a
**data ownership platform** where third-party place data (Google Places) is enriched and
permanently overlaid with proprietary athletics data (ratings, visit history, notes,
capacity, network recommendations) that the platform itself owns and that compounds in
value over time.

```
┌─────────────────────────────────────────────────────────────────────┐
│                             CLIENTS                                  │
│   Next.js Web App (Directors, Coaches, Staff)                        │
│   SwiftUI iOS App (same users, travel-mode-first on mobile)          │
└───────────────────────────┬───────────────────────────────────────────┘
                             │ HTTPS / JSON (typed via shared OpenAPI/tRPC contract)
┌───────────────────────────▼───────────────────────────────────────────┐
│                        APPLICATION API LAYER                          │
│  Next.js Route Handlers (BFF) — auth, request shaping, aggregation    │
│  Shared "core" TypeScript package: ranking, party-size logic,         │
│  Team Fit Score, permission checks — consumed by web BFF and workers  │
└───────────────────────────┬───────────────────────────────────────────┘
                             │
        ┌────────────────────┼─────────────────────────┐
        ▼                    ▼                          ▼
┌───────────────┐   ┌──────────────────┐      ┌───────────────────────┐
│  PostgreSQL    │   │  Ranking Engine  │      │  External Provider    │
│  (Supabase)    │   │  (party size,    │      │  Abstraction Layer    │
│  - Org/Team    │   │  Team Fit Score, │      │  - Places provider    │
│  - Trips       │   │  network signal) │      │  - Maps/geocoding     │
│  - Places      │   └──────────────────┘      │  - Catering/inventory │
│  - Reviews     │                              │  (Google today,      │
│  - Knowledge   │                              │   swappable later)   │
│  - Network     │                              └───────────────────────┘
└───────────────┘
```

Key architectural principles:

1. **One core domain logic package, two clients.** Party-size ranking, Team Fit Score,
   and permission/visibility rules live in a framework-agnostic TypeScript "core" module.
   The web BFF calls it directly; the iOS app calls it via the API. This guarantees the web
   and iOS apps never compute ranking differently.
2. **External data is cached and normalized, never trusted as the source of truth for
   anything proprietary.** A `Place` row is the join point between a `PlaceExternalRef`
   (Google Place ID, cached attributes) and `PlaceAthleticsProfile` (everything we own).
3. **Everything is scoped through an Organization → AthleticDepartment → Team → Trip
   hierarchy**, and every proprietary record (note, review, visit) carries a `visibility`
   level so the same schema supports Phase 1 (single department) and Phase 6 (network)
   without migration.
4. **Trip context is a first-class, app-wide singleton**, not a parameter developers have to
   remember to pass. See §9.

---

## 2. Recommended Web and iPhone Technology Stack

### Web
- **Next.js 14 (App Router) + React 18 + TypeScript** — server components for
  data-heavy destination pages, client components for interactive search/map.
- **Tailwind CSS** + a small design-token layer (`/src/styles/tokens.ts`) so the "premium
  consumer travel app" look (rounded cards, soft shadows, warm neutral palette) is
  centrally controlled, not repeated per component.
- **Supabase (PostgreSQL + Auth + Storage)** — Postgres for relational integrity across the
  org/team/trip graph, Supabase Auth for department-issued accounts, Row Level Security
  (RLS) as the enforcement layer for the visibility hierarchy in §7/§15, Storage for photos
  attached to internal notes/reviews.
- **React Query (TanStack Query)** for client-side data fetching/caching/optimistic updates
  (favorites, notes) layered on top of server-rendered initial data.
- **Mapbox GL JS** for the interactive map (chosen over the Google Maps JS SDK for
  styling control that matches the premium/calm design language; Google Places remains the
  data source — see §13).
- **Zustand** for small pieces of cross-cutting client state that don't belong in the URL or
  server cache — most importantly the **Active Trip Context** (§9) and Travel Mode state.

### iOS
- **SwiftUI + Swift Concurrency**, targeting the same REST/JSON API as web (not GraphQL,
  to keep one contract simple to version). No cross-platform framework (React Native/
  Flutter) is recommended — Travel Mode's competitive advantage depends on iOS-native
  feel (Live Activities on the Lock Screen for the Live Trip Card, native MapKit, Apple
  Maps deep links for turn-by-turn, widgets, haptics). A cross-platform shell would blunt
  exactly the polish this product is selling.
- **MapKit** for on-device map rendering (Apple Maps look/feel per the spec), backed by the
  same `Place` records (lat/lng + our IDs) so pins and provider choice are consistent
  with web's Mapbox layer — both are downstream of one canonical `places` table.
- **Live Activities + Dynamic Island** for the Live Trip Card (§11).
- **WidgetKit** for a home-screen "Next Up" widget once Travel Mode ships.
- Local persistence: lightweight `SwiftData` cache of the active trip + today's itinerary so
  Travel Mode's core screen still renders (last-known-good) with degraded connectivity in
  arenas/hotels with poor signal.

### Shared contract
- API schema defined once (OpenAPI 3.1 generated from Zod schemas used by the Next.js
  route handlers) and used to generate the Swift client's request/response models, so web
  and iOS never drift.

---

## 3. Complete Information Architecture

```
Root
├── Explore (Home)
│   ├── Search Module (Where / When / Who's Traveling / Starting From / Sport)
│   ├── Recent Destinations
│   ├── Department Recommendations
│   └── University Search Results
│
├── Destination Hub  (/explore/[universitySlug])
│   ├── Overview (map + trip context banner)
│   ├── Stay            → Hotel Discovery
│   ├── Eat              → Team Meals / Quick Meals / Catering
│   ├── Groceries
│   ├── Equipment
│   ├── Tech
│   ├── Pharmacy
│   ├── Medical
│   ├── Essentials
│   ├── Transportation
│   └── Department History (previous visits to this university)
│
├── Place Details (/place/[placeId])
│   ├── Overview
│   ├── Team Info (capacity, bus parking, room blocks, etc.)
│   ├── Athletics History (department + network visits)
│   ├── Reviews (Public vs Athletics)
│   ├── Map
│   ├── Contact
│   └── Notes (Personal / Team / Department / Network)
│
├── Trips
│   ├── Trip List (Upcoming / Past)
│   ├── Trip Board (/trips/[tripId])
│   │   ├── Hotel, Venue, Meals, Catering, Grocery, Airport, Equipment,
│   │   │   Emergency Resources, Notes
│   │   └── Itinerary (day-by-day, places attached to events)
│   └── Travel Mode (auto-activates during active trip window)
│       ├── Today
│       ├── Need Something Now
│       ├── Live Trip Card
│       └── Quick Actions
│
├── Saved
│   ├── Favorites (Hotels / Restaurants / Caterers / Stores / Venues)
│   └── Collections
│
├── Network (Phase 6)
│   ├── Ask Another Team
│   ├── Athletics Network Feed
│   └── Verified Recommendations
│
├── Department  (admin-scoped)
│   ├── Teams & Rosters
│   ├── Staff & Roles
│   ├── Department Knowledge (all notes/reviews across teams)
│   └── Visit History
│
└── Profile
    ├── Account
    ├── Role & Permissions
    └── Settings
```

---

## 4. Main Navigation

**Mobile (bottom tab bar):** Explore · Trips · Saved · Network · Profile
— the center **Trips** tab automatically re-labels/re-styles itself to **Travel Mode**
(filled, accent-colored) whenever `now` falls inside the active trip's date range, per §11.

**Desktop (top nav):** Logo · Explore · Trips · Saved · Department · Network ·
[Search] · [Active Trip Chip] · Profile

The **Active Trip Chip** is persistent, global navigation chrome once a trip exists —
tapping it jumps straight into that trip's board or Travel Mode. This is what makes trip
context implicit everywhere instead of something the user re-selects per screen.

---

## 5. Core Screens

MVP screen set (each maps to a route above):

1. **Explore / Home** — search module + recent/department recommendations (this is the
   phase being implemented first; see §6 of the MVP section and the implementation itself).
2. **Destination Hub** — a university-scoped landing page once a destination is chosen.
3. **Hotel Discovery** (list + map)
4. **Restaurant Discovery** (list + map, with Team Meals / Quick Meals / Catering tabs)
5. **Place Details**
6. **Trip Board**
7. **Itinerary**
8. **Favorites / Collections**
9. **Basic Travel Mode home**
10. **Need Something Now** (emergency category grid)

---

## 6. Database Schema

Full DDL lives in [`db/schema.sql`](../db/schema.sql). Summary of the entity graph:

```
organizations 1─* athletic_departments 1─* teams 1─* team_memberships *─1 users
teams 1─* trips
trips 1─1 travel_parties
trips *─1 universities (destination)
trips *─1 universities (starting_from, nullable)
trips 1─* itinerary_items *─0..1 places
trips 1─* trip_places (join: trip board sections ↔ places)

universities 1─* venues
universities 1─* places (places are geo-scoped, not strictly "at" a university)

places (canonical, provider-agnostic record)
  1─1 place_external_ref     (Google Place ID + cached raw attributes)
  1─1 place_athletics_profile (proprietary: capacity, bus parking, group contact, etc.)
  1─* hotel_details | restaurant_details | store_details | caterer_details (type-specific)
  1─* public_reviews
  1─* athletics_reviews
  1─* notes                  (visibility: personal/team/department/network)
  1─* team_visits            (a team's historical use of this place)
  1─* department_visits      (rollup across teams)
  1─* favorites *─1 users
  1─* place_tags
  1─* network_recommendations (Phase 6)
  1─* contacts

collections *─* places (via collection_places)
search_history *─1 users
shared_recommendations *─1 users, *─1 places
travel_mode_sessions *─1 trips
place_capacity 1─1 places        (derived/denormalized for ranking speed)
party_size_compatibility (materialized per place, per party-size bucket)
```

Design notes:
- `places` is the single provider-agnostic anchor so a restaurant that's both a "quick
  meal" and "catering" option isn't duplicated.
- `athletics_reviews` and `public_reviews` are **separate tables**, not a `type` column on
  one table, because their schemas diverge immediately (category rubrics differ — see
  schema) and because RLS/visibility rules differ (public reviews are department-readable
  by default; athletics reviews follow the visibility hierarchy).
- `notes`, `team_visits`, `department_visits`, and `network_recommendations` are separate
  from reviews because reviews are structured ratings; these are freeform institutional
  knowledge with their own visibility and provenance.

---

## 7. Organization / University / Team Permission Model

```
Organization  (a company/customer record — usually 1:1 with a University, but modeled
               separately so a University with multiple legal athletic entities, or a
               future multi-department customer, isn't a special case)
  └─ AthleticDepartment
        └─ Team               (e.g. Women's Volleyball)
              └─ TeamMembership  (user ↔ team ↔ role)

Roles (per TeamMembership, not global):
  - director_of_ops
  - head_coach
  - assistant_coach
  - athletic_trainer
  - equipment_manager
  - sports_information
  - admin                     (department-wide, not team-scoped)
```

Rules:
- A `User` can hold memberships on **multiple teams** (e.g., an athletic trainer who covers
  three sports) — permissions are the union of their team memberships plus any
  department-level `admin` grant.
- `admin` is a department-level role (on `AthleticDepartment`, not `Team`) and can see all
  teams' trips, knowledge, and reviews within that department — this is what powers the
  **Department** knowledge/history views.
- Role determines **contextual tools**, not raw data access within a trip: everyone on a
  trip's team sees the same Trip Board, but the quick-action shortcuts and "Need Something
  Now" default categories are role-weighted (trainer → Medical/Pharmacy first, equipment
  manager → Sporting Goods/Electronics first), per the spec's role table.
- All authorization is enforced at the database layer via **Postgres Row Level Security**
  keyed off `auth.uid()` → `team_memberships` / `athletic_department` admin grants, not
  solely in application code, so a bug in the Next.js API can't leak cross-department data.

---

## 8. Internal Athletics Knowledge Architecture

This is the layer that separates SimpleScout from a maps wrapper, so it gets its own
explicit data flow:

```
                 ┌─────────────────────────────┐
Google Places →  │        places (base)         │  ← geocoding/photos/hours/public rating
                 └───────────────┬─────────────┘
                                  │ 1:1
                 ┌────────────────▼─────────────┐
                 │  place_athletics_profile      │  proprietary, department-agnostic
                 │  (capacity, bus parking,      │  physical facts (once true, true for
                 │   group contact, room block   │  every department — not duplicated)
                 │   process, ...)                │
                 └────────────────┬─────────────┘
                                  │ 1:*
        ┌─────────────┬───────────┼───────────────┬────────────────────┐
        ▼             ▼           ▼               ▼                    ▼
  athletics_reviews  notes   team_visits   department_visits   network_recommendations
  (rubric ratings)  (freeform, (usage log:  (rollup: "stayed    (Phase 6, opted-in
   scoped by         scoped by  team+trip+   here 4 times")      cross-department)
   visibility)       visibility) date)
```

**Visibility hierarchy** (stored as a single `visibility` enum column on every knowledge
record — `personal | team | department | network` — rather than four separate tables,
so a note can be "promoted" from personal → team without being recreated):

| Level | Who can read |
|---|---|
| `personal` | Only `created_by` |
| `team` | All members of the `team_id` the record is attached to |
| `department` | All members of any team within the `athletic_department_id` |
| `network` | Verified users at other universities who've opted into the Network (Phase 6) |

A record's visibility can only be **raised**, never silently lowered by another user —
raising is an explicit action ("Share with Department", "Share with Network") taken by the
author or an admin, never automatic. This directly implements the spec's privacy
requirement that internal notes never auto-become public.

**Composed knowledge card** (what actually renders on a place card/detail page) is a
read-time aggregation, not a stored object:

```
KnowledgeSummary = {
  athleticsRating: avg(athletics_reviews where visible-to-viewer),
  teamVisits: [...team_visits where visible-to-viewer, grouped by team],
  departmentVisitCount: count(department_visits where visible-to-viewer),
  topNotes: notes where visible-to-viewer, ranked by recency + author role,
  networkSignal: network_recommendations rollup (Phase 6),
}
```

This keeps the visibility rule enforced in exactly one place (the query layer / RLS),
instead of being re-implemented every time a new surface wants to show a knowledge card.

---

## 9. Party-Size Ranking Architecture

Party size is promoted to **app-wide context**, not a per-search parameter:

```
ActiveTripContext (Zustand store, web; ObservableObject, iOS)
  tripId, destinationUniversity, dates, sport,
  travelParty: { athletes, coaches, staff, total },
  currentHotel?, competitionVenue?

Every search-executing surface reads travelParty.total from context by default;
an explicit "Who's traveling" field in the search module is how it's set/overridden,
never something the user must re-type into free-text queries.
```

Ranking pipeline for any "find me places" query (`/api/search/places`):

```
1. Base candidate set: geo + category filter (from Google Places cache / places table)
2. Attach PartySizeCompatibility for the active party size bucket
     (buckets: 1-10, 11-20, 21-30, 31-50, 50+ — precomputed per place so ranking
      is an indexed lookup, not a runtime capacity calculation)
3. Score = weighted sum of:
     - partySizeFit          (can they actually take 28? hard floor: below a minimum
                               fit threshold, the place is demoted below a "may not
                               fit" divider rather than hidden — never silently hidden)
     - groupExperienceScore   (private dining, group reservations, family style, buffet)
     - distanceScore          (contextual anchor — see below)
     - hoursScore             (open now / open late relative to trip context time)
     - athleticsSignal        (department + network usage, athletics rating)
     - publicRatingScore      (Google rating, lowest weight of the group)
4. Sort descending by Score; badge outliers ("Can't fit your team of 28") rather
   than dropping them, so users can still override.
```

**Distance is contextual**, not defaulted to "current location": every search carries an
`anchor` (`university | venue | hotel | airport | current_location | custom`), defaulting
to hotel once one is selected, venue before that, university before that — mirroring how a
Director of Ops actually thinks about a trip as it firms up.

Natural-language party-size phrases ("where can 30 people eat tonight") are parsed into the
same structured filter object client-side/BFF-side (§ Phase 7 promotes this from regex/
keyword parsing to an LLM-backed parser without changing the ranking pipeline it feeds).

---

## 10. Team Fit Score Methodology

`TeamFitScore` is a 0–100 proprietary score computed **per place, per trip context**
(it is not a static property of a place — the same hotel scores differently for a
12-person golf trip than a 35-person football travel party).

```
TeamFitScore = round(100 * weighted_average(
  partySizeCompatibility   × 0.25   // can they actually handle this exact party size
  distanceToAnchor         × 0.15   // normalized against category-appropriate radius
  groupExperience          × 0.15   // private dining/room blocks/bus access, etc.
  athleticsHistorySignal   × 0.15   // department + network prior usage & ratings
  hoursFit                 × 0.10   // open during the relevant trip-context window
  dietaryAccommodation     × 0.10   // for restaurants/caterers
  valueScore               × 0.05   // price-tier fit, not absolute cheapness
  publicRatingScore        × 0.05   // Google rating, deliberately smallest weight
))
```

- Each sub-score is normalized to 0–1 before weighting so the formula is stable as new
  factors are added later (e.g., a "staff sentiment" factor from Phase 7 sentiment mining
  can be inserted without renormalizing the whole score).
- Weights are **category-specific config** (hotels vs. restaurants vs. caterers have
  different weight tables, matching the spec's separate rating categories), stored in
  `core/ranking/teamFitWeights.ts`, not hardcoded per call site.
- The score is always shown with a one-line "why" breakdown (e.g., "Great fit for your
  party of 28 · 2 previous team visits · 12 min from hotel") — the score is a UI
  simplification of the same explainable factors, never a black box.
- Computed at query time from the same inputs as ranking (§9) so the sort order and the
  displayed score are always consistent with each other by construction.

---

## 11. Travel Mode Architecture

**Activation:** Travel Mode is a **derived UI state**, not a separate data model beyond a
lightweight `travel_mode_sessions` row (used for analytics/"who's actively traveling"
department visibility, not for authorization). Activation rule:

```
isTravelModeActive(trip) =
  today >= trip.startDate - ACTIVATION_BUFFER (default: departure day)
  AND today <= trip.endDate
```

Directors can also manually toggle it early (e.g., day-of pre-departure) or extend it late
(delayed return flight).

**Context object** (superset of ActiveTripContext, §9), refreshed on a short poll / realtime
subscription so multiple staff phones see consistent "current" state:

```
TravelModeContext = ActiveTripContext + {
  currentTime, currentCity,
  todayItineraryItems: ItineraryItem[],
  nextEvent: ItineraryItem,
  currentHotel, competitionVenue,
}
```

**"Need Something Now" ranking** reuses the exact §9 ranking pipeline with the anchor
forced to `current_location` (falling back to hotel) and an added `openNowWeight` boost and
`etaScore` (drive time from current location, not just straight-line distance) — it is a
*configuration* of the same ranking engine, not a separate code path, which is why the
architecture calls for one ranking engine rather than one per feature.

**Live Trip Card** is a projection of `todayItineraryItems` + real-time drive-time to the
next item; on iOS this backs a **Live Activity** (Lock Screen/Dynamic Island) via a push-
triggered update whenever the next event or ETA changes; on web it's a persistent card in
the Travel Mode home.

**Offline resilience:** iOS caches the current trip's `TravelModeContext` and today's
itinerary in SwiftData on trip-day entry, so the Travel Mode home screen renders from cache
first (arenas/hotels are notorious dead zones) and refreshes underneath once connectivity
returns.

---

## 12. Ask Another Team / Athletics Network Architecture

Modeled as **two concentric circles** over the same underlying knowledge tables from §8,
so no new storage model is needed to go from Phase 1 → Phase 6 — only new *queries* and a
*network membership/verification* layer:

```
Circle 1 — Ask Your Department (available from MVP's schema, ships Phase 3/6 UI):
   query: department_visits + team_visits + notes
          WHERE athletic_department_id = current_user.department
          AND visibility IN (team, department)  [+personal if author]
   → "Has anyone stayed near Boise State?" becomes a geo + visited-by query
     over the department's own historical trips. No cross-department data involved.

Circle 2 — Athletics Network (Phase 6):
   network_memberships: university_id ↔ verified status, joined_at
   network_recommendations: place_id, authoring department (anonymized to
       "12 verified teams" rollups unless the author opts into attribution),
       visibility = 'network', explicitly promoted by a staff member from an
       existing team_visit/note/review — never auto-published.
   ask_requests: free-text asks broadcast to network members who've opted in
       to receiving requests for a given sport/region; responses are just
       network_recommendations with a request_id back-reference.
```

Trust & verification: `network_memberships` requires a verified `.edu`-affiliated admin
account per university (manual or SSO-federation verification in Phase 6), and every
`network_recommendation` displays its provenance ("12 verified teams stayed here") — never
anonymous internet content — matching the spec's "college-athletics-specific trust layer."

Because Circle 1 and Circle 2 read the *same* `notes`/`team_visits`/`department_visits`
tables (just widening the visibility filter and adding the opt-in `network_recommendations`
table), shipping Ask Another Team in Phase 3 and the full Network in Phase 6 is additive:
no backfill or schema migration of historical knowledge is required.

---

## 13. External API Strategy

| Capability | Provider (MVP) | Abstraction |
|---|---|---|
| Place search/details/photos/hours | Google Places API | `PlaceProvider` interface |
| Geocoding | Google Geocoding API | `GeocodingProvider` interface |
| Map rendering (web) | Mapbox GL | isolated to `MapView` component |
| Map rendering (iOS) | Apple MapKit | native, no abstraction needed |
| Turn-by-turn / drive time | Google Distance Matrix (web calc) / Apple Maps deep link (iOS nav) | `RoutingProvider` interface |
| Catering / live inventory | None at MVP — manually curated `caterer_details` | `CateringProvider` interface (stubbed) reserved for Phase 6+ |

Every provider is called only from `src/services/providers/*`, behind an interface, and
**never called directly from a component or route handler**. This is what lets a hotel data
API or a live-inventory API be swapped in later (per the spec's explicit development rule)
without touching ranking, UI, or the database schema — only the provider implementation and
its mapping into `PlaceExternalRef` changes.

Caching: `place_external_ref.raw_payload` + `fetched_at` cache Google responses in
Postgres with a TTL-based refresh job (photos/hours change rarely; this also controls
Places API cost at scale).

---

## 14. Third-Party vs. Proprietary Data Split

| From Google/external providers (`place_external_ref`) | Owned by SimpleScout (`place_athletics_profile` + related tables) |
|---|---|
| Name, address, coordinates | Athletics rating (all rubric categories) |
| Hours, phone, website | Team/department/network visit history |
| Photos | Bus parking notes & verified bus access |
| Public rating & review count | Group/room-block capacity, group sales contact |
| Price level (approximate) | Early-breakfast / accommodation history |
| Business category | Staff notes (all visibility levels) |
| | Team Fit Score & its inputs |
| | Network recommendations & provenance |
| | Favorites, collections, itinerary attachments |

This split is enforced structurally (separate tables, separate provider vs. internal
services) so the proprietary side can be exported, backed up, and reasoned about
independently of any third-party contract — it is the platform's actual moat and long-term
asset, and it must survive a future provider swap untouched.

---

## 15. Privacy Architecture

- **Enforcement point:** Postgres RLS policies keyed on `team_memberships` and
  `athletic_department` admin grants — see §7 — not just application-level `if` checks.
- **Default visibility for any new note/review is `team`**, the narrowest useful default
  (not `personal`, which would make knowledge capture pointless; not `department`, which
  would over-share by default).
- **Promotion is one-directional and explicit:** `team → department → network` requires an
  explicit user action per record; there is no bulk "make everything public" switch.
  De-promotion (making something more private again) is allowed but logged.
- **Network sharing is opt-in at the department level first** (an admin enables "Athletics
  Network participation" for the department) **and per-record second** (a staff member
  still chooses what gets shared) — a two-key requirement so no single staffer can leak a
  department's internal knowledge to the network.
- **Anonymization option:** `network_recommendations.attribution_mode` supports
  `named_department | anonymous_count_only`, so a department can contribute to "12 verified
  teams stayed here" rollups without attaching their name if they choose.
- **Auditability:** every visibility change and every network share is append-only logged
  (`knowledge_visibility_events`) for department admin review.

---

## 16. MVP Scope

Matches the spec's MVP list exactly, grouped into build order:

1. Auth + Organization/Department/Team structure
2. Trip creation: destination, dates, party size, team/sport, starting location
3. University destination search + Destination Hub pages
4. Hotel discovery (list + map)
5. Restaurant discovery (list + map), including Quick Team Meals and Catering
6. Party-size-aware ranking + Team Fit Score (real, not cosmetic — computed per §9/§10)
7. "Can Fit Our Team" filter + "Feed the Team Fast" action
8. Need Something Now (emergency categories)
9. Favorites + Collections
10. Trip Boards + basic Itinerary
11. Internal notes + Athletics Reviews (visibility: personal/team/department)
12. Previous team/department visit history
13. Basic Travel Mode (today screen, quick actions, Need Something Now reused)

## 17. Features That Should Intentionally Wait

- **Ask Another Team / Athletics Network** (Phase 6) — needs a critical mass of seeded
  department knowledge first; shipping it too early just shows empty states.
- **AI natural-language assistant** (Phase 7) — the structured filter parser ships first;
  the LLM layer is additive once the structured ranking pipeline is proven.
- **Live third-party inventory/catering APIs** — curated data is sufficient at MVP scale;
  integrating live inventory is a Phase 6+ cost/complexity trade not needed to prove the
  core product.
- **Cross-department network verification/SSO** — real trust infrastructure, deliberately
  deferred behind a working single-department product.
- **iOS Live Activities / WidgetKit** — valuable polish, but sequenced after the core API
  and web app stabilize the data contract they'd depend on.

## 18. Recommended Development Phases

Matches the spec's 7 phases (Foundation → Explore → Travel Intelligence → Trip Planning →
Travel Mode → Athletics Network → AI), with the architecture in this document ensuring each
later phase is additive (new tables/queries/UI) rather than requiring rework of earlier
phases — see §12 and §8 in particular for why Phases 3/6 and 1/6 share schema.

## 19. Initial Project Folder Structure

```
simplescout/
├── docs/
│   └── ARCHITECTURE.md
├── db/
│   └── schema.sql
├── src/
│   ├── app/                          # Next.js App Router routes only — no business logic
│   │   ├── layout.tsx
│   │   ├── page.tsx                  # Explore / Home
│   │   ├── explore/[universitySlug]/page.tsx
│   │   ├── place/[placeId]/page.tsx
│   │   └── trips/[tripId]/page.tsx
│   ├── components/
│   │   ├── ui/                       # Button, Card, Badge, SegmentedControl, Sheet...
│   │   ├── search/                   # SearchModule + its fields
│   │   ├── explore/                  # PlaceCard, ResultsList, MapPanel, CategoryRail
│   │   ├── knowledge/                # AthleticsKnowledgeCard, TeamFitBadge, VisitHistory
│   │   └── layout/                   # NavBar, BottomNav, TripContextChip
│   ├── core/                         # Framework-agnostic business logic (shared w/ iOS
│   │   │                             # via generated contract, not shared code — see §2)
│   │   ├── ranking/                  # partySizeRanking.ts, rankingPipeline.ts
│   │   ├── teamFitScore/             # teamFitScore.ts, teamFitWeights.ts
│   │   └── permissions/              # visibility.ts, roleAccess.ts
│   ├── models/                       # TypeScript types mirroring db/schema.sql
│   ├── services/
│   │   ├── providers/                # PlaceProvider, GeocodingProvider, RoutingProvider
│   │   │   └── mock/                 # Deterministic demo-data implementations
│   │   ├── trips/
│   │   ├── knowledge/
│   │   └── search/
│   ├── data/                         # Seeded demo dataset (Fresno State @ Ohio State)
│   ├── state/                        # Zustand stores: activeTripContext, travelMode
│   ├── lib/                          # utils, constants, formatting
│   └── styles/                       # tokens.ts, globals.css
├── ios/                              # SwiftUI app (Phase 1 scaffold, added when iOS work starts)
├── package.json
├── tsconfig.json
├── tailwind.config.ts
└── next.config.js
```

---

*This document is the living architectural reference. Implementation should update it when
an architectural decision changes — it is not a one-time deliverable to be abandoned once
code exists.*
