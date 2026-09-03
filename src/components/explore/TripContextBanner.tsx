"use client";

import Link from "next/link";
import { CalendarDays, ClipboardList, MapPin, Users, Zap } from "lucide-react";
import { UNIVERSITIES } from "@/data/universities";
import { useTripStore } from "@/state/tripStore";
import { totalTravelers } from "@/models";
import { formatDateRange } from "@/lib/utils";
import { DEMO_TRIP } from "@/data/trip";

const SPORT_LABELS: Record<string, string> = {
  volleyball: "Volleyball",
  basketball: "Basketball",
  football: "Football",
  soccer: "Soccer",
  baseball: "Baseball",
  softball: "Softball",
  track_and_field: "Track & Field",
  swimming: "Swimming",
  tennis: "Tennis",
  golf: "Golf",
  wrestling: "Wrestling",
  other: "Other",
};

export function TripContextBanner({ onFeedTeamFast }: { onFeedTeamFast: () => void }) {
  const { context } = useTripStore();
  const destination = UNIVERSITIES.find((u) => u.id === context.destinationUniversityId);
  const partySize = totalTravelers(context.travelParty);

  if (!destination) return null;

  return (
    <section className="overflow-hidden rounded-xl3 border border-sand-200 bg-white shadow-card">
      <div
        className="flex flex-col gap-4 p-6 text-white md:flex-row md:items-center md:justify-between"
        style={{ background: `linear-gradient(135deg, ${destination.primaryColor}, #1f1a14)` }}
      >
        <div>
          <p className="text-[12.5px] font-semibold uppercase tracking-wide text-white/70">
            {SPORT_LABELS[context.sport]} · Destination Hub
          </p>
          <h1 className="mt-1 text-2xl font-extrabold md:text-3xl">{destination.name}</h1>
          <p className="text-[13.5px] text-white/80">
            {destination.city}, {destination.state}
          </p>
        </div>
        <div className="flex flex-wrap gap-4 text-[13.5px]">
          <span className="flex items-center gap-1.5">
            <CalendarDays className="h-4 w-4" />
            {formatDateRange(context.startDate, context.endDate)}
          </span>
          <span className="flex items-center gap-1.5">
            <Users className="h-4 w-4" />
            {partySize} Travelers
          </span>
          <span className="flex items-center gap-1.5">
            <MapPin className="h-4 w-4" />
            Covelli Center
          </span>
        </div>
      </div>
      <div className="flex flex-wrap items-center justify-between gap-3 bg-sand-50 px-6 py-3.5">
        <p className="text-[12.5px] text-ink-500">
          SimpleScout is prioritizing every result below for a party of <strong>{partySize}</strong>.
        </p>
        <div className="flex flex-wrap gap-2">
          <Link
            href={`/trips/${DEMO_TRIP.id}`}
            className="flex items-center gap-1.5 rounded-full border border-sand-300 bg-white px-4 py-2 text-[13px] font-semibold text-ink-950 hover:border-ink-700"
          >
            <ClipboardList className="h-3.5 w-3.5" />
            View Trip Board
          </Link>
          <button
            onClick={onFeedTeamFast}
            className="flex items-center gap-1.5 rounded-full bg-ink-950 px-4 py-2 text-[13px] font-semibold text-white hover:bg-ink-900"
          >
            <Zap className="h-3.5 w-3.5" />
            Feed {partySize} People Fast
          </button>
        </div>
      </div>
    </section>
  );
}
