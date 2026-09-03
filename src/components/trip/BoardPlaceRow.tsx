import Link from "next/link";
import { ChevronRight } from "lucide-react";
import { PhotoTile } from "@/components/ui/PhotoTile";
import { TeamFitBadge } from "@/components/knowledge/TeamFitBadge";
import type { Place } from "@/models";
import type { TeamFitResult } from "@/core/teamFitScore/teamFitScore";

export function BoardPlaceRow({ place, fit, note }: { place: Place; fit?: TeamFitResult; note?: string }) {
  return (
    <Link
      href={`/place/${place.id}`}
      className="group flex items-center gap-3 rounded-xl2 border border-sand-200 bg-white p-3 shadow-card transition-shadow hover:shadow-pop"
    >
      <PhotoTile theme={place.external.photoTheme} className="h-14 w-14 shrink-0 rounded-xl" />
      <div className="min-w-0 flex-1">
        <p className="truncate text-[14px] font-semibold text-ink-950">{place.name}</p>
        <p className="truncate text-[12.5px] text-ink-500">{place.address}</p>
        {note && <p className="mt-1 line-clamp-2 text-[12px] italic text-ink-500">&ldquo;{note}&rdquo;</p>}
      </div>
      {fit && <TeamFitBadge score={fit.score} size="sm" />}
      <ChevronRight className="h-4 w-4 shrink-0 text-ink-500 transition-transform group-hover:translate-x-0.5" />
    </Link>
  );
}
