"use client";

import { Users } from "lucide-react";
import { cn } from "@/lib/utils";

export function CanFitTeamToggle({
  checked,
  onChange,
  partySize,
}: {
  checked: boolean;
  onChange: () => void;
  partySize: number;
}) {
  return (
    <button
      onClick={onChange}
      className={cn(
        "flex items-center gap-2 rounded-full border px-3.5 py-1.5 text-[12.5px] font-semibold transition-colors",
        checked ? "border-brand-600 bg-brand-50 text-brand-700" : "border-sand-300 text-ink-700 hover:border-ink-700"
      )}
    >
      <Users className="h-3.5 w-3.5" />
      Can Fit Our Team ({partySize})
      <span
        className={cn(
          "relative h-4 w-7 rounded-full transition-colors",
          checked ? "bg-brand-600" : "bg-sand-300"
        )}
      >
        <span
          className={cn(
            "absolute top-0.5 h-3 w-3 rounded-full bg-white transition-transform",
            checked ? "translate-x-3.5" : "translate-x-0.5"
          )}
        />
      </span>
    </button>
  );
}
