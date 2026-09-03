import SwiftUI

struct PlaceCardView: View {
    let ranked: RankedPlace

    private var subtitle: String {
        let place = ranked.place
        if let hotel = place.hotel { return "Hotel · \(hotel.totalRooms.map(String.init) ?? "—") rooms" }
        if let restaurant = place.restaurant { return restaurant.cuisine }
        if place.caterer != nil { return "Catering" }
        if let store = place.store { return store.storeType.replacingOccurrences(of: "_", with: " ").capitalized }
        return place.category.rawValue.capitalized
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                PhotoTileView(theme: ranked.place.external.photoTheme, height: 150, cornerRadius: 16)
                if !ranked.fit.fitsParty {
                    Text("May be tight for your party")
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(.black.opacity(0.8)))
                        .foregroundStyle(.white)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .bottomLeading)
                }
            }

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(ranked.place.name).font(.system(size: 16, weight: .semibold)).lineLimit(1)
                    Text(subtitle).font(.system(size: 13)).foregroundStyle(.secondary)
                }
                Spacer()
                TeamFitBadgeView(score: ranked.fit.score, compact: true)
            }

            HStack(spacing: 12) {
                Label {
                    Text(ranked.place.external.publicRating.map { String(format: "%.1f", $0) } ?? "—")
                } icon: { Image(systemName: "star.fill").foregroundStyle(.yellow) }
                if let athletics = ranked.knowledge?.athleticsRating {
                    Text("Athletics \(String(format: "%.1f", athletics))")
                        .font(.system(size: 11, weight: .semibold))
                        .padding(.horizontal, 6).padding(.vertical, 3)
                        .background(Capsule().fill(Theme.brand.opacity(0.12)))
                        .foregroundStyle(Theme.brand)
                }
                Label("\(String(format: "%.1f", ranked.distanceMi)) mi", systemImage: "mappin.circle")
                    .foregroundStyle(.secondary)
                Label("\(ranked.driveMinutes) min", systemImage: "car.fill")
                    .foregroundStyle(.secondary)
            }
            .font(.system(size: 13))

            PlaceBadgesView(tags: ranked.place.tags)
            Text(ranked.fit.headline).font(.system(size: 12)).foregroundStyle(.secondary)
            KnowledgeStripView(knowledge: ranked.knowledge)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(.background))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(Color(.systemGray5)))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }
}
