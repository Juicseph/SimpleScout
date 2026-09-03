"use client";

import { useRef, useState } from "react";
import { BookOpenCheck, MapPinned, Radio } from "lucide-react";
import { SearchModule } from "@/components/search/SearchModule";
import { RecentDestinations } from "@/components/home/RecentDestinations";
import { DepartmentRecommendations } from "@/components/home/DepartmentRecommendations";
import { TripContextBanner } from "@/components/explore/TripContextBanner";
import { CategoryRail } from "@/components/explore/CategoryRail";
import { ExploreResults } from "@/components/explore/ExploreResults";
import { NeedSomethingNow } from "@/components/explore/NeedSomethingNow";
import { useTripStore } from "@/state/tripStore";
import type { ExploreCategory } from "@/lib/categories";

const PILLARS = [
  {
    title: "Party-Size-Aware Search",
    description: "Every result is ranked for your exact travel party — not just the closest option.",
    icon: MapPinned,
  },
  {
    title: "Private Athletics Knowledge",
    description: "See where your department has stayed, eaten, and what staff noted last time.",
    icon: BookOpenCheck,
  },
  {
    title: "Travel Mode",
    description: "Once you're on the trip, the app becomes a live operations dashboard.",
    icon: Radio,
  },
];

export default function HomePage() {
  const { hasSearched } = useTripStore();
  const [activeCategory, setActiveCategory] = useState<ExploreCategory>("stay");
  const resultsRef = useRef<HTMLDivElement>(null);

  function jumpTo(category: ExploreCategory) {
    setActiveCategory(category);
    resultsRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
  }

  if (!hasSearched) {
    return (
      <main className="mx-auto max-w-5xl px-4 py-10 md:px-8 md:py-16">
        <div className="text-center">
          <h1 className="text-3xl font-extrabold tracking-tight text-ink-950 md:text-5xl">
            Where is your team headed?
          </h1>
          <p className="mx-auto mt-3 max-w-xl text-[15px] text-ink-500 md:text-base">
            SimpleScout plans college athletics travel the way your department actually thinks about
            it — by destination, dates, and exactly who&apos;s coming.
          </p>
        </div>

        <div className="mt-8">
          <SearchModule />
        </div>

        <div className="mt-14 grid grid-cols-1 gap-4 sm:grid-cols-3">
          {PILLARS.map((pillar) => (
            <div key={pillar.title} className="rounded-xl2 border border-sand-200 bg-white p-5 shadow-card">
              <pillar.icon className="h-5 w-5 text-brand-600" />
              <h3 className="mt-3 text-[14.5px] font-semibold text-ink-950">{pillar.title}</h3>
              <p className="mt-1 text-[13px] text-ink-500">{pillar.description}</p>
            </div>
          ))}
        </div>

        <div className="mt-14 space-y-10">
          <RecentDestinations />
          <DepartmentRecommendations />
        </div>
      </main>
    );
  }

  return (
    <main className="mx-auto max-w-6xl space-y-8 px-4 py-6 md:px-8 md:py-8">
      <SearchModule />

      <TripContextBanner onFeedTeamFast={() => jumpTo("quick_meals")} />

      <NeedSomethingNow onSelect={jumpTo} />

      <div ref={resultsRef} className="space-y-4 scroll-mt-24">
        <CategoryRail active={activeCategory} onSelect={setActiveCategory} />
        <ExploreResults category={activeCategory} />
      </div>
    </main>
  );
}
