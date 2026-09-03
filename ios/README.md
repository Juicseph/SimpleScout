# SimpleScout — iOS

A native SwiftUI port of the Home/Explore experience (search, Destination Hub,
ranked results, Team Fit Score, Place Details) plus the Trip Board and
Itinerary, sharing the exact same demo dataset and ranking logic as the web
app so both platforms behave identically. See
[`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md) §2 for why this is a
native SwiftUI app rather than a cross-platform wrapper.

This was generated in a Linux environment with no Xcode/Swift toolchain
available, so **it has not been compiled**. It was written and manually
reviewed carefully (including a pass specifically checking for Swift's
memberwise-initializer/`Hashable` gotchas), but the first thing to do is open
it in Xcode and fix whatever the compiler flags — please report back what you
hit so it can be patched quickly.

## Setup (one-time)

This project is generated from `project.yml` via
[XcodeGen](https://github.com/yonaskolb/XcodeGen), rather than committing a
hand-authored `.xcodeproj` — that keeps the project file merge-friendly and
regenerable instead of a giant opaque XML blob you have to fight in git.

```bash
brew install xcodegen
cd ios
xcodegen generate
open SimpleScout.xcodeproj
```

In Xcode: pick an iPhone Simulator (iOS 17+) as the run destination and hit
Run (⌘R).

**Don't have Homebrew/XcodeGen and just want to open it fast?** Create a new
Xcode project (App template, SwiftUI interface, iOS 17+ deployment target,
bundle id `com.simplescout.app`), delete its default `ContentView.swift`, and
drag the `SimpleScout/` folder (everything under `ios/SimpleScout/`) into the
project navigator ("Create groups", target membership checked). Same code,
just Xcode manages the project file instead of XcodeGen.

## Regenerating after adding files

Whenever you add/remove/move files in Xcode, `project.yml`'s `sources` glob
already covers the whole `SimpleScout/` folder, so you don't need to edit
`project.yml` for normal file changes — just re-run `xcodegen generate` if
Xcode's own file management ever gets out of sync with disk, or after pulling
changes made outside Xcode (e.g. from this session).

## Project layout

```
ios/
├── project.yml                  # XcodeGen spec — the source of truth for the Xcode project
└── SimpleScout/
    ├── App/                     # @main entry point, root TabView
    ├── Models/                  # Swift structs mirroring src/models (web)
    ├── Core/
    │   ├── Ranking/             # Distance, party-size fit, ranking pipeline
    │   └── TeamFitScore/        # Team Fit Score weights + computation
    ├── Data/                    # Same seeded demo dataset as the web app
    ├── Services/                # SearchService (provider + ranking orchestration)
    ├── State/                   # TripStore — the app-wide active trip context
    ├── Views/
    │   ├── Explore/             # Home, search sheets, Destination Hub, Place Details
    │   ├── Trip/                # Trip Board + Itinerary
    │   └── Components/          # Theme, PhotoTileView, TeamFitBadgeView, etc.
    └── Assets.xcassets/
```

## What's implemented

- Home screen: hero + tappable search card (destination, dates, who's
  traveling, starting from, sport) opening native sheets/pickers.
- Destination Hub: category rail, "Can Fit Our Team" toggle, Need Something
  Now grid, ranked results with the same Team Fit Score formula as web.
- Place Details: overview, team info, athletics history, athletics reviews
  with rubric bars, a native MapKit map, contact, and staff notes.
- Trip Board (segmented Board/Itinerary) mirroring the web trip board.

## What's not wired up yet

- No backend/API calls — everything reads the in-memory `Data/` demo dataset,
  same as web's MVP-stage approach.
- No auth, no persistence beyond in-memory `@Published` state (a fresh launch
  resets to the demo trip).
- Favorites/Share/Recommend buttons on Place Details are UI-only stubs.
- Live Activities / WidgetKit / offline SwiftData caching for Travel Mode
  (see `docs/ARCHITECTURE.md` §11) — deferred, as flagged as later-phase work
  in the architecture doc.
