"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Compass, MapPinned, Route, User, Users2 } from "lucide-react";
import { useTripStore } from "@/state/tripStore";
import { isTravelModeActive } from "@/models";
import { DEMO_TRIP } from "@/data/trip";
import { cn } from "@/lib/utils";

export function BottomNav() {
  const { context, hasSearched } = useTripStore();
  const pathname = usePathname();
  const travelModeActive = hasSearched && isTravelModeActive({ startDate: context.startDate, endDate: context.endDate });

  const items = [
    { label: "Explore", icon: Compass, href: "/" },
    { label: travelModeActive ? "Travel Mode" : "Trips", icon: Route, href: `/trips/${DEMO_TRIP.id}`, highlight: travelModeActive },
    { label: "Saved", icon: MapPinned, href: undefined },
    { label: "Network", icon: Users2, href: undefined },
    { label: "Profile", icon: User, href: undefined },
  ];

  return (
    <nav className="fixed inset-x-0 bottom-0 z-50 border-t border-sand-200 bg-white/95 backdrop-blur md:hidden">
      <div className="mx-auto flex max-w-md items-center justify-around px-2 py-2">
        {items.map((item) => {
          const isCurrent = item.href ? pathname === item.href : false;
          const className = cn(
            "flex flex-1 flex-col items-center gap-1 rounded-xl py-1.5 text-[11px] font-medium",
            item.highlight ? "text-brand-600" : isCurrent ? "text-ink-950" : "text-ink-500"
          );
          const content = (
            <>
              <span className={cn("flex h-8 w-8 items-center justify-center rounded-full", item.highlight && "bg-brand-100")}>
                <item.icon className="h-4.5 w-4.5" />
              </span>
              {item.label}
            </>
          );
          return item.href ? (
            <Link key={item.label} href={item.href} className={className}>
              {content}
            </Link>
          ) : (
            <button key={item.label} className={className}>
              {content}
            </button>
          );
        })}
      </div>
    </nav>
  );
}
