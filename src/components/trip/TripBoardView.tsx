import { MapPin, Plane, StickyNote } from "lucide-react";
import type { Trip } from "@/models";
import { totalTravelers } from "@/models";
import { getPlaceById } from "@/data/places";
import { getKnowledgeForPlace } from "@/data/knowledge";
import { tripPlacesForTrip, TRIP_LOGISTICS } from "@/data/tripBoard";
import { getVenueById } from "@/data/universities";
import { computeTeamFitScore } from "@/core/teamFitScore/teamFitScore";
import { SECTION_CONFIG, SECTION_ORDER } from "@/lib/tripBoardSections";
import { BoardPlaceRow } from "./BoardPlaceRow";

export function TripBoardView({ trip }: { trip: Trip }) {
  const boardPlaces = tripPlacesForTrip(trip.id);
  const hotelPlace = trip.currentHotelPlaceId ? getPlaceById(trip.currentHotelPlaceId) : undefined;
  const anchor = hotelPlace?.location;
  const partySize = totalTravelers(trip.travelParty);
  const venue = trip.venueId ? getVenueById(trip.venueId) : undefined;

  return (
    <div className="space-y-6">
      {venue && (
        <section>
          <h3 className="mb-2 text-[13px] font-semibold uppercase tracking-wide text-ink-500">Venue</h3>
          <div className="flex items-center gap-3 rounded-xl2 border border-sand-200 bg-white p-3 shadow-card">
            <div className="flex h-14 w-14 shrink-0 items-center justify-center rounded-xl bg-ink-950 text-white">
              <MapPin className="h-5 w-5" />
            </div>
            <div>
              <p className="text-[14px] font-semibold text-ink-950">{venue.name}</p>
              <p className="text-[12.5px] text-ink-500">Competition venue</p>
            </div>
          </div>
        </section>
      )}

      {SECTION_ORDER.map((section) => {
        const entries = boardPlaces.filter((tp) => tp.section === section);
        if (entries.length === 0) return null;
        const config = SECTION_CONFIG[section];

        return (
          <section key={section}>
            <h3 className="mb-2 flex items-center gap-1.5 text-[13px] font-semibold uppercase tracking-wide text-ink-500">
              <config.icon className="h-3.5 w-3.5" />
              {config.label}
            </h3>
            <div className="space-y-2">
              {entries.map((entry) => {
                const place = getPlaceById(entry.placeId);
                if (!place) return null;
                const fit = anchor
                  ? computeTeamFitScore({
                      place,
                      partySize,
                      anchor,
                      knowledge: getKnowledgeForPlace(place.id),
                    })
                  : undefined;
                return <BoardPlaceRow key={entry.id} place={place} fit={fit} note={entry.notes} />;
              })}
            </div>
          </section>
        );
      })}

      <section>
        <h3 className="mb-2 flex items-center gap-1.5 text-[13px] font-semibold uppercase tracking-wide text-ink-500">
          <Plane className="h-3.5 w-3.5" />
          Airport
        </h3>
        <div className="rounded-xl2 border border-sand-200 bg-white p-3.5 shadow-card">
          <p className="text-[14px] font-semibold text-ink-950">
            {TRIP_LOGISTICS.airport.name} ({TRIP_LOGISTICS.airport.code})
          </p>
          {TRIP_LOGISTICS.airport.notes && (
            <p className="mt-1 text-[12.5px] text-ink-500">{TRIP_LOGISTICS.airport.notes}</p>
          )}
        </div>
      </section>

      <section>
        <h3 className="mb-2 flex items-center gap-1.5 text-[13px] font-semibold uppercase tracking-wide text-ink-500">
          <StickyNote className="h-3.5 w-3.5" />
          Notes
        </h3>
        <div className="space-y-2 rounded-xl2 border border-sand-200 bg-white p-3.5 shadow-card">
          {TRIP_LOGISTICS.generalNotes.map((note) => (
            <p key={note} className="text-[13px] text-ink-700">
              · {note}
            </p>
          ))}
        </div>
      </section>
    </div>
  );
}
