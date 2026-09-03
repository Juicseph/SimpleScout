"use client";

import { notFound } from "next/navigation";
import { getPlaceById } from "@/data/places";
import { getKnowledgeForPlace, athleticsReviewsForPlace } from "@/data/knowledge";
import { OHIO_STATE } from "@/data/universities";
import { useTripStore } from "@/state/tripStore";
import { totalTravelers } from "@/models";
import { computeTeamFitScore } from "@/core/teamFitScore/teamFitScore";
import { haversineMiles, estimatedDriveMinutes } from "@/core/ranking/distance";
import { PlaceHeader } from "@/components/place/PlaceHeader";
import { PlaceFacts } from "@/components/place/PlaceFacts";
import { PlaceAthleticsHistory } from "@/components/place/PlaceAthleticsHistory";
import { PlaceReviews } from "@/components/place/PlaceReviews";
import { PlaceContact } from "@/components/place/PlaceContact";
import { PlaceNotes } from "@/components/place/PlaceNotes";
import { MapPanel } from "@/components/explore/MapPanel";

export default function PlaceDetailsPage({ params }: { params: { placeId: string } }) {
  const place = getPlaceById(params.placeId);
  const { context } = useTripStore();

  if (!place) return notFound();

  const knowledge = getKnowledgeForPlace(place.id);
  const anchor = OHIO_STATE.location;
  const partySize = totalTravelers(context.travelParty);
  const fit = computeTeamFitScore({ place, partySize, anchor, knowledge });
  const distanceMi = haversineMiles(anchor, place.location);
  const driveMinutes = estimatedDriveMinutes(distanceMi);
  const rankedForMap = [{ place, fit, distanceMi, driveMinutes, knowledge }];

  return (
    <main className="mx-auto max-w-4xl space-y-6 px-4 py-6 md:px-8 md:py-8">
      <PlaceHeader
        place={place}
        fit={fit}
        distanceMi={distanceMi}
        driveMinutes={driveMinutes}
        athleticsRating={knowledge?.athleticsRating}
      />

      <PlaceFacts place={place} />

      <PlaceAthleticsHistory knowledge={knowledge} />

      <PlaceReviews external={place.external} reviews={athleticsReviewsForPlace(place.id)} />

      <section>
        <h2 className="mb-3 text-[15px] font-bold text-ink-950">Map</h2>
        <MapPanel places={rankedForMap} anchor={anchor} selectedId={place.id} />
      </section>

      <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
        <PlaceContact place={place} />
        <PlaceNotes notes={knowledge?.topNotes ?? []} />
      </div>
    </main>
  );
}
