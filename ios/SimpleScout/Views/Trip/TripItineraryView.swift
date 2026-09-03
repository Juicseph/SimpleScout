import SwiftUI

struct TripItineraryView: View {
    let trip: Trip

    private var itemsByDay: [(day: String, items: [ItineraryItem])] {
        let items = DemoTripBoard.itinerary.filter { $0.tripId == trip.id }.sorted { $0.startsAt < $1.startsAt }
        var groups: [String: [ItineraryItem]] = [:]
        var order: [String] = []
        for item in items {
            let day = String(item.startsAt.prefix(10))
            if groups[day] == nil { order.append(day) }
            groups[day, default: []].append(item)
        }
        return order.map { ($0, groups[$0] ?? []) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(itemsByDay, id: \.day) { group in
                VStack(alignment: .leading, spacing: 14) {
                    Text(dayHeading(group.day)).font(.system(size: 13, weight: .bold)).textCase(.uppercase)
                    ForEach(group.items) { item in
                        row(item)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private func dayHeading(_ day: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: day) else { return day }
        let out = DateFormatter()
        out.dateFormat = "EEEE, MMMM d"
        return out.string(from: date)
    }

    private func time(_ iso: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = formatter.date(from: iso) else { return iso }
        let out = DateFormatter()
        out.dateFormat = "h:mm a"
        return out.string(from: date)
    }

    @ViewBuilder
    private func row(_ item: ItineraryItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(time(item.startsAt))
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 64, alignment: .trailing)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.title).font(.system(size: 14, weight: .semibold))
                if let placeId = item.placeId, let place = DemoPlaces.byId(placeId) {
                    NavigationLink(value: PlaceRoute(placeId: place.id)) {
                        Label(place.name, systemImage: "mappin.circle").font(.system(size: 12, weight: .medium)).foregroundStyle(Theme.brand)
                    }
                } else if let venueId = item.venueId, let venue = DemoUniversities.venue(byId: venueId) {
                    Label(venue.name, systemImage: "mappin.circle").font(.system(size: 12)).foregroundStyle(.secondary)
                }
                if let notes = item.notes {
                    Text(notes).font(.system(size: 12)).foregroundStyle(.secondary)
                }
                if let endsAt = item.endsAt {
                    Label("Until \(time(endsAt))", systemImage: "clock").font(.system(size: 11)).foregroundStyle(.secondary)
                }
            }
            .padding(.leading, 12)
            .overlay(alignment: .leading) {
                Rectangle().fill(Color(.systemGray4)).frame(width: 1)
            }
        }
    }
}
