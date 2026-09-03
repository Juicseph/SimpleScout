import SwiftUI

private enum ActiveSheet: Identifiable, Hashable {
    case destination, dates, who, startingFrom, sport
    var id: Int { hashValue }
}

struct SearchCardView: View {
    @EnvironmentObject private var store: TripStore
    @State private var activeSheet: ActiveSheet?
    var onSearch: () -> Void = {}

    private var destination: University? { DemoUniversities.all.first { $0.id == store.context.destinationUniversityId } }
    private var startingFrom: University? { DemoUniversities.all.first { $0.id == store.context.startingUniversityId } }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return f
    }()

    private func format(_ iso: String) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        guard let date = f.date(from: iso) else { return iso }
        return Self.dateFormatter.string(from: date)
    }

    var body: some View {
        VStack(spacing: 0) {
            row(label: "WHERE ARE YOU GOING?", value: destination?.name ?? "Search universities", icon: "mappin.and.ellipse") {
                activeSheet = .destination
            }
            Divider().padding(.leading, 16)
            row(label: "WHEN?", value: "\(format(store.context.startDate)) – \(format(store.context.endDate))", icon: "calendar") {
                activeSheet = .dates
            }
            Divider().padding(.leading, 16)
            row(label: "WHO'S TRAVELING?", value: "\(store.context.travelParty.total) total", icon: "person.2.fill") {
                activeSheet = .who
            }
            Divider().padding(.leading, 16)
            row(label: "STARTING FROM", value: startingFrom?.name ?? "Add origin", icon: "airplane.departure") {
                activeSheet = .startingFrom
            }
            Divider().padding(.leading, 16)
            row(label: "SPORT", value: store.context.sport.label, icon: "trophy.fill") {
                activeSheet = .sport
            }

            Button(action: {
                store.runSearch()
                onSearch()
            }) {
                Text("Search")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.brand)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(14)
        }
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.background))
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color(.systemGray5)))
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .destination: DestinationPickerSheet(selectedId: $store.context.destinationUniversityId)
            case .dates: DatesPickerSheet(startDate: $store.context.startDate, endDate: $store.context.endDate)
            case .who: WhoTravelingSheet(party: $store.context.travelParty)
            case .startingFrom: StartingFromPickerSheet(selectedId: $store.context.startingUniversityId, excluding: store.context.destinationUniversityId)
            case .sport: SportPickerSheet(selectedSport: $store.context.sport)
            }
        }
    }

    private func row(label: String, value: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(label).font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                    Label(value, systemImage: icon).font(.system(size: 15, weight: .medium)).foregroundStyle(.primary)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16).padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}
