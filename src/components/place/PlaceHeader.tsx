"use client";

import { useState } from "react";
import { Heart, MapPin, Navigation, Share2, Star, ThumbsUp } from "lucide-react";
import { PhotoTile } from "@/components/ui/PhotoTile";
import { TeamFitBadge } from "@/components/knowledge/TeamFitBadge";
import { Button } from "@/components/ui/Button";
import type { Place } from "@/models";
import type { TeamFitResult } from "@/core/teamFitScore/teamFitScore";

export function PlaceHeader({
  place,
  fit,
  distanceMi,
  driveMinutes,
  athleticsRating,
}: {
  place: Place;
  fit: TeamFitResult;
  distanceMi: number;
  driveMinutes: number;
  athleticsRating?: number;
}) {
  const [saved, setSaved] = useState(false);

  return (
    <section className="overflow-hidden rounded-xl3 border border-sand-200 bg-white shadow-card">
      <PhotoTile theme={place.external.photoTheme} className="h-56 w-full md:h-72" />
      <div className="space-y-4 p-5 md:p-7">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <h1 className="text-2xl font-extrabold text-ink-950">{place.name}</h1>
            <p className="mt-1 text-[13.5px] text-ink-500">{place.address}</p>
          </div>
          <TeamFitBadge score={fit.score} />
        </div>

        <div className="flex flex-wrap items-center gap-x-4 gap-y-1.5 text-[13.5px] text-ink-700">
          <span className="flex items-center gap-1">
            <Star className="h-4 w-4 fill-amber-400 text-amber-400" />
            {place.external.publicRating?.toFixed(1) ?? "—"} public
          </span>
          {athleticsRating && (
            <span className="rounded-full bg-brand-50 px-2 py-0.5 text-[12px] font-semibold text-brand-700">
              Athletics {athleticsRating.toFixed(1)}
            </span>
          )}
          <span className="flex items-center gap-1 text-ink-500">
            <MapPin className="h-4 w-4" />
            {distanceMi.toFixed(1)} mi
          </span>
          <span className="flex items-center gap-1 text-ink-500">
            <Navigation className="h-4 w-4" />
            {driveMinutes} min drive
          </span>
        </div>

        <p className="text-[13.5px] text-ink-700">{fit.headline}</p>

        <div className="flex flex-wrap gap-2 pt-1">
          <Button variant="outline" size="sm" onClick={() => setSaved((s) => !s)}>
            <Heart className={saved ? "h-4 w-4 fill-brand-600 text-brand-600" : "h-4 w-4"} />
            {saved ? "Saved" : "Save"}
          </Button>
          <Button variant="outline" size="sm">
            <Share2 className="h-4 w-4" />
            Share
          </Button>
          <Button variant="outline" size="sm">
            <ThumbsUp className="h-4 w-4" />
            Recommend
          </Button>
        </div>
      </div>
    </section>
  );
}
