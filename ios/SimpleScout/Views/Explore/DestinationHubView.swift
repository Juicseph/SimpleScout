import SwiftUI

struct DestinationHubView: View {
    @EnvironmentObject private var store: TripStore
    @State private var selectedCategory: ExploreCategory = .stay

    private var destination: University? {
        DemoUniversities.all.first { $0.id == store.context.destinationUniversityId }
    }

    private var results: [RankedPlace] {
        guard let category = selectedCategory.placeCategory else { return [] }
        let ranked = SearchService.searchPlaces(
            universityId: store.context.destinationUniversityId,
            category: category,
            travelParty: store.context.travelParty,
            anchor: store.context.anchor,
            currentHotelPlaceId: store.context.currentHotelPlaceId,
            requirePartyFit: store.canFitTeamOnly
        )
        return ranked.filter { selectedCategory.matches($0.place) }
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    banner
                    NeedSomethingNowView { category in
                        selectedCategory = category
                        withAnimation { proxy.scrollTo("results", anchor: .top) }
                    }
                    .padding(.horizontal, 16)

                    VStack(spacing: 12) {
                        CategoryRailView(selected: $selectedCategory)

                        HStack {
                            VStack(alignment: .leading) {
                                Text(selectedCategory.label).font(.system(size: 20, weight: .bold))
                                Text("Ranked for your party of \(store.context.travelParty.total) · \(results.count) results")
                                    .font(.system(size: 12)).foregroundStyle(.secondary)
                            }
                            Spacer()
                            canFitToggle
                        }
                        .padding(.horizontal, 16)

                        if results.isEmpty {
                            ContentUnavailableView(
                                "No \(selectedCategory.label.lowercased()) found",
                                systemImage: "magnifyingglass",
                                description: Text("Try turning off \u{201C}Can Fit Our Team\u{201D} to see every option.")
                            )
                            .padding(.top, 24)
                        } else {
                            LazyVStack(spacing: 14) {
                                ForEach(results) { ranked in
                                    NavigationLink(value: PlaceRoute(placeId: ranked.place.id)) {
                                        PlaceCardView(ranked: ranked)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .id("results")
                }
                .padding(.vertical, 16)
            }
        }
        .navigationDestination(for: PlaceRoute.self) { route in
            PlaceDetailView(placeId: route.placeId)
        }
        .background(Theme.sand)
        .navigationTitle(destination?.name ?? "Explore")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var canFitToggle: some View {
        Button {
            store.canFitTeamOnly.toggle()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "person.2.fill")
                Text("Fits Team (\(store.context.travelParty.total))")
                Image(systemName: store.canFitTeamOnly ? "checkmark.circle.fill" : "circle")
            }
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(Capsule().fill(store.canFitTeamOnly ? Theme.brand.opacity(0.12) : Color(.systemGray6)))
            .foregroundStyle(store.canFitTeamOnly ? Theme.brand : .primary)
        }
    }

    private var banner: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(store.context.sport.label) · Destination Hub")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
            Text(destination?.name ?? "").font(.system(size: 24, weight: .heavy)).foregroundStyle(.white)
            if let destination {
                Text("\(destination.city), \(destination.state)").font(.system(size: 13)).foregroundStyle(.white.opacity(0.8))
            }
            HStack(spacing: 16) {
                Label("\(store.context.travelParty.total) Travelers", systemImage: "person.2.fill")
                Label("Covelli Center", systemImage: "mappin.circle.fill")
            }
            .font(.system(size: 12)).foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            LinearGradient(colors: [Color(hex: destination?.primaryColorHex ?? "#1f1a14"), Theme.ink], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 16)
    }
}
