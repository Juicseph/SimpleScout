import type { Place, PlaceCategory } from "@/models";
import {
  Bus,
  Dumbbell,
  Flame,
  Hotel,
  Pill,
  ShoppingBasket,
  Soup,
  Stethoscope,
  Tv,
  UtensilsCrossed,
} from "lucide-react";

export type ExploreCategory =
  | "stay"
  | "team_meals"
  | "quick_meals"
  | "catering"
  | "groceries"
  | "equipment"
  | "tech"
  | "pharmacy"
  | "medical"
  | "transportation";

export const CATEGORY_CONFIG: Record<ExploreCategory, { label: string; icon: typeof Hotel; category: PlaceCategory }> = {
  stay: { label: "Stay", icon: Hotel, category: "hotel" },
  team_meals: { label: "Team Meals", icon: UtensilsCrossed, category: "restaurant" },
  quick_meals: { label: "Quick Meals", icon: Soup, category: "restaurant" },
  catering: { label: "Catering", icon: Flame, category: "caterer" },
  groceries: { label: "Groceries", icon: ShoppingBasket, category: "grocery" },
  equipment: { label: "Equipment", icon: Dumbbell, category: "store" },
  tech: { label: "Tech", icon: Tv, category: "store" },
  pharmacy: { label: "Pharmacy", icon: Pill, category: "pharmacy" },
  medical: { label: "Medical", icon: Stethoscope, category: "medical" },
  transportation: { label: "Transportation", icon: Bus, category: "transportation" },
};

export function matchesExploreCategory(place: Place, category: ExploreCategory): boolean {
  switch (category) {
    case "team_meals":
      return place.category === "restaurant" && !place.restaurant?.quickMealFriendly;
    case "quick_meals":
      return place.category === "restaurant" && !!place.restaurant?.quickMealFriendly;
    case "equipment":
      return place.category === "store" && place.store?.storeType === "sporting_goods";
    case "tech":
      return place.category === "store" && place.store?.storeType === "electronics";
    default:
      return place.category === CATEGORY_CONFIG[category].category;
  }
}
