import { CalendarDays, MapPin, Users } from "lucide-react";
import type { Trip } from "@/models";
import { totalTravelers } from "@/models";
import { UNIVERSITIES } from "@/data/universities";
import { formatDateRange } from "@/lib/utils";

export function TripBoardHeader({ trip }: { trip: Trip }) {
  const destination = UNIVERSITIES.find((u) => u.id === trip.destinationUniversityId);
  const origin = UNIVERSITIES.find((u) => u.id === trip.startingUniversityId);

  return (
    <section
      className="overflow-hidden rounded-xl3 p-6 text-white shadow-card md:p-8"
      style={{ background: `linear-gradient(135deg, ${destination?.primaryColor ?? "#1f1a14"}, #14110d)` }}
    >
      <p className="text-[12.5px] font-semibold uppercase tracking-wide text-white/70">
        {origin?.name ?? "Origin TBD"} at
      </p>
      <h1 className="mt-1 text-2xl font-extrabold md:text-3xl">{destination?.name ?? "Destination TBD"}</h1>
      <p className="text-[13.5px] text-white/80">{trip.teamName}</p>

      <div className="mt-4 flex flex-wrap gap-4 text-[13.5px]">
        <span className="flex items-center gap-1.5">
          <CalendarDays className="h-4 w-4" />
          {formatDateRange(trip.startDate, trip.endDate)}
        </span>
        <span className="flex items-center gap-1.5">
          <Users className="h-4 w-4" />
          {totalTravelers(trip.travelParty)} Travelers
        </span>
        {destination && (
          <span className="flex items-center gap-1.5">
            <MapPin className="h-4 w-4" />
            {destination.city}, {destination.state}
          </span>
        )}
      </div>
    </section>
  );
}
