"use client";

import { useState } from "react";
import { Search, Trophy, Users } from "lucide-react";
import { useTripStore } from "@/state/tripStore";
import { UNIVERSITIES, findUniversityBySlug } from "@/data/universities";
import { totalTravelers, type Sport } from "@/models";
import { formatDateRange } from "@/lib/utils";
import { WhoTravelingPanel } from "./WhoTravelingPanel";
import { cn } from "@/lib/utils";

type FieldKey = "where" | "when" | "who" | "from" | "sport" | null;

const SPORTS: Sport[] = [
  "volleyball",
  "basketball",
  "football",
  "soccer",
  "baseball",
  "softball",
  "track_and_field",
  "swimming",
  "tennis",
  "golf",
  "wrestling",
  "other",
];

function sportLabel(sport: Sport): string {
  return sport
    .split("_")
    .map((w) => w[0]?.toUpperCase() + w.slice(1))
    .join(" ");
}

export function SearchModule() {
  const { context, setDestination, setDates, setTravelParty, setSport, setStartingFrom, runSearch } =
    useTripStore();
  const [active, setActive] = useState<FieldKey>(null);

  const destination = UNIVERSITIES.find((u) => u.id === context.destinationUniversityId);
  const startingFrom = UNIVERSITIES.find((u) => u.id === context.startingUniversityId);

  function toggle(field: FieldKey) {
    setActive((cur) => (cur === field ? null : field));
  }

  function handleSearch() {
    setActive(null);
    runSearch();
  }

  return (
    <div className="relative mx-auto w-full max-w-3xl">
      {active && <div className="fixed inset-0 z-30" onClick={() => setActive(null)} />}

      <div className="relative z-40 flex flex-col divide-y divide-sand-200 overflow-visible rounded-xl3 border border-sand-200 bg-white shadow-pop md:flex-row md:divide-x md:divide-y-0">
        <SearchSegment
          label="Where are you going?"
          value={destination ? `${destination.name}` : "Search universities"}
          active={active === "where"}
          onClick={() => toggle("where")}
        >
          <div className="w-72 space-y-1 p-1">
            {UNIVERSITIES.map((u) => (
              <button
                key={u.id}
                onClick={() => {
                  setDestination(u.id);
                  setActive("when");
                }}
                className={cn(
                  "flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-[14px] hover:bg-sand-100",
                  u.id === context.destinationUniversityId && "bg-brand-50 text-brand-700"
                )}
              >
                <span className="font-medium">{u.name}</span>
                <span className="text-ink-500">
                  {u.city}, {u.state}
                </span>
              </button>
            ))}
          </div>
        </SearchSegment>

        <SearchSegment
          label="When?"
          value={formatDateRange(context.startDate, context.endDate)}
          active={active === "when"}
          onClick={() => toggle("when")}
        >
          <div className="w-72 space-y-3 p-2">
            <label className="block text-[12px] font-medium text-ink-500">
              Depart
              <input
                type="date"
                value={context.startDate}
                onChange={(e) => setDates(e.target.value, context.endDate)}
                className="mt-1 w-full rounded-lg border border-sand-300 px-2 py-1.5 text-[14px]"
              />
            </label>
            <label className="block text-[12px] font-medium text-ink-500">
              Return
              <input
                type="date"
                value={context.endDate}
                min={context.startDate}
                onChange={(e) => setDates(context.startDate, e.target.value)}
                className="mt-1 w-full rounded-lg border border-sand-300 px-2 py-1.5 text-[14px]"
              />
            </label>
          </div>
        </SearchSegment>

        <SearchSegment
          label="Who's traveling?"
          value={`${totalTravelers(context.travelParty)} total`}
          icon={<Users className="h-4 w-4" />}
          active={active === "who"}
          onClick={() => toggle("who")}
        >
          <WhoTravelingPanel party={context.travelParty} onChange={setTravelParty} />
        </SearchSegment>

        <SearchSegment
          label="Starting from"
          value={startingFrom?.name ?? "Add origin"}
          active={active === "from"}
          onClick={() => toggle("from")}
        >
          <div className="w-64 space-y-1 p-1">
            {UNIVERSITIES.filter((u) => u.id !== context.destinationUniversityId).map((u) => (
              <button
                key={u.id}
                onClick={() => {
                  setStartingFrom(u.id);
                  setActive(null);
                }}
                className={cn(
                  "flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-[14px] hover:bg-sand-100",
                  u.id === context.startingUniversityId && "bg-brand-50 text-brand-700"
                )}
              >
                {u.name}
              </button>
            ))}
          </div>
        </SearchSegment>

        <SearchSegment
          label="Sport"
          value={sportLabel(context.sport)}
          icon={<Trophy className="h-4 w-4" />}
          active={active === "sport"}
          onClick={() => toggle("sport")}
          last
        >
          <div className="grid w-64 grid-cols-2 gap-1 p-1">
            {SPORTS.map((sport) => (
              <button
                key={sport}
                onClick={() => {
                  setSport(sport);
                  setActive(null);
                }}
                className={cn(
                  "rounded-lg px-3 py-2 text-left text-[13px] hover:bg-sand-100",
                  sport === context.sport && "bg-brand-50 text-brand-700"
                )}
              >
                {sportLabel(sport)}
              </button>
            ))}
          </div>
        </SearchSegment>

        <div className="flex items-center justify-center p-3 md:pl-2">
          <button
            onClick={handleSearch}
            className="flex h-12 w-full items-center justify-center gap-2 rounded-full bg-brand-600 px-6 font-semibold text-white shadow-card transition-colors hover:bg-brand-700 md:w-12"
          >
            <Search className="h-4.5 w-4.5" />
            <span className="md:hidden">Search</span>
          </button>
        </div>
      </div>
    </div>
  );
}

function SearchSegment({
  label,
  value,
  icon,
  active,
  last,
  onClick,
  children,
}: {
  label: string;
  value: string;
  icon?: React.ReactNode;
  active: boolean;
  last?: boolean;
  onClick: () => void;
  children: React.ReactNode;
}) {
  return (
    <div className="relative flex-1">
      <button
        onClick={onClick}
        className={cn(
          "flex w-full flex-col gap-0.5 px-5 py-3 text-left transition-colors hover:bg-sand-50",
          active && "bg-sand-50",
          !last && "md:rounded-none"
        )}
      >
        <span className="text-[11px] font-semibold uppercase tracking-wide text-ink-500">{label}</span>
        <span className="flex items-center gap-1.5 truncate text-[14px] font-medium text-ink-950">
          {icon}
          {value}
        </span>
      </button>
      {active && (
        <div className="absolute left-0 top-full z-50 mt-2 rounded-xl2 border border-sand-200 bg-white shadow-pop">
          {children}
        </div>
      )}
    </div>
  );
}
