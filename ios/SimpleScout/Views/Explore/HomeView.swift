import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: TripStore

    var body: some View {
        Group {
            if store.hasSearched {
                DestinationHubView()
            } else {
                heroContent
            }
        }
    }

    private var heroContent: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text("Where is your team headed?")
                        .font(.system(size: 28, weight: .heavy))
                        .multilineTextAlignment(.center)
                    Text("SimpleScout plans college athletics travel the way your department actually thinks about it — by destination, dates, and exactly who's coming.")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                SearchCardView()
                    .padding(.horizontal, 16)

                pillars

                recentDestinations
                departmentRecommendations
            }
            .padding(.bottom, 32)
        }
        .background(Theme.sand)
        .navigationTitle("Explore")
    }

    private var pillars: some View {
        VStack(spacing: 10) {
            pillar(icon: "mappin.and.ellipse", title: "Party-Size-Aware Search", body: "Every result is ranked for your exact travel party — not just the closest option.")
            pillar(icon: "book.closed.fill", title: "Private Athletics Knowledge", body: "See where your department has stayed, eaten, and what staff noted last time.")
            pillar(icon: "dot.radiowaves.left.and.right", title: "Travel Mode", body: "Once you're on the trip, the app becomes a live operations dashboard.")
        }
        .padding(.horizontal, 16)
    }

    private func pillar(icon: String, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).foregroundStyle(Theme.brand).frame(width: 22)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 14, weight: .semibold))
                Text(body).font(.system(size: 12)).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(.background))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.systemGray5)))
    }

    private var recentDestinations: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Destinations").font(.system(size: 17, weight: .bold)).padding(.horizontal, 16)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(DemoUniversities.all) { university in
                        Button {
                            store.context.destinationUniversityId = university.id
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(String(university.abbreviation.prefix(3)))
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 34, height: 34)
                                    .background(Circle().fill(Color(hex: university.primaryColorHex)))
                                Text(university.name).font(.system(size: 13, weight: .semibold)).foregroundStyle(.primary)
                                Text("\(university.city), \(university.state)").font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            .padding(12)
                            .frame(width: 160, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 16).fill(university.id == store.context.destinationUniversityId ? Theme.brand.opacity(0.08) : Color(.secondarySystemBackground)))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(university.id == store.context.destinationUniversityId ? Theme.brand : Color(.systemGray5)))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private var departmentRecommendations: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Department Recommends").font(.system(size: 17, weight: .bold)).padding(.horizontal, 16)
            VStack(spacing: 10) {
                ForEach(["place_marriott_columbus", "place_hyde_park_steakhouse", "place_chipotle_lane"], id: \.self) { id in
                    if let place = DemoPlaces.byId(id) {
                        let knowledge = DemoKnowledge.forPlace(id)
                        HStack(spacing: 12) {
                            PhotoTileView(theme: place.external.photoTheme, height: 56, cornerRadius: 12).frame(width: 56)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(place.name).font(.system(size: 14, weight: .semibold))
                                Text("Athletics \(knowledge?.athleticsRating.map { String(format: "%.1f", $0) } ?? "—") · \(knowledge?.departmentVisits?.visitCount ?? 0) visits")
                                    .font(.system(size: 12)).foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 14).fill(.background))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray5)))
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
