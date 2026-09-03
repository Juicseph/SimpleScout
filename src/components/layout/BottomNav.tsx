"use client";

import { Compass, MapPinned, Route, User, Users2 } from "lucide-react";
import { useTripStore } from "@/state/tripStore";
import { isTravelModeActive } from "@/models";
import { cn } from "@/lib/utils";

export function BottomNav() {
  const { context, hasSearched } = useTripStore();
  const travelModeActive = hasSearched && isTravelModeActive({ startDate: context.startDate, endDate: context.endDate });

  const items = [
    { label: "Explore", icon: Compass, current: true },
    { label: travelModeActive ? "Travel Mode" : "Trips", icon: Route, highlight: travelModeActive },
    { label: "Saved", icon: MapPinned },
    { label: "Network", icon: Users2 },
    { label: "Profile", icon: User },
  ];

  return (
    <nav className="fixed inset-x-0 bottom-0 z-50 border-t border-sand-200 bg-white/95 backdrop-blur md:hidden">
      <div className="mx-auto flex max-w-md items-center justify-around px-2 py-2">
        {items.map((item) => (
          <button
            key={item.label}
            className={cn(
              "flex flex-1 flex-col items-center gap-1 rounded-xl py-1.5 text-[11px] font-medium",
              item.highlight ? "text-brand-600" : item.current ? "text-ink-950" : "text-ink-500"
            )}
          >
            <span
              className={cn(
                "flex h-8 w-8 items-center justify-center rounded-full",
                item.highlight && "bg-brand-100"
              )}
            >
              <item.icon className="h-4.5 w-4.5" />
            </span>
            {item.label}
          </button>
        ))}
      </div>
    </nav>
  );
}
