import type { ItineraryItem, TripLogistics, TripPlace } from "@/models";
import { DEMO_TRIP } from "./trip";

const tripId = DEMO_TRIP.id;

export const TRIP_PLACES: TripPlace[] = [
  { id: "tp_hotel", tripId, placeId: "place_marriott_columbus", section: "hotel" },
  {
    id: "tp_team_dinner",
    tripId,
    placeId: "place_hyde_park_steakhouse",
    section: "team_dinner",
    notes: "Private room upstairs, requested by 5:15 PM for a 6:00 PM sit-down.",
  },
  {
    id: "tp_pregame_meal",
    tripId,
    placeId: "place_bibibop",
    section: "pregame_meal",
    notes: "Order called in for pickup 90 minutes before the bus departs the hotel.",
  },
  {
    id: "tp_postgame_meal",
    tripId,
    placeId: "place_adriaticos",
    section: "postgame_meal",
    notes: "Open until 2:30 AM — good fallback if the match runs long.",
  },
  { id: "tp_catering", tripId, placeId: "place_cameron_mitchell_catering", section: "catering" },
  { id: "tp_grocery", tripId, placeId: "place_kroger", section: "grocery" },
  { id: "tp_equipment", tripId, placeId: "place_dicks_sporting_goods", section: "equipment" },
  { id: "tp_emergency_pharmacy", tripId, placeId: "place_cvs_pharmacy", section: "emergency_resources" },
  { id: "tp_emergency_medical", tripId, placeId: "place_ohiohealth_urgent_care", section: "emergency_resources" },
];

export const TRIP_LOGISTICS: TripLogistics = {
  tripId,
  airport: {
    name: "John Glenn Columbus International Airport",
    code: "CMH",
    notes: "Charter arrives at the general aviation terminal — bus staged curbside for a direct load.",
  },
  generalNotes: [
    "Athletic trainer is carrying the full medical kit as checked baggage — cleared with the airline in advance.",
    "Equipment manager confirmed ball cart + film equipment ships separately via team freight, arriving Thursday.",
  ],
};

export const ITINERARY_ITEMS: ItineraryItem[] = [
  {
    id: "it_1",
    tripId,
    title: "Arrive Airport",
    startsAt: "2026-09-12T14:30:00",
    notes: "CMH general aviation terminal",
  },
  {
    id: "it_2",
    tripId,
    title: "Depart Airport",
    startsAt: "2026-09-12T15:15:00",
    notes: "Bus direct to hotel",
  },
  {
    id: "it_3",
    tripId,
    placeId: "place_marriott_columbus",
    title: "Hotel Check-In",
    startsAt: "2026-09-12T15:45:00",
  },
  {
    id: "it_4",
    tripId,
    placeId: "place_hyde_park_steakhouse",
    title: "Team Dinner",
    startsAt: "2026-09-12T17:30:00",
    endsAt: "2026-09-12T19:00:00",
  },
  {
    id: "it_5",
    tripId,
    venueId: "venue_covelli",
    title: "Practice",
    startsAt: "2026-09-12T19:30:00",
    endsAt: "2026-09-12T21:00:00",
  },
  {
    id: "it_6",
    tripId,
    placeId: "place_marriott_columbus",
    title: "Breakfast",
    startsAt: "2026-09-13T08:00:00",
    notes: "Early spread available from 6:30 AM on request.",
  },
  {
    id: "it_7",
    tripId,
    title: "Film Session",
    startsAt: "2026-09-13T10:00:00",
    endsAt: "2026-09-13T11:00:00",
    notes: "Hotel meeting room, 2nd floor",
  },
  {
    id: "it_8",
    tripId,
    placeId: "place_bibibop",
    title: "Pregame Meal",
    startsAt: "2026-09-13T12:00:00",
  },
  {
    id: "it_9",
    tripId,
    venueId: "venue_covelli",
    title: "Match vs. Ohio State",
    startsAt: "2026-09-13T16:00:00",
    endsAt: "2026-09-13T18:30:00",
  },
  {
    id: "it_10",
    tripId,
    placeId: "place_adriaticos",
    title: "Postgame Meal",
    startsAt: "2026-09-13T19:30:00",
  },
  {
    id: "it_11",
    tripId,
    placeId: "place_marriott_columbus",
    title: "Breakfast",
    startsAt: "2026-09-14T09:00:00",
  },
  {
    id: "it_12",
    tripId,
    placeId: "place_marriott_columbus",
    title: "Hotel Check-Out",
    startsAt: "2026-09-14T10:30:00",
  },
  {
    id: "it_13",
    tripId,
    title: "Depart for Airport",
    startsAt: "2026-09-14T11:00:00",
  },
];

export function tripPlacesForTrip(id: string): TripPlace[] {
  return TRIP_PLACES.filter((tp) => tp.tripId === id);
}

export function itineraryForTrip(id: string): ItineraryItem[] {
  return ITINERARY_ITEMS.filter((item) => item.tripId === id).sort((a, b) => a.startsAt.localeCompare(b.startsAt));
}
