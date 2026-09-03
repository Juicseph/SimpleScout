import type { Sport } from "./user";

export interface TravelParty {
  athletes: number;
  coaches: number;
  staff: number;
}

export function totalTravelers(party: TravelParty): number {
  return party.athletes + party.coaches + party.staff;
}

export type TripStatus = "planning" | "confirmed" | "active" | "completed" | "cancelled";

export interface Trip {
  id: string;
  teamId: string;
  teamName: string;
  sport: Sport;
  destinationUniversityId: string;
  startingUniversityId?: string;
  venueId?: string;
  startDate: string; // ISO date
  endDate: string; // ISO date
  travelParty: TravelParty;
  currentHotelPlaceId?: string;
  status: TripStatus;
}

export type DistanceAnchor = "university" | "venue" | "hotel" | "airport" | "current_location" | "custom";

export interface ItineraryItem {
  id: string;
  tripId: string;
  placeId?: string;
  venueId?: string;
  title: string;
  startsAt: string; // ISO datetime
  endsAt?: string;
  notes?: string;
}

/** Trip Board section — see docs/ARCHITECTURE.md core screens (Trip Board). */
export type TripPlaceSection =
  | "hotel"
  | "team_dinner"
  | "pregame_meal"
  | "postgame_meal"
  | "catering"
  | "grocery"
  | "equipment"
  | "emergency_resources";

export interface TripPlace {
  id: string;
  tripId: string;
  placeId: string;
  section: TripPlaceSection;
  notes?: string;
}

export interface TripLogistics {
  tripId: string;
  airport: { name: string; code: string; notes?: string };
  generalNotes: string[];
}

export function isTravelModeActive(trip: Pick<Trip, "startDate" | "endDate">, now: Date = new Date()): boolean {
  const start = new Date(trip.startDate + "T00:00:00");
  const end = new Date(trip.endDate + "T23:59:59");
  return now >= start && now <= end;
}
