import { Ambulance, Dumbbell, Flame, Hotel, ShoppingBasket, Soup, UtensilsCrossed } from "lucide-react";
import type { TripPlaceSection } from "@/models";

export const SECTION_CONFIG: Record<TripPlaceSection, { label: string; icon: typeof Hotel }> = {
  hotel: { label: "Hotel", icon: Hotel },
  team_dinner: { label: "Team Dinner", icon: UtensilsCrossed },
  pregame_meal: { label: "Pregame Meal", icon: Soup },
  postgame_meal: { label: "Postgame Meal", icon: Soup },
  catering: { label: "Catering", icon: Flame },
  grocery: { label: "Grocery", icon: ShoppingBasket },
  equipment: { label: "Equipment", icon: Dumbbell },
  emergency_resources: { label: "Emergency Resources", icon: Ambulance },
};

export const SECTION_ORDER: TripPlaceSection[] = [
  "hotel",
  "team_dinner",
  "pregame_meal",
  "postgame_meal",
  "catering",
  "grocery",
  "equipment",
  "emergency_resources",
];
