import type { DistanceAnchor, PlaceCategory } from "@/models";
import { totalTravelers, type TravelParty } from "@/models";
import { mockPlaceProvider } from "../providers/mock/mockPlaceProvider";
import { rankPlaces, type RankedPlace } from "@/core/ranking/rankingPipeline";
import { knowledgeMap } from "@/data/knowledge";
import { COVELLI_CENTER, findUniversityBySlug, OHIO_STATE } from "@/data/universities";
import { getPlaceById } from "@/data/places";

export interface SearchPlacesParams {
  universityId: string;
  category?: PlaceCategory;
  travelParty: TravelParty;
  anchor: DistanceAnchor;
  currentHotelPlaceId?: string;
  requirePartyFit?: boolean;
}

function anchorLocation(params: SearchPlacesParams) {
  if (params.anchor === "venue") return COVELLI_CENTER.location;
  if (params.anchor === "hotel" && params.currentHotelPlaceId) {
    const hotel = getPlaceById(params.currentHotelPlaceId);
    if (hotel) return hotel.location;
  }
  // Default / "university" anchor.
  const univ = params.universityId === OHIO_STATE.id ? OHIO_STATE : findUniversityBySlug("ohio-state");
  return (univ ?? OHIO_STATE).location;
}

export async function searchPlaces(params: SearchPlacesParams): Promise<RankedPlace[]> {
  const places = await mockPlaceProvider.searchByUniversity(params.universityId, params.category);
  const knowledge = knowledgeMap();
  const anchor = anchorLocation(params);
  const partySize = totalTravelers(params.travelParty);

  return rankPlaces(places, {
    partySize,
    anchor,
    anchorRadiusMi: 20,
    knowledgeByPlaceId: knowledge,
    requirePartyFit: params.requirePartyFit,
  });
}
