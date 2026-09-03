"use client";

import {
  Ambulance,
  Dumbbell,
  MoreHorizontal,
  Pill,
  Printer,
  ShoppingBasket,
  Soup,
  Truck,
  Tv,
} from "lucide-react";
import type { ExploreCategory } from "@/lib/categories";
import { cn } from "@/lib/utils";

const ITEMS: { label: string; icon: typeof Soup; target?: ExploreCategory }[] = [
  { label: "Food", icon: Soup, target: "quick_meals" },
  { label: "Pharmacy", icon: Pill, target: "pharmacy" },
  { label: "Equipment", icon: Dumbbell, target: "equipment" },
  { label: "Tech", icon: Tv, target: "tech" },
  { label: "Groceries", icon: ShoppingBasket, target: "groceries" },
  { label: "Medical", icon: Ambulance, target: "medical" },
  { label: "Printing", icon: Printer },
  { label: "Transportation", icon: Truck, target: "transportation" },
  { label: "Other", icon: MoreHorizontal },
];

export function NeedSomethingNow({ onSelect }: { onSelect: (category: ExploreCategory) => void }) {
  return (
    <section className="rounded-xl3 border border-sand-200 bg-ink-950 p-5 text-white md:p-7">
      <div className="mb-4 flex items-baseline justify-between">
        <h2 className="text-lg font-bold">Need Something Now?</h2>
        <span className="text-[12px] text-white/60">Open now · closest first</span>
      </div>
      <div className="grid grid-cols-3 gap-2.5 sm:grid-cols-5 md:grid-cols-9">
        {ITEMS.map((item) => (
          <button
            key={item.label}
            onClick={() => item.target && onSelect(item.target)}
            className={cn(
              "flex flex-col items-center gap-2 rounded-xl2 bg-white/10 px-2 py-3.5 text-[12px] font-medium transition-colors hover:bg-white/20",
              !item.target && "opacity-60"
            )}
          >
            <item.icon className="h-5 w-5" strokeWidth={1.75} />
            {item.label}
          </button>
        ))}
      </div>
    </section>
  );
}
