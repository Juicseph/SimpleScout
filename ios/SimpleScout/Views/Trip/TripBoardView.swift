import SwiftUI

struct TripBoardView: View {
    let trip: Trip
    @State private var tab: Tab = .board

    private enum Tab: String, CaseIterable, Hashable { case board = "Trip Board", itinerary = "Itinerary" }

    private var destination: University? { DemoUniversities.all.first { $0.id == trip.destinationUniversityId } }
    private var origin: University? { DemoUniversities.all.first { $0.id == trip.startingUniversityId } }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                Picker("View", selection: $tab) {
                    ForEach(Tab.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)

                if tab == .board {
                    TripBoardSectionsView(trip: trip)
                } else {
                    TripItineraryView(trip: trip)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Theme.sand)
        .navigationDestination(for: PlaceRoute.self) { route in
            PlaceDetailView(placeId: route.placeId)
        }
        .navigationTitle(destination?.name ?? "Trip")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(origin?.name ?? "Origin TBD") at").font(.system(size: 11, weight: .semibold)).foregroundStyle(.white.opacity(0.7))
            Text(destination?.name ?? "Destination TBD").font(.system(size: 22, weight: .heavy)).foregroundStyle(.white)
            Text(trip.teamName).font(.system(size: 13)).foregroundStyle(.white.opacity(0.85))
            HStack(spacing: 16) {
                Label("\(trip.startDate) – \(trip.endDate)", systemImage: "calendar")
                Label("\(trip.travelParty.total) Travelers", systemImage: "person.2.fill")
            }
            .font(.system(size: 12)).foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(LinearGradient(colors: [Color(hex: destination?.primaryColorHex ?? "#1f1a14"), Theme.ink], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 16)
    }
}

private struct TripBoardSectionsView: View {
    let trip: Trip

    private var anchor: LatLng {
        trip.currentHotelPlaceId.flatMap(DemoPlaces.byId)?.location ?? DemoUniversities.ohioState.location
    }

    var body: some View {
        VStack(spacing: 20) {
            if let venue = trip.venueId.flatMap(DemoUniversities.venue(byId:)) {
                sectionHeader("Venue", icon: "mappin.circle.fill")
                HStack(spacing: 12) {
                    Image(systemName: "mappin.circle.fill").font(.system(size: 20)).foregroundStyle(.white)
                        .frame(width: 48, height: 48).background(RoundedRectangle(cornerRadius: 12).fill(Theme.ink))
                    VStack(alignment: .leading) {
                        Text(venue.name).font(.system(size: 14, weight: .semibold))
                        Text("Competition venue").font(.system(size: 12)).foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .rowStyle()
            }

            ForEach(TripPlaceSection.allCases, id: \.self) { section in
                let entries = DemoTripBoard.places.filter { $0.section == section }
                if !entries.isEmpty {
                    sectionHeader(section.label, icon: "circle.fill")
                    ForEach(entries) { entry in
                        if let place = DemoPlaces.byId(entry.placeId) {
                            NavigationLink(value: PlaceRoute(placeId: place.id)) {
                                boardRow(place: place, note: entry.notes)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            sectionHeader("Airport", icon: "airplane")
            VStack(alignment: .leading, spacing: 4) {
                Text("\(DemoTripBoard.logistics.airportName) (\(DemoTripBoard.logistics.airportCode))").font(.system(size: 14, weight: .semibold))
                Text(DemoTripBoard.logistics.airportNotes).font(.system(size: 12)).foregroundStyle(.secondary)
            }
            .rowStyle()

            sectionHeader("Notes", icon: "note.text")
            VStack(alignment: .leading, spacing: 6) {
                ForEach(DemoTripBoard.logistics.generalNotes, id: \.self) { note in
                    Text("· \(note)").font(.system(size: 13))
                }
            }
            .rowStyle()
        }
        .padding(.horizontal, 16)
    }

    private func boardRow(place: Place, note: String?) -> some View {
        let fit = computeTeamFitScore(place: place, partySize: trip.travelParty.total, anchor: anchor, knowledge: DemoKnowledge.forPlace(place.id))
        return HStack(spacing: 12) {
            PhotoTileView(theme: place.external.photoTheme, height: 52, cornerRadius: 12).frame(width: 52)
            VStack(alignment: .leading, spacing: 2) {
                Text(place.name).font(.system(size: 14, weight: .semibold)).foregroundStyle(.primary)
                Text(place.address).font(.system(size: 11)).foregroundStyle(.secondary).lineLimit(1)
                if let note {
                    Text("\u{201C}\(note)\u{201D}").font(.system(size: 11)).italic().foregroundStyle(.secondary).lineLimit(2)
                }
            }
            Spacer()
            TeamFitBadgeView(score: fit.score, compact: true)
            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(.tertiary)
        }
        .rowStyle()
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack {
            Text(title.uppercased()).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
            Spacer()
        }
    }
}

private extension View {
    func rowStyle() -> some View {
        self.padding(12)
            .background(RoundedRectangle(cornerRadius: 16).fill(.background))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.systemGray5)))
    }
}
