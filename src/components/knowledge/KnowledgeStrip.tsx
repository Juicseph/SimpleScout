import { BookOpenCheck, MessageSquareQuote, Users2 } from "lucide-react";
import type { KnowledgeSummary } from "@/models";

export function KnowledgeStrip({ knowledge }: { knowledge?: KnowledgeSummary }) {
  if (!knowledge) return null;

  const visits = knowledge.departmentVisits;
  const note = knowledge.topNotes[0];

  return (
    <div className="space-y-1.5 rounded-xl bg-sand-100 px-3 py-2">
      {visits && visits.visitCount > 0 && (
        <div className="flex items-center gap-1.5 text-[12.5px] font-medium text-ink-700">
          <Users2 className="h-3.5 w-3.5 shrink-0 text-brand-600" strokeWidth={2} />
          Your department has used this {visits.visitCount}x —{" "}
          {Array.from(new Set(visits.visits.map((v) => v.teamName))).join(", ")}
        </div>
      )}
      {knowledge.networkSignal && (
        <div className="flex items-center gap-1.5 text-[12.5px] font-medium text-ink-700">
          <BookOpenCheck className="h-3.5 w-3.5 shrink-0 text-brand-600" strokeWidth={2} />
          {knowledge.networkSignal.teamsUsedCount} verified teams used this ·{" "}
          {knowledge.networkSignal.recommendCount} recommend it
        </div>
      )}
      {note && (
        <div className="flex items-start gap-1.5 text-[12.5px] text-ink-500">
          <MessageSquareQuote className="mt-0.5 h-3.5 w-3.5 shrink-0 text-ink-500" strokeWidth={2} />
          <span className="italic">&ldquo;{note.body}&rdquo;</span>
        </div>
      )}
    </div>
  );
}
