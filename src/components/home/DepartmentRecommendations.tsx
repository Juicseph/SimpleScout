import { ArrowUpRight } from "lucide-react";
import { getPlaceById } from "@/data/places";
import { getKnowledgeForPlace } from "@/data/knowledge";
import { PhotoTile } from "@/components/ui/PhotoTile";

const FEATURED_PLACE_IDS = ["place_marriott_columbus", "place_hyde_park_steakhouse", "place_chipotle_lane"];

export function DepartmentRecommendations() {
  const items = FEATURED_PLACE_IDS.map((id) => ({ place: getPlaceById(id)!, knowledge: getKnowledgeForPlace(id) })).filter(
    (i) => i.place
  );

  return (
    <section>
      <div className="mb-3 flex items-baseline justify-between">
        <h2 className="text-lg font-bold text-ink-950">Your Department Recommends</h2>
        <button className="flex items-center gap-1 text-[13px] font-medium text-brand-600">
          See all <ArrowUpRight className="h-3.5 w-3.5" />
        </button>
      </div>
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
        {items.map(({ place, knowledge }) => (
          <div key={place.id} className="overflow-hidden rounded-xl2 border border-sand-200 bg-white shadow-card">
            <PhotoTile theme={place.external.photoTheme} className="h-28 w-full" />
            <div className="space-y-1.5 p-3.5">
              <p className="truncate text-[14px] font-semibold text-ink-950">{place.name}</p>
              <p className="text-[12.5px] text-ink-500">
                Athletics rating {knowledge?.athleticsRating?.toFixed(1) ?? "—"} ·{" "}
                {knowledge?.departmentVisits?.visitCount ?? 0} visits
              </p>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
