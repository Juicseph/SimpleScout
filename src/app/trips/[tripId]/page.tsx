"use client";

import { useState } from "react";
import { notFound } from "next/navigation";
import { getTripById } from "@/data/trip";
import { TripBoardHeader } from "@/components/trip/TripBoardHeader";
import { TripBoardView } from "@/components/trip/TripBoardView";
import { TripItineraryView } from "@/components/trip/TripItineraryView";
import { cn } from "@/lib/utils";

type Tab = "board" | "itinerary";

export default function TripBoardPage({ params }: { params: { tripId: string } }) {
  const trip = getTripById(params.tripId);
  const [tab, setTab] = useState<Tab>("board");

  if (!trip) return notFound();

  return (
    <main className="mx-auto max-w-3xl space-y-6 px-4 py-6 md:px-8 md:py-8">
      <TripBoardHeader trip={trip} />

      <div className="flex gap-1 rounded-full bg-sand-100 p-1">
        {(["board", "itinerary"] as Tab[]).map((t) => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={cn(
              "flex-1 rounded-full py-2 text-[13.5px] font-semibold capitalize transition-colors",
              tab === t ? "bg-white text-ink-950 shadow-card" : "text-ink-500"
            )}
          >
            {t === "board" ? "Trip Board" : "Itinerary"}
          </button>
        ))}
      </div>

      {tab === "board" ? <TripBoardView trip={trip} /> : <TripItineraryView trip={trip} />}
    </main>
  );
}
