import { BookOpenCheck, Users2 } from "lucide-react";
import type { KnowledgeSummary } from "@/models";
import { EmptyState } from "@/components/ui/EmptyState";

export function PlaceAthleticsHistory({ knowledge }: { knowledge?: KnowledgeSummary }) {
  const visits = knowledge?.departmentVisits;

  if (!visits && !knowledge?.networkSignal) {
    return (
      <section>
        <h2 className="mb-3 text-[15px] font-bold text-ink-950">Athletics History</h2>
        <EmptyState
          title="No department history yet"
          description="Once your team travels here, visits and staff notes will show up in this section for every future trip."
        />
      </section>
    );
  }

  return (
    <section className="rounded-xl2 border border-sand-200 bg-white p-5">
      <h2 className="mb-4 text-[15px] font-bold text-ink-950">Athletics History</h2>

      {visits && visits.visitCount > 0 && (
        <div className="mb-4">
          <p className="mb-2 flex items-center gap-1.5 text-[13.5px] font-semibold text-ink-950">
            <Users2 className="h-4 w-4 text-brand-600" />
            Your department has stayed here {visits.visitCount}x
          </p>
          <ul className="space-y-1.5 pl-6">
            {visits.visits.map((visit) => (
              <li key={visit.id} className="text-[13px] text-ink-700">
                <span className="font-medium text-ink-950">{visit.teamName}</span> ·{" "}
                {new Date(visit.visitedOn + "T00:00:00").toLocaleDateString("en-US", {
                  month: "long",
                  year: "numeric",
                })}
              </li>
            ))}
          </ul>
        </div>
      )}

      {knowledge?.networkSignal && (
        <div className="border-t border-sand-200 pt-4">
          <p className="mb-2 flex items-center gap-1.5 text-[13.5px] font-semibold text-ink-950">
            <BookOpenCheck className="h-4 w-4 text-brand-600" />
            {knowledge.networkSignal.teamsUsedCount} verified college teams used this ·{" "}
            {knowledge.networkSignal.recommendCount} recommend it
          </p>
          <ul className="list-disc space-y-1 pl-8">
            {knowledge.networkSignal.commonNotes.map((note) => (
              <li key={note} className="text-[13px] text-ink-700">
                {note}
              </li>
            ))}
          </ul>
        </div>
      )}
    </section>
  );
}
