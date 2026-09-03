# SimpleScout

The operating system for college athletics team travel — party-size-aware search,
private athletics knowledge, and an in-trip Travel Mode, built as a premium consumer
travel app for Directors of Operations, coaches, trainers, and equipment managers.

- **Architecture:** [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — product architecture,
  tech stack, information architecture, data model, permissions, ranking/Team Fit Score
  methodology, Travel Mode, Ask Another Team/Network design, and phased roadmap.
- **Database schema:** [`db/schema.sql`](db/schema.sql) — Postgres/Supabase DDL for the
  full org/team/trip/place/knowledge graph.

## What's implemented

**Web:** an Airbnb-style search module (destination, dates, travel party, starting point,
sport), a Destination Hub with party-size-ranked hotel, restaurant, catering, and
essentials results, a real (not cosmetic) Team Fit Score and ranking engine, a "Can Fit
Our Team" filter, "Feed the Team Fast," Need Something Now, inline athletics knowledge
(department visit history, staff notes, network signal), a Trip Board, a day-grouped
Itinerary, and a full Place Details page.

**iOS:** a native SwiftUI port of the same Home/Explore flow and Trip Board/Itinerary,
sharing the identical demo dataset and ranking/Team Fit Score logic — see
[`ios/README.md`](ios/README.md) for how to open it in Xcode.

Demo data seeds Fresno State Women's Volleyball traveling to Ohio State, Sep 12–14, with
a 28-person travel party — matching the product brief's worked example.

## Running locally

```bash
npm install
npm run dev
```

Then open http://localhost:3000.

## Project layout

```
src/
├── app/            # Next.js App Router routes
├── components/     # UI, search, explore, knowledge, layout, home components
├── core/           # Framework-agnostic ranking + Team Fit Score logic
├── models/         # TypeScript types mirroring db/schema.sql
├── services/       # Provider abstractions (Places) + search service
├── data/           # Seeded demo dataset
├── state/          # Zustand active-trip-context store
└── lib/            # Utilities

ios/                # SwiftUI app — see ios/README.md
```

## Known follow-ups

- `next`/`postcss` currently carry a build-tool-only advisory that's only fully resolved
  by a Next.js 16 major upgrade; deferred for now to avoid destabilizing the App Router
  code in this pass. Track before production deploy.
- Map is a stylized placeholder (no Mapbox/Google Maps key wired up yet) — see
  `docs/ARCHITECTURE.md` §13 for the intended provider.
- Auth, Supabase wiring, and RLS policies are specified in the architecture doc and schema
  but not yet connected — this pass is UI + ranking logic over an in-memory demo dataset.
- The iOS app was written without access to Xcode/a Swift toolchain (this session runs on
  Linux), so it has been carefully reviewed but not compiled — see `ios/README.md`.
