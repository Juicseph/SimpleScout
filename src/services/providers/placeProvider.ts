import type { Place, PlaceCategory } from "@/models";

/**
 * Abstraction over "places" data so a real Google Places / hotel-data / live
 * inventory integration can be dropped in later without touching ranking,
 * UI, or the database schema. See docs/ARCHITECTURE.md §13.
 */
export interface PlaceProvider {
  searchByUniversity(universityId: string, category?: PlaceCategory): Promise<Place[]>;
  getById(placeId: string): Promise<Place | undefined>;
}
