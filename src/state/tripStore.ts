"use client";

import { create } from "zustand";
import type { DistanceAnchor, Sport, TravelParty } from "@/models";
import { DEMO_TRIP } from "@/data/trip";
import { FRESNO_STATE, OHIO_STATE } from "@/data/universities";

export interface ActiveTripContext {
  destinationUniversityId: string;
  startingUniversityId?: string;
  startDate: string;
  endDate: string;
  sport: Sport;
  travelParty: TravelParty;
  currentHotelPlaceId?: string;
  anchor: DistanceAnchor;
}

interface TripStoreState {
  hasSearched: boolean;
  context: ActiveTripContext;
  canFitTeamOnly: boolean;
  setDestination: (universityId: string) => void;
  setDates: (startDate: string, endDate: string) => void;
  setTravelParty: (party: TravelParty) => void;
  setSport: (sport: Sport) => void;
  setStartingFrom: (universityId: string | undefined) => void;
  setAnchor: (anchor: DistanceAnchor) => void;
  toggleCanFitTeam: () => void;
  runSearch: () => void;
  reset: () => void;
}

const DEFAULT_CONTEXT: ActiveTripContext = {
  destinationUniversityId: OHIO_STATE.id,
  startingUniversityId: FRESNO_STATE.id,
  startDate: DEMO_TRIP.startDate,
  endDate: DEMO_TRIP.endDate,
  sport: DEMO_TRIP.sport,
  travelParty: DEMO_TRIP.travelParty,
  currentHotelPlaceId: DEMO_TRIP.currentHotelPlaceId,
  anchor: "university",
};

export const useTripStore = create<TripStoreState>((set) => ({
  hasSearched: false,
  context: DEFAULT_CONTEXT,
  canFitTeamOnly: true,
  setDestination: (universityId) =>
    set((s) => ({ context: { ...s.context, destinationUniversityId: universityId } })),
  setDates: (startDate, endDate) => set((s) => ({ context: { ...s.context, startDate, endDate } })),
  setTravelParty: (travelParty) => set((s) => ({ context: { ...s.context, travelParty } })),
  setSport: (sport) => set((s) => ({ context: { ...s.context, sport } })),
  setStartingFrom: (startingUniversityId) =>
    set((s) => ({ context: { ...s.context, startingUniversityId } })),
  setAnchor: (anchor) => set((s) => ({ context: { ...s.context, anchor } })),
  toggleCanFitTeam: () => set((s) => ({ canFitTeamOnly: !s.canFitTeamOnly })),
  runSearch: () => set({ hasSearched: true }),
  reset: () => set({ hasSearched: false, context: DEFAULT_CONTEXT }),
}));
