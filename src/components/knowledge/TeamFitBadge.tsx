import { cn } from "@/lib/utils";

function toneForScore(score: number): { ring: string; text: string; label: string } {
  if (score >= 85) return { ring: "border-fit-great", text: "text-fit-great", label: "Excellent fit" };
  if (score >= 65) return { ring: "border-fit-good", text: "text-fit-good", label: "Good fit" };
  return { ring: "border-fit-low", text: "text-fit-low", label: "Limited fit" };
}

export function TeamFitBadge({ score, size = "md" }: { score: number; size?: "sm" | "md" }) {
  const tone = toneForScore(score);
  const dims = size === "sm" ? "h-9 w-9 text-xs" : "h-12 w-12 text-sm";

  return (
    <div className="flex flex-col items-center gap-1" title={tone.label}>
      <div
        className={cn(
          "flex items-center justify-center rounded-full border-[2.5px] bg-white font-semibold shadow-card",
          dims,
          tone.ring,
          tone.text
        )}
      >
        {score}
      </div>
      {size === "md" && <span className="text-[10px] font-medium uppercase tracking-wide text-ink-500">Team Fit</span>}
    </div>
  );
}
