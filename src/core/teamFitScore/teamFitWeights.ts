import type { PlaceCategory } from "@/models";

export interface TeamFitWeights {
  partySizeFit: number;
  distance: number;
  groupExperience: number;
  athleticsHistory: number;
  hoursFit: number;
  dietary: number;
  value: number;
  publicRating: number;
}

const DEFAULT_WEIGHTS: TeamFitWeights = {
  partySizeFit: 0.25,
  distance: 0.15,
  groupExperience: 0.15,
  athleticsHistory: 0.15,
  hoursFit: 0.1,
  dietary: 0.1,
  value: 0.05,
  publicRating: 0.05,
};

const HOTEL_WEIGHTS: TeamFitWeights = {
  partySizeFit: 0.28,
  distance: 0.18,
  groupExperience: 0.2,
  athleticsHistory: 0.16,
  hoursFit: 0.02,
  dietary: 0.02,
  value: 0.08,
  publicRating: 0.06,
};

const RESTAURANT_WEIGHTS: TeamFitWeights = {
  partySizeFit: 0.24,
  distance: 0.14,
  groupExperience: 0.14,
  athleticsHistory: 0.14,
  hoursFit: 0.14,
  dietary: 0.12,
  value: 0.04,
  publicRating: 0.04,
};

const CATERER_WEIGHTS: TeamFitWeights = {
  partySizeFit: 0.3,
  distance: 0.05,
  groupExperience: 0.1,
  athleticsHistory: 0.15,
  hoursFit: 0.2,
  dietary: 0.15,
  value: 0.03,
  publicRating: 0.02,
};

/** Category-specific config — see docs/ARCHITECTURE.md §10. */
export function weightsForCategory(category: PlaceCategory): TeamFitWeights {
  switch (category) {
    case "hotel":
      return HOTEL_WEIGHTS;
    case "restaurant":
      return RESTAURANT_WEIGHTS;
    case "caterer":
      return CATERER_WEIGHTS;
    default:
      return DEFAULT_WEIGHTS;
  }
}
