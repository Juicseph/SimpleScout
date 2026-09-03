import { Star } from "lucide-react";
import type { AthleticsReview, PlaceExternalRef } from "@/models";
import { EmptyState } from "@/components/ui/EmptyState";

function RatingBar({ label, value }: { label: string; value: number }) {
  return (
    <div className="flex items-center gap-2">
      <span className="w-32 shrink-0 text-[12px] text-ink-500">{label}</span>
      <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-sand-200">
        <div className="h-full rounded-full bg-brand-600" style={{ width: `${(value / 5) * 100}%` }} />
      </div>
      <span className="w-6 shrink-0 text-right text-[12px] font-medium text-ink-700">{value}</span>
    </div>
  );
}

export function PlaceReviews({ external, reviews }: { external: PlaceExternalRef; reviews: AthleticsReview[] }) {
  return (
    <section className="rounded-xl2 border border-sand-200 bg-white p-5">
      <h2 className="mb-4 text-[15px] font-bold text-ink-950">Reviews</h2>

      <div className="mb-5 flex items-center gap-2 border-b border-sand-200 pb-4">
        <Star className="h-4 w-4 fill-amber-400 text-amber-400" />
        <span className="text-[14px] font-semibold text-ink-950">{external.publicRating?.toFixed(1) ?? "—"}</span>
        <span className="text-[12.5px] text-ink-500">
          public rating · {external.publicRatingCount ?? 0} reviews (Google Places)
        </span>
      </div>

      <h3 className="mb-3 text-[12.5px] font-semibold uppercase tracking-wide text-ink-500">Athletics Reviews</h3>
      {reviews.length === 0 ? (
        <EmptyState
          title="No athletics reviews yet"
          description="Be the first on your staff to rate this place for team travel."
        />
      ) : (
        <div className="space-y-5">
          {reviews.map((review) => (
            <div key={review.id} className="space-y-2.5 border-b border-sand-100 pb-5 last:border-0 last:pb-0">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-[13.5px] font-semibold text-ink-950">{review.authorName}</p>
                  <p className="text-[12px] text-ink-500">
                    {review.authorRole} · {review.teamName}
                  </p>
                </div>
                <span className="flex items-center gap-1 text-[13.5px] font-semibold text-ink-950">
                  <Star className="h-3.5 w-3.5 fill-amber-400 text-amber-400" />
                  {review.overallRating}
                </span>
              </div>
              {review.body && <p className="text-[13px] italic text-ink-700">&ldquo;{review.body}&rdquo;</p>}
              <div className="grid grid-cols-1 gap-1.5 pt-1 sm:grid-cols-2">
                {Object.entries(review.categoryRatings).map(([label, value]) => (
                  <RatingBar key={label} label={label} value={value} />
                ))}
              </div>
            </div>
          ))}
        </div>
      )}
    </section>
  );
}
