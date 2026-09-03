import type { LatLng, Place } from "@/models";
import type { KnowledgeSummary } from "@/models";
import { computeTeamFitScore, type TeamFitResult } from "../teamFitScore/teamFitScore";

export interface RankedPlace {
  place: Place;
  fit: TeamFitResult;
  knowledge?: KnowledgeSummary;
  distanceMi: number;
  driveMinutes: number;
}

export interface RankPlacesOptions {
  partySize: number;
  anchor: LatLng;
  anchorRadiusMi?: number;
  nowHour?: number;
  knowledgeByPlaceId?: Map<string, KnowledgeSummary>;
  /** When true, places that can't fit the party are pushed below a divider
   * instead of ranked purely on score — used by "Can Fit Our Team". */
  requirePartyFit?: boolean;
}

import { estimatedDriveMinutes, haversineMiles } from "./distance";

export function rankPlaces(places: Place[], opts: RankPlacesOptions): RankedPlace[] {
  const { partySize, anchor, anchorRadiusMi, nowHour, knowledgeByPlaceId, requirePartyFit } = opts;

  const ranked = places.map((place) => {
    const knowledge = knowledgeByPlaceId?.get(place.id);
    const fit = computeTeamFitScore({ place, partySize, anchor, anchorRadiusMi, knowledge, nowHour });
    const distanceMi = haversineMiles(anchor, place.location);
    return { place, fit, knowledge, distanceMi, driveMinutes: estimatedDriveMinutes(distanceMi) };
  });

  ranked.sort((a, b) => {
    if (requirePartyFit && a.fit.fitsParty !== b.fit.fitsParty) {
      return a.fit.fitsParty ? -1 : 1;
    }
    return b.fit.score - a.fit.score;
  });

  return ranked;
}
