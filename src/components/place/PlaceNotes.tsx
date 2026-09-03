import { Lock, MessageSquareText, Users } from "lucide-react";
import type { StaffNote, VisibilityLevel } from "@/models";
import { EmptyState } from "@/components/ui/EmptyState";

const VISIBILITY_LABEL: Record<VisibilityLevel, string> = {
  personal: "Personal",
  team: "Team",
  department: "Department",
  network: "Network",
};

export function PlaceNotes({ notes }: { notes: StaffNote[] }) {
  return (
    <section className="rounded-xl2 border border-sand-200 bg-white p-5">
      <h2 className="mb-3 text-[15px] font-bold text-ink-950">Notes</h2>
      {notes.length === 0 ? (
        <EmptyState title="No staff notes yet" description="Notes your staff leave here follow this place forever — for every future trip." />
      ) : (
        <ul className="space-y-4">
          {notes.map((note) => (
            <li key={note.id} className="flex gap-3">
              <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-sand-100 text-ink-500">
                <MessageSquareText className="h-4 w-4" />
              </div>
              <div>
                <p className="text-[13.5px] text-ink-950">&ldquo;{note.body}&rdquo;</p>
                <p className="mt-1 flex items-center gap-1.5 text-[12px] text-ink-500">
                  {note.authorName} · {note.authorRole}
                  <span className="mx-1 inline-flex items-center gap-1 rounded-full bg-sand-100 px-2 py-0.5 font-medium text-ink-500">
                    <Lock className="h-2.5 w-2.5" />
                    {VISIBILITY_LABEL[note.visibility]}
                  </span>
                </p>
              </div>
            </li>
          ))}
        </ul>
      )}
      <p className="mt-4 flex items-center gap-1.5 border-t border-sand-200 pt-3 text-[12px] text-ink-500">
        <Users className="h-3.5 w-3.5" />
        Visible to your team by default — promote a note to Department or Network to share it further.
      </p>
    </section>
  );
}
