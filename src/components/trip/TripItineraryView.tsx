import Link from "next/link";
import { Clock, MapPin } from "lucide-react";
import type { ItineraryItem, Trip } from "@/models";
import { itineraryForTrip } from "@/data/tripBoard";
import { getPlaceById } from "@/data/places";
import { getVenueById } from "@/data/universities";

function formatTime(iso: string): string {
  return new Date(iso).toLocaleTimeString("en-US", { hour: "numeric", minute: "2-digit" });
}

function formatDayHeading(iso: string): string {
  return new Date(iso).toLocaleDateString("en-US", { weekday: "long", month: "long", day: "numeric" });
}

function groupByDay(items: ItineraryItem[]): Map<string, ItineraryItem[]> {
  const groups = new Map<string, ItineraryItem[]>();
  for (const item of items) {
    const day = item.startsAt.slice(0, 10);
    const bucket = groups.get(day) ?? [];
    bucket.push(item);
    groups.set(day, bucket);
  }
  return groups;
}

function ItineraryRow({ item }: { item: ItineraryItem }) {
  const place = item.placeId ? getPlaceById(item.placeId) : undefined;
  const venue = item.venueId ? getVenueById(item.venueId) : undefined;
  const linkedName = place?.name ?? venue?.name;

  return (
    <div className="flex gap-4">
      <div className="w-20 shrink-0 pt-0.5 text-right text-[12.5px] font-semibold text-ink-500">
        {formatTime(item.startsAt)}
      </div>
      <div className="relative flex-1 border-l border-sand-300 pb-6 pl-5">
        <span className="absolute -left-[5px] top-1 h-2.5 w-2.5 rounded-full border-2 border-brand-600 bg-white" />
        <p className="text-[14.5px] font-semibold text-ink-950">{item.title}</p>
        {linkedName &&
          (place ? (
            <Link
              href={`/place/${place.id}`}
              className="mt-0.5 flex items-center gap-1 text-[12.5px] font-medium text-brand-600 hover:underline"
            >
              <MapPin className="h-3 w-3" />
              {linkedName}
            </Link>
          ) : (
            <p className="mt-0.5 flex items-center gap-1 text-[12.5px] text-ink-500">
              <MapPin className="h-3 w-3" />
              {linkedName}
            </p>
          ))}
        {item.notes && <p className="mt-1 text-[12.5px] text-ink-500">{item.notes}</p>}
        {item.endsAt && (
          <p className="mt-1 flex items-center gap-1 text-[11.5px] text-ink-500">
            <Clock className="h-3 w-3" /> Until {formatTime(item.endsAt)}
          </p>
        )}
      </div>
    </div>
  );
}

export function TripItineraryView({ trip }: { trip: Trip }) {
  const items = itineraryForTrip(trip.id);
  const days = groupByDay(items);

  return (
    <div className="space-y-8">
      {Array.from(days.entries()).map(([day, dayItems]) => (
        <section key={day}>
          <h3 className="mb-4 text-[13px] font-bold uppercase tracking-wide text-ink-950">
            {formatDayHeading(dayItems[0]!.startsAt)}
          </h3>
          <div>
            {dayItems.map((item) => (
              <ItineraryRow key={item.id} item={item} />
            ))}
          </div>
        </section>
      ))}
    </div>
  );
}
