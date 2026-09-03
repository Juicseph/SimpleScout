"use client";

import { Minus, Plus } from "lucide-react";
import type { TravelParty } from "@/models";
import { totalTravelers } from "@/models";

const ROWS: { key: keyof TravelParty; label: string; hint: string }[] = [
  { key: "athletes", label: "Athletes", hint: "Roster traveling" },
  { key: "coaches", label: "Coaches", hint: "Head + assistant coaches" },
  { key: "staff", label: "Staff", hint: "Trainers, equipment, ops" },
];

export function WhoTravelingPanel({
  party,
  onChange,
}: {
  party: TravelParty;
  onChange: (party: TravelParty) => void;
}) {
  function step(key: keyof TravelParty, delta: number) {
    const next = Math.max(0, party[key] + delta);
    onChange({ ...party, [key]: next });
  }

  return (
    <div className="w-[300px] space-y-4 p-1">
      {ROWS.map((row) => (
        <div key={row.key} className="flex items-center justify-between">
          <div>
            <p className="text-[14px] font-medium text-ink-950">{row.label}</p>
            <p className="text-[12px] text-ink-500">{row.hint}</p>
          </div>
          <div className="flex items-center gap-3">
            <button
              onClick={() => step(row.key, -1)}
              className="flex h-7 w-7 items-center justify-center rounded-full border border-sand-300 text-ink-700 hover:border-ink-700 disabled:opacity-30"
              disabled={party[row.key] <= 0}
              aria-label={`Decrease ${row.label}`}
            >
              <Minus className="h-3.5 w-3.5" />
            </button>
            <span className="w-5 text-center text-[14px] font-semibold tabular-nums">{party[row.key]}</span>
            <button
              onClick={() => step(row.key, 1)}
              className="flex h-7 w-7 items-center justify-center rounded-full border border-sand-300 text-ink-700 hover:border-ink-700"
              aria-label={`Increase ${row.label}`}
            >
              <Plus className="h-3.5 w-3.5" />
            </button>
          </div>
        </div>
      ))}
      <div className="flex items-center justify-between border-t border-sand-200 pt-3">
        <span className="text-[13px] font-medium text-ink-700">Total Travel Party</span>
        <span className="text-[18px] font-bold text-ink-950">{totalTravelers(party)}</span>
      </div>
    </div>
  );
}
