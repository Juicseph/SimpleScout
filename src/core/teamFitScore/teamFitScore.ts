import type { LatLng, Place } from "@/models";
import type { KnowledgeSummary } from "@/models";
import { distanceScore, haversineMiles } from "../ranking/distance";
import { partySizeFit } from "../ranking/partySize";
import { weightsForCategory } from "./teamFitWeights";

export interface TeamFitInput {
  place: Place;
  partySize: number;
  anchor: LatLng;
  anchorRadiusMi?: number;
  knowledge?: KnowledgeSummary;
  nowHour?: number; // 0-23, for hoursFit — omitted in static/demo contexts
}

export interface TeamFitFactor {
  key: string;
  label: string;
  value: number; // 0-1
}

export interface TeamFitResult {
  score: number; // 0-100
  factors: TeamFitFactor[];
  headline: string;
  fitsParty: boolean;
}

function groupExperienceScore(place: Place): number {
  const a = place.athletics;
  let points = 0.3; // baseline
  if (a.hasPrivateDining) points += 0.2;
  if (a.hasMeetingSpace) points += 0.15;
  if (a.busParking) points += 0.2;
  if (place.restaurant?.familyStyle || place.restaurant?.buffet) points += 0.15;
  return Math.min(1, points);
}

function athleticsHistoryScore(knowledge?: KnowledgeSummary): number {
  if (!knowledge) return 0.4; // neutral, unknown
  let score = 0.35;
  if (knowledge.athleticsRating) score += (knowledge.athleticsRating / 5) * 0.35;
  const visits = knowledge.departmentVisits?.visitCount ?? 0;
  if (visits > 0) score += Math.min(0.2, visits * 0.07);
  if (knowledge.networkSignal && knowledge.networkSignal.teamsUsedCount > 0) {
    score += Math.min(0.15, knowledge.networkSignal.teamsUsedCount * 0.01);
  }
  return Math.min(1, score);
}

function hoursFitScore(place: Place, nowHour?: number): number {
  const hours = place.external.hoursToday;
  if (!hours) return 0.6;
  if (hours === "open_24h") return 1;
  if (hours === "closed") return 0.05;
  if (nowHour == null) return 0.75;
  const opensH = parseInt(hours.opens.split(":")[0] ?? "0", 10);
  const closesH = parseInt(hours.closes.split(":")[0] ?? "23", 10);
  return nowHour >= opensH && nowHour < closesH ? 1 : 0.15;
}

function dietaryScore(place: Place): number {
  const options = place.athletics.dietaryOptions ?? [];
  if (place.category !== "restaurant" && place.category !== "caterer") return 0.7;
  return Math.min(1, 0.25 + options.length * 0.18);
}

function valueScore(place: Place): number {
  const level = place.external.priceLevel;
  if (level == null) return 0.6;
  // Mid price tiers score highest for "value fit," not literal cheapness.
  const table = [0.55, 0.85, 1, 0.75, 0.5];
  return table[level] ?? 0.6;
}

function publicRatingScore(place: Place): number {
  const rating = place.external.publicRating;
  if (!rating) return 0.5;
  return Math.min(1, rating / 5);
}

export function computeTeamFitScore(input: TeamFitInput): TeamFitResult {
  const { place, partySize, anchor, anchorRadiusMi = 15, knowledge, nowHour } = input;
  const weights = weightsForCategory(place.category);

  const miles = haversineMiles(anchor, place.location);
  const factors: TeamFitFactor[] = [
    { key: "partySizeFit", label: "Fits your party size", value: partySizeFit(partySize, place.capacity) },
    { key: "distance", label: "Distance", value: distanceScore(miles, anchorRadiusMi) },
    { key: "groupExperience", label: "Group experience", value: groupExperienceScore(place) },
    { key: "athleticsHistory", label: "Athletics history", value: athleticsHistoryScore(knowledge) },
    { key: "hoursFit", label: "Hours fit", value: hoursFitScore(place, nowHour) },
    { key: "dietary", label: "Dietary accommodation", value: dietaryScore(place) },
    { key: "value", label: "Value fit", value: valueScore(place) },
    { key: "publicRating", label: "Public rating", value: publicRatingScore(place) },
  ];

  const weightMap: Record<string, number> = {
    partySizeFit: weights.partySizeFit,
    distance: weights.distance,
    groupExperience: weights.groupExperience,
    athleticsHistory: weights.athleticsHistory,
    hoursFit: weights.hoursFit,
    dietary: weights.dietary,
    value: weights.value,
    publicRating: weights.publicRating,
  };

  const weighted = factors.reduce((sum, f) => sum + f.value * (weightMap[f.key] ?? 0), 0);
  const score = Math.round(weighted * 100);

  const maxCap = place.capacity.maxPartySize;
  const fitsParty = maxCap == null || partySize <= maxCap;

  const visits = knowledge?.departmentVisits?.visitCount ?? 0;
  const headline = !fitsParty
    ? `May be tight for a party of ${partySize}`
    : visits > 0
      ? `Great fit for your party of ${partySize} · ${visits} previous department visit${visits > 1 ? "s" : ""}`
      : `Great fit for your party of ${partySize} · ${Math.round(miles * 10) / 10} mi away`;

  return { score, factors, headline, fitsParty };
}
