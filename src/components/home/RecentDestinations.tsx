"use client";

import { UNIVERSITIES } from "@/data/universities";
import { useTripStore } from "@/state/tripStore";
import { cn } from "@/lib/utils";

export function RecentDestinations() {
  const { setDestination, context } = useTripStore();

  return (
    <section>
      <h2 className="mb-3 text-lg font-bold text-ink-950">Recent Destinations</h2>
      <div className="no-scrollbar flex gap-3 overflow-x-auto pb-1">
        {UNIVERSITIES.map((u) => (
          <button
            key={u.id}
            onClick={() => setDestination(u.id)}
            className={cn(
              "flex shrink-0 flex-col items-start gap-2 rounded-xl2 border px-4 py-3 text-left transition-colors",
              u.id === context.destinationUniversityId
                ? "border-brand-600 bg-brand-50"
                : "border-sand-200 bg-white hover:border-ink-700"
            )}
          >
            <span
              className="flex h-9 w-9 items-center justify-center rounded-full text-[12px] font-bold text-white"
              style={{ backgroundColor: u.primaryColor }}
            >
              {u.abbreviation.slice(0, 3)}
            </span>
            <span className="text-[13px] font-semibold text-ink-950">{u.name}</span>
            <span className="text-[11.5px] text-ink-500">
              {u.city}, {u.state}
            </span>
          </button>
        ))}
      </div>
    </section>
  );
}
