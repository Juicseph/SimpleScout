import Foundation
import Combine

struct ActiveTripContext {
    var destinationUniversityId: String
    var startingUniversityId: String?
    var startDate: String
    var endDate: String
    var sport: Sport
    var travelParty: TravelParty
    var currentHotelPlaceId: String?
    var anchor: DistanceAnchor
}

/// App-wide active trip context — the single source of truth that makes party
/// size, dates, and destination available everywhere without re-passing them.
/// See docs/ARCHITECTURE.md §9.
final class TripStore: ObservableObject {
    static let shared = TripStore()

    @Published var hasSearched = false
    @Published var canFitTeamOnly = true
    @Published var context: ActiveTripContext

    private init() {
        context = ActiveTripContext(
            destinationUniversityId: DemoUniversities.ohioState.id,
            startingUniversityId: DemoUniversities.fresnoState.id,
            startDate: DemoTrip.trip.startDate,
            endDate: DemoTrip.trip.endDate,
            sport: DemoTrip.trip.sport,
            travelParty: DemoTrip.trip.travelParty,
            currentHotelPlaceId: DemoTrip.trip.currentHotelPlaceId,
            anchor: .university
        )
    }

    func runSearch() { hasSearched = true }

    func reset() {
        hasSearched = false
    }
}
