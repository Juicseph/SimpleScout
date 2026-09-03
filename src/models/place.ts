import type { LatLng } from "./university";

export type PlaceCategory =
  | "hotel"
  | "restaurant"
  | "store"
  | "caterer"
  | "venue"
  | "pharmacy"
  | "medical"
  | "grocery"
  | "equipment"
  | "tech"
  | "transportation"
  | "other";

/** Data that comes from a third-party provider (Google Places today). Never
 * the source of truth for anything proprietary — see docs/ARCHITECTURE.md §14. */
export interface PlaceExternalRef {
  provider: "google_places";
  providerPlaceId: string;
  publicRating?: number;
  publicRatingCount?: number;
  priceLevel?: 0 | 1 | 2 | 3 | 4;
  phone?: string;
  website?: string;
  hoursToday?: { opens: string; closes: string } | "closed" | "open_24h";
  photoTheme: PhotoTheme;
}

/** Deterministic placeholder art theme instead of hot-linked stock photography,
 * so the demo has no external asset dependency. */
export type PhotoTheme =
  | "hotel-lobby"
  | "hotel-exterior"
  | "restaurant-interior"
  | "quick-service"
  | "catering"
  | "sporting-goods"
  | "electronics"
  | "pharmacy"
  | "grocery"
  | "medical"
  | "venue";

/** Proprietary, department-agnostic facts SimpleScout owns about a place.
 * See docs/ARCHITECTURE.md §14. */
export interface AthleticsProfile {
  busParking?: boolean;
  busParkingNotes?: string;
  maxRecommendedGroup?: number;
  hasPrivateDining?: boolean;
  hasMeetingSpace?: boolean;
  earlyBreakfastAvailable?: boolean;
  lateCheckoutAvailable?: boolean;
  laundryAvailable?: boolean;
  fitnessRoom?: boolean;
  deliveryAvailable?: boolean;
  pickupAvailable?: boolean;
  cateringAvailable?: boolean;
  onlineOrdering?: boolean;
  dietaryOptions?: string[];
  groupSalesContact?: { name: string; role: string; phone?: string; email?: string };
}

export interface HotelDetails {
  totalRooms?: number;
  supportsRoomBlocks: boolean;
}

export interface RestaurantDetails {
  cuisine: string;
  familyStyle?: boolean;
  buffet?: boolean;
  reservationRequired?: boolean;
  quickMealFriendly?: boolean;
  estimatedPrepMinutes?: number;
}

export interface StoreDetails {
  storeType: "sporting_goods" | "electronics" | "pharmacy" | "grocery" | "hardware" | "printing";
  likelyInventory?: string[];
}

export interface CatererDetails {
  minOrderCount?: number;
  leadTimeHours?: number;
  servesBreakfast?: boolean;
  servesLunch?: boolean;
  servesDinner?: boolean;
  boxedMeals?: boolean;
  buffet?: boolean;
  estimatedCostPerPerson?: number;
}

export interface PlaceCapacity {
  maxPartySize?: number;
  idealPartySizeMin?: number;
  idealPartySizeMax?: number;
}

export interface Place {
  id: string;
  category: PlaceCategory;
  name: string;
  address: string;
  location: LatLng;
  universityId: string;
  external: PlaceExternalRef;
  athletics: AthleticsProfile;
  capacity: PlaceCapacity;
  hotel?: HotelDetails;
  restaurant?: RestaurantDetails;
  store?: StoreDetails;
  caterer?: CatererDetails;
  tags: string[];
}
