import { Globe, Phone } from "lucide-react";
import type { Place } from "@/models";

export function PlaceContact({ place }: { place: Place }) {
  return (
    <section className="rounded-xl2 border border-sand-200 bg-white p-5">
      <h2 className="mb-3 text-[15px] font-bold text-ink-950">Contact</h2>
      <div className="space-y-2 text-[13.5px]">
        {place.external.phone && (
          <a href={`tel:${place.external.phone}`} className="flex items-center gap-2 text-ink-700 hover:text-brand-600">
            <Phone className="h-4 w-4" />
            {place.external.phone}
          </a>
        )}
        {place.external.website && (
          <a
            href={place.external.website}
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2 text-ink-700 hover:text-brand-600"
          >
            <Globe className="h-4 w-4" />
            {place.external.website.replace(/^https?:\/\//, "")}
          </a>
        )}
        {place.athletics.groupSalesContact && (
          <div className="mt-3 rounded-xl bg-sand-100 p-3">
            <p className="text-[12px] font-semibold uppercase tracking-wide text-ink-500">Group Sales Contact</p>
            <p className="mt-1 font-medium text-ink-950">{place.athletics.groupSalesContact.name}</p>
            <p className="text-ink-500">{place.athletics.groupSalesContact.role}</p>
            {place.athletics.groupSalesContact.phone && <p className="text-ink-500">{place.athletics.groupSalesContact.phone}</p>}
          </div>
        )}
      </div>
    </section>
  );
}
