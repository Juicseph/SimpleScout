import type { LatLng } from "@/models";

const EARTH_RADIUS_MI = 3958.8;

export function haversineMiles(a: LatLng, b: LatLng): number {
  const toRad = (deg: number) => (deg * Math.PI) / 180;
  const dLat = toRad(b.lat - a.lat);
  const dLng = toRad(b.lng - a.lng);
  const lat1 = toRad(a.lat);
  const lat2 = toRad(b.lat);

  const h =
    Math.sin(dLat / 2) ** 2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLng / 2) ** 2;
  return EARTH_RADIUS_MI * 2 * Math.asin(Math.sqrt(h));
}

/** Rough drive-time estimate for demo purposes (avg urban/suburban speed). */
export function estimatedDriveMinutes(miles: number): number {
  const avgMph = miles < 2 ? 18 : miles < 8 ? 28 : 42;
  return Math.max(2, Math.round((miles / avgMph) * 60));
}

/** 0-1 score, 1 = essentially at the anchor, decaying to 0 by `maxRadiusMi`. */
export function distanceScore(miles: number, maxRadiusMi = 15): number {
  if (miles <= 0.5) return 1;
  if (miles >= maxRadiusMi) return 0.05;
  return Math.max(0.05, 1 - miles / maxRadiusMi);
}
