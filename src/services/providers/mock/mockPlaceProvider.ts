import type { Place, PlaceCategory } from "@/models";
import { PLACES } from "@/data/places";
import type { PlaceProvider } from "../placeProvider";

/** Deterministic in-memory implementation used for the demo environment. */
export class MockPlaceProvider implements PlaceProvider {
  async searchByUniversity(universityId: string, category?: PlaceCategory): Promise<Place[]> {
    return PLACES.filter((p) => p.universityId === universityId && (!category || p.category === category));
  }

  async getById(placeId: string): Promise<Place | undefined> {
    return PLACES.find((p) => p.id === placeId);
  }
}

export const mockPlaceProvider = new MockPlaceProvider();
