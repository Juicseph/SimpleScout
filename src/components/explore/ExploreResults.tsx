"use client";

import { useEffect, useMemo, useState } from "react";
import { List, Map as MapIcon } from "lucide-react";
import { searchPlaces } from "@/services/search/searchService";
import type { RankedPlace } from "@/core/ranking/rankingPipeline";
import { useTripStore } from "@/state/tripStore";
import { CATEGORY_CONFIG, matchesExploreCategory, type ExploreCategory } from "@/lib/categories";
import { PlaceCard } from "./PlaceCard";
import { MapPanel } from "./MapPanel";
import { CanFitTeamToggle } from "./CanFitTeamToggle";
import { EmptyState } from "@/components/ui/EmptyState";
import { PlaceCardSkeleton } from "@/components/ui/Skeleton";
import { totalTravelers } from "@/models";
import { OHIO_STATE } from "@/data/universities";

export function ExploreResults({ category }: { category: ExploreCategory }) {
  const { context, canFitTeamOnly, toggleCanFitTeam } = useTripStore();
  const [ranked, setRanked] = useState<RankedPlace[] | null>(null);
  const [mobileView, setMobileView] = useState<"list" | "map">("list");
  const [selectedId, setSelectedId] = useState<string | undefined>();

  const config = CATEGORY_CONFIG[category];

  useEffect(() => {
    let cancelled = false;
    setRanked(null);
    searchPlaces({
      universityId: context.destinationUniversityId,
      category: config.category,
      travelParty: context.travelParty,
      anchor: context.anchor,
      currentHotelPlaceId: context.currentHotelPlaceId,
      requirePartyFit: canFitTeamOnly,
    }).then((results) => {
      if (cancelled) return;
      setRanked(results.filter((r) => matchesExploreCategory(r.place, category)));
    });
    return () => {
      cancelled = true;
    };
  }, [category, config.category, context, canFitTeamOnly]);

  const anchor = useMemo(() => OHIO_STATE.location, []);
  const partySize = totalTravelers(context.travelParty);

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-ink-950">{config.label}</h2>
          <p className="text-[13px] text-ink-500">
            Ranked for your party of {partySize} · {ranked?.length ?? "…"} results
          </p>
        </div>
        <div className="flex items-center gap-2">
          <CanFitTeamToggle checked={canFitTeamOnly} onChange={toggleCanFitTeam} partySize={partySize} />
          <div className="flex overflow-hidden rounded-full border border-sand-300 md:hidden">
            <button
              onClick={() => setMobileView("list")}
              className={`flex items-center gap-1 px-3 py-1.5 text-[12.5px] font-medium ${mobileView === "list" ? "bg-ink-950 text-white" : "text-ink-700"}`}
            >
              <List className="h-3.5 w-3.5" /> List
            </button>
            <button
              onClick={() => setMobileView("map")}
              className={`flex items-center gap-1 px-3 py-1.5 text-[12.5px] font-medium ${mobileView === "map" ? "bg-ink-950 text-white" : "text-ink-700"}`}
            >
              <MapIcon className="h-3.5 w-3.5" /> Map
            </button>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-5 md:grid-cols-[1.1fr_1fr]">
        <div className={`space-y-4 ${mobileView === "map" ? "hidden md:block" : ""}`}>
          {ranked === null && (
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              {[0, 1, 2, 3].map((i) => (
                <PlaceCardSkeleton key={i} />
              ))}
            </div>
          )}
          {ranked?.length === 0 && (
            <EmptyState
              title={`No ${config.label.toLowerCase()} found yet`}
              description="Try widening your search radius or turning off “Can Fit Our Team” to see every option."
            />
          )}
          {ranked && ranked.length > 0 && (
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              {ranked.map((r) => (
                <div key={r.place.id} onMouseEnter={() => setSelectedId(r.place.id)}>
                  <PlaceCard ranked={r} highlighted={r.place.id === selectedId} />
                </div>
              ))}
            </div>
          )}
        </div>

        <div className={`${mobileView === "list" ? "hidden md:block" : ""}`}>
          <div className="sticky top-20">
            {ranked && (
              <MapPanel places={ranked} anchor={anchor} selectedId={selectedId} onSelect={setSelectedId} />
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
