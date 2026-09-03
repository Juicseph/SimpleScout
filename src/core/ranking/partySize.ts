export type PartySizeBucket = "1-10" | "11-20" | "21-30" | "31-50" | "50+";

export function partySizeBucket(size: number): PartySizeBucket {
  if (size <= 10) return "1-10";
  if (size <= 20) return "11-20";
  if (size <= 30) return "21-30";
  if (size <= 50) return "31-50";
  return "50+";
}

/**
 * How well a place's capacity fits an exact party size, 0-1.
 * A place under its ideal range still "fits" if it's under max; a place at or
 * over max is demoted sharply rather than hidden — see ARCHITECTURE.md §9.
 */
export function partySizeFit(
  partySize: number,
  capacity: { maxPartySize?: number; idealPartySizeMin?: number; idealPartySizeMax?: number }
): number {
  const { maxPartySize, idealPartySizeMin, idealPartySizeMax } = capacity;

  if (maxPartySize != null && partySize > maxPartySize) {
    // Still surfaced, badged as a stretch, never silently hidden.
    const overBy = partySize - maxPartySize;
    return Math.max(0.05, 0.35 - overBy / (maxPartySize + 1));
  }

  if (idealPartySizeMin != null && idealPartySizeMax != null) {
    if (partySize >= idealPartySizeMin && partySize <= idealPartySizeMax) return 1;
    if (partySize < idealPartySizeMin) {
      const gap = idealPartySizeMin - partySize;
      return Math.max(0.5, 1 - gap / (idealPartySizeMin + 1));
    }
    const gap = partySize - idealPartySizeMax;
    return Math.max(0.4, 1 - gap / (idealPartySizeMax + 1));
  }

  if (maxPartySize != null) return partySize <= maxPartySize ? 0.85 : 0.2;

  return 0.6; // unknown capacity — neutral, not disqualifying
}

export function meetsPartyRequirement(
  partySize: number,
  capacity: { maxPartySize?: number }
): boolean {
  return capacity.maxPartySize == null || partySize <= capacity.maxPartySize;
}
