import Foundation

enum DemoTrip {
    static let trip = Trip(
        id: "trip_demo_osu",
        teamId: "team_fresno_wvb",
        teamName: "Fresno State Women's Volleyball",
        sport: .volleyball,
        destinationUniversityId: DemoUniversities.ohioState.id,
        startingUniversityId: DemoUniversities.fresnoState.id,
        venueId: DemoUniversities.covelliCenter.id,
        startDate: "2026-09-12",
        endDate: "2026-09-14",
        travelParty: TravelParty(athletes: 18, coaches: 6, staff: 4),
        currentHotelPlaceId: "place_marriott_columbus",
        status: .planning
    )
}
