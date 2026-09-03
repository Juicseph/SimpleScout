import { SearchX } from "lucide-react";

export function EmptyState({ title, description }: { title: string; description: string }) {
  return (
    <div className="flex flex-col items-center gap-3 rounded-xl2 border border-dashed border-sand-300 bg-white px-6 py-14 text-center">
      <div className="flex h-12 w-12 items-center justify-center rounded-full bg-sand-100 text-ink-500">
        <SearchX className="h-5 w-5" />
      </div>
      <h3 className="text-[15px] font-semibold text-ink-950">{title}</h3>
      <p className="max-w-xs text-[13px] text-ink-500">{description}</p>
    </div>
  );
}
