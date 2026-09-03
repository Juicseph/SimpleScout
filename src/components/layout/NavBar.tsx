"use client";

import { Compass, MapPinned, Route, User, Users2 } from "lucide-react";
import { useTripStore } from "@/state/tripStore";
import { UNIVERSITIES } from "@/data/universities";
import { totalTravelers } from "@/models";

const LINKS = [
  { label: "Explore", icon: Compass },
  { label: "Trips", icon: Route },
  { label: "Saved", icon: MapPinned },
  { label: "Department", icon: Users2 },
  { label: "Network", icon: Users2 },
];

export function NavBar() {
  const { context, hasSearched } = useTripStore();
  const destination = UNIVERSITIES.find((u) => u.id === context.destinationUniversityId);

  return (
    <header className="sticky top-0 z-50 hidden border-b border-sand-200 bg-white/90 backdrop-blur md:block">
      <div className="mx-auto flex max-w-7xl items-center justify-between px-8 py-3.5">
        <div className="flex items-center gap-8">
          <span className="text-lg font-bold tracking-tight text-brand-600">SimpleScout</span>
          <nav className="flex items-center gap-1">
            {LINKS.map((link) => (
              <button
                key={link.label}
                className="flex items-center gap-1.5 rounded-full px-3.5 py-2 text-[13.5px] font-medium text-ink-700 transition-colors hover:bg-sand-100 first:text-ink-950 first:bg-sand-100"
              >
                <link.icon className="h-4 w-4" />
                {link.label}
              </button>
            ))}
          </nav>
        </div>

        <div className="flex items-center gap-3">
          {hasSearched && destination && (
            <div className="flex items-center gap-2 rounded-full border border-sand-300 px-3.5 py-1.5 text-[13px] font-medium text-ink-700">
              <span className="h-1.5 w-1.5 rounded-full bg-emerald-500" />
              {destination.abbreviation} · {totalTravelers(context.travelParty)} traveling
            </div>
          )}
          <button className="flex h-9 w-9 items-center justify-center rounded-full bg-sand-200 text-ink-700">
            <User className="h-4.5 w-4.5" />
          </button>
        </div>
      </div>
    </header>
  );
}
