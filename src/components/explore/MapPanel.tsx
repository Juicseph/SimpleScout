"use client";

import { useMemo } from "react";
import { MapPin, Navigation2 } from "lucide-react";
import type { LatLng } from "@/models";
import type { RankedPlace } from "@/core/ranking/rankingPipeline";
import { cn } from "@/lib/utils";

interface Projected {
  ranked: RankedPlace;
  x: number;
  y: number;
}

function project(points: LatLng[], anchor: LatLng, padding = 0.12): { toXY: (p: LatLng) => { x: number; y: number } } {
  const all = [...points, anchor];
  const lats = all.map((p) => p.lat);
  const lngs = all.map((p) => p.lng);
  const minLat = Math.min(...lats);
  const maxLat = Math.max(...lats);
  const minLng = Math.min(...lngs);
  const maxLng = Math.max(...lngs);
  const latSpan = Math.max(maxLat - minLat, 0.01);
  const lngSpan = Math.max(maxLng - minLng, 0.01);

  return {
    toXY: (p) => {
      const nx = (p.lng - minLng) / lngSpan;
      const ny = 1 - (p.lat - minLat) / latSpan;
      const range = 1 - padding * 2;
      return { x: padding + nx * range, y: padding + ny * range };
    },
  };
}

export function MapPanel({
  places,
  anchor,
  selectedId,
  onSelect,
}: {
  places: RankedPlace[];
  anchor: LatLng;
  selectedId?: string;
  onSelect?: (placeId: string) => void;
}) {
  const projected: Projected[] = useMemo(() => {
    const { toXY } = project(
      places.map((r) => r.place.location),
      anchor
    );
    return places.map((ranked) => ({ ranked, ...toXY(ranked.place.location) }));
  }, [places, anchor]);

  const anchorXY = useMemo(() => {
    const { toXY } = project(
      places.map((r) => r.place.location),
      anchor
    );
    return toXY(anchor);
  }, [places, anchor]);

  return (
    <div className="relative h-full min-h-[420px] w-full overflow-hidden rounded-xl2 border border-sand-200 bg-sand-100">
      <svg className="absolute inset-0 h-full w-full" preserveAspectRatio="none">
        <defs>
          <pattern id="grid" width="7%" height="7%" patternUnits="userSpaceOnUse">
            <path d="M 0 0 L 0 40 M 0 0 L 40 0" fill="none" stroke="#e9e0d1" strokeWidth="1" />
          </pattern>
        </defs>
        <rect width="100%" height="100%" fill="url(#grid)" />
      </svg>

      <div
        className="absolute z-10 flex -translate-x-1/2 -translate-y-1/2 flex-col items-center"
        style={{ left: `${anchorXY.x * 100}%`, top: `${anchorXY.y * 100}%` }}
      >
        <div className="flex h-8 w-8 items-center justify-center rounded-full bg-ink-950 text-white shadow-pop">
          <Navigation2 className="h-4 w-4" />
        </div>
        <span className="mt-1 rounded-full bg-ink-950 px-2 py-0.5 text-[10px] font-medium text-white">Anchor</span>
      </div>

      {projected.map(({ ranked, x, y }) => {
        const isSelected = ranked.place.id === selectedId;
        return (
          <button
            key={ranked.place.id}
            onClick={() => onSelect?.(ranked.place.id)}
            className={cn(
              "absolute z-20 flex -translate-x-1/2 -translate-y-full flex-col items-center transition-transform hover:scale-110",
              isSelected && "scale-110"
            )}
            style={{ left: `${x * 100}%`, top: `${y * 100}%` }}
          >
            <div
              className={cn(
                "flex h-9 items-center gap-1 rounded-full border px-2.5 shadow-card",
                isSelected ? "border-brand-600 bg-brand-600 text-white" : "border-sand-300 bg-white text-ink-950"
              )}
            >
              <MapPin className="h-3.5 w-3.5" />
              <span className="text-[11px] font-semibold">{ranked.fit.score}</span>
            </div>
          </button>
        );
      })}

      <div className="pointer-events-none absolute bottom-3 left-3 rounded-full bg-white/90 px-3 py-1 text-[11px] font-medium text-ink-500 shadow-card">
        Map view · demo data
      </div>
    </div>
  );
}
