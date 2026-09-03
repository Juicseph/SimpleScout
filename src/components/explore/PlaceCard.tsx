"use client";

import { useState } from "react";
import Link from "next/link";
import { Heart, MapPin, Navigation, Star } from "lucide-react";
import { PhotoTile } from "@/components/ui/PhotoTile";
import { TeamFitBadge } from "@/components/knowledge/TeamFitBadge";
import { PlaceBadges } from "@/components/knowledge/PlaceBadges";
import { KnowledgeStrip } from "@/components/knowledge/KnowledgeStrip";
import type { RankedPlace } from "@/core/ranking/rankingPipeline";
import { cn } from "@/lib/utils";

function subtitleFor(ranked: RankedPlace): string {
  const { place } = ranked;
  if (place.hotel) return `Hotel · ${place.hotel.totalRooms ?? "—"} rooms`;
  if (place.restaurant) return place.restaurant.cuisine;
  if (place.caterer) return "Catering";
  if (place.store) return place.store.storeType.replace("_", " ");
  return place.category;
}

const PRICE_SYMBOLS = ["$", "$$", "$$$", "$$$$"];

export function PlaceCard({ ranked, highlighted }: { ranked: RankedPlace; highlighted?: boolean }) {
  const [saved, setSaved] = useState(false);
  const { place, fit, distanceMi, driveMinutes, knowledge } = ranked;

  return (
    <Link
      href={`/place/${place.id}`}
      className={cn(
        "group block overflow-hidden rounded-xl2 border bg-white shadow-card transition-shadow hover:shadow-pop",
        highlighted ? "border-brand-500 ring-2 ring-brand-100" : "border-sand-200"
      )}
    >
      <div className="relative">
        <PhotoTile theme={place.external.photoTheme} className="h-40 w-full" />
        <button
          onClick={(e) => {
            e.preventDefault();
            e.stopPropagation();
            setSaved((s) => !s);
          }}
          aria-label="Save place"
          className="absolute right-3 top-3 flex h-8 w-8 items-center justify-center rounded-full bg-white/90 shadow-card backdrop-blur transition-transform hover:scale-105"
        >
          <Heart className={cn("h-4 w-4", saved ? "fill-brand-600 text-brand-600" : "text-ink-700")} />
        </button>
        {!fit.fitsParty && (
          <div className="absolute bottom-3 left-3 rounded-full bg-ink-950/85 px-2.5 py-1 text-[11px] font-medium text-white">
            May be tight for your party
          </div>
        )}
      </div>

      <div className="space-y-3 p-4">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <h3 className="truncate text-[15px] font-semibold text-ink-950">{place.name}</h3>
            <p className="text-[13px] capitalize text-ink-500">{subtitleFor(ranked)}</p>
          </div>
          <TeamFitBadge score={fit.score} size="sm" />
        </div>

        <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-[13px] text-ink-700">
          <span className="flex items-center gap-1">
            <Star className="h-3.5 w-3.5 fill-amber-400 text-amber-400" />
            {place.external.publicRating?.toFixed(1) ?? "—"}
            {knowledge?.athleticsRating && (
              <span className="ml-1 rounded-full bg-brand-50 px-1.5 py-0.5 text-[11px] font-semibold text-brand-700">
                Athletics {knowledge.athleticsRating.toFixed(1)}
              </span>
            )}
          </span>
          <span className="flex items-center gap-1 text-ink-500">
            <MapPin className="h-3.5 w-3.5" />
            {distanceMi.toFixed(1)} mi
          </span>
          <span className="flex items-center gap-1 text-ink-500">
            <Navigation className="h-3.5 w-3.5" />
            {driveMinutes} min
          </span>
          {place.external.priceLevel != null && (
            <span className="text-ink-500">{PRICE_SYMBOLS[place.external.priceLevel]}</span>
          )}
        </div>

        <PlaceBadges tags={place.tags} />
        <p className="text-[12.5px] text-ink-500">{fit.headline}</p>
        <KnowledgeStrip knowledge={knowledge} />
      </div>
    </Link>
  );
}
