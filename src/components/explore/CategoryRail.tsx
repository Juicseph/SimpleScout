"use client";

import { CATEGORY_CONFIG, type ExploreCategory } from "@/lib/categories";
import { cn } from "@/lib/utils";

const ORDER: ExploreCategory[] = [
  "stay",
  "team_meals",
  "quick_meals",
  "catering",
  "groceries",
  "equipment",
  "tech",
  "pharmacy",
  "medical",
  "transportation",
];

export function CategoryRail({
  active,
  onSelect,
}: {
  active: ExploreCategory;
  onSelect: (category: ExploreCategory) => void;
}) {
  return (
    <div className="no-scrollbar -mx-4 flex gap-2 overflow-x-auto px-4 pb-1 md:mx-0 md:px-0">
      {ORDER.map((key) => {
        const config = CATEGORY_CONFIG[key];
        const isActive = key === active;
        return (
          <button
            key={key}
            onClick={() => onSelect(key)}
            className={cn(
              "flex shrink-0 flex-col items-center gap-1.5 rounded-2xl border-b-2 px-3.5 py-2 text-[12.5px] font-medium transition-colors",
              isActive ? "border-ink-950 text-ink-950" : "border-transparent text-ink-500 hover:text-ink-950"
            )}
          >
            <config.icon className="h-5 w-5" strokeWidth={isActive ? 2.25 : 1.75} />
            {config.label}
          </button>
        );
      })}
    </div>
  );
}
