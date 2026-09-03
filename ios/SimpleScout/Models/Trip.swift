import Foundation

struct TravelParty: Codable, Equatable {
    var athletes: Int
    var coaches: Int
    var staff: Int

    var total: Int { athletes + coaches + staff }
}

enum TripStatus: String, Codable, Equatable, Hashable {
    case planning, confirmed, active, completed, cancelled
}

struct Trip: Identifiable, Codable, Equatable {
    let id: String
    let teamId: String
    let teamName: String
    let sport: Sport
    let destinationUniversityId: String
    var startingUniversityId: String? = nil
    var venueId: String? = nil
    let startDate: String // yyyy-MM-dd
    let endDate: String
    var travelParty: TravelParty
    var currentHotelPlaceId: String? = nil
    var status: TripStatus

    static func isTravelModeActive(startDate: String, endDate: String, now: Date = Date()) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        guard let start = formatter.date(from: startDate), let end = formatter.date(from: endDate) else { return false }
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: end) ?? end
        return now >= start && now <= endOfDay
    }
}

enum DistanceAnchor: String, Equatable, Hashable {
    case university, venue, hotel, airport, currentLocation, custom
}

struct ItineraryItem: Identifiable, Codable, Equatable {
    let id: String
    let tripId: String
    var placeId: String? = nil
    var venueId: String? = nil
    let title: String
    let startsAt: String // ISO datetime, local
    var endsAt: String? = nil
    var notes: String? = nil
}

enum TripPlaceSection: String, Codable, CaseIterable, Hashable {
    case hotel
    case teamDinner = "team_dinner"
    case pregameMeal = "pregame_meal"
    case postgameMeal = "postgame_meal"
    case catering
    case grocery
    case equipment
    case emergencyResources = "emergency_resources"

    var label: String {
        switch self {
        case .hotel: return "Hotel"
        case .teamDinner: return "Team Dinner"
        case .pregameMeal: return "Pregame Meal"
        case .postgameMeal: return "Postgame Meal"
        case .catering: return "Catering"
        case .grocery: return "Grocery"
        case .equipment: return "Equipment"
        case .emergencyResources: return "Emergency Resources"
        }
    }
}

struct TripPlace: Identifiable, Codable, Equatable {
    let id: String
    let tripId: String
    let placeId: String
    let section: TripPlaceSection
    var notes: String? = nil
}
