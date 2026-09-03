import Foundation
import CoreLocation

struct LatLng: Codable, Equatable {
    let lat: Double
    let lng: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

struct University: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let slug: String
    let city: String
    let state: String
    let location: LatLng
    let primaryColorHex: String
    let abbreviation: String
}

struct Venue: Identifiable, Codable, Equatable {
    let id: String
    let universityId: String
    let name: String
    let sport: String?
    let location: LatLng
}
