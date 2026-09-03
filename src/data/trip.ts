import type { Trip } from "@/models";
import { COVELLI_CENTER, FRESNO_STATE, OHIO_STATE } from "./universities";

export const DEMO_TRIP: Trip = {
  id: "trip_demo_osu",
  teamId: "team_fresno_wvb",
  teamName: "Fresno State Women's Volleyball",
  sport: "volleyball",
  destinationUniversityId: OHIO_STATE.id,
  startingUniversityId: FRESNO_STATE.id,
  venueId: COVELLI_CENTER.id,
  startDate: "2026-09-12",
  endDate: "2026-09-14",
  travelParty: { athletes: 18, coaches: 6, staff: 4 },
  currentHotelPlaceId: "place_marriott_columbus",
  status: "planning",
};
