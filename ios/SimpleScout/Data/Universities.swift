import Foundation

enum DemoUniversities {
    static let ohioState = University(
        id: "univ_osu", name: "Ohio State University", slug: "ohio-state",
        city: "Columbus", state: "OH", location: LatLng(lat: 40.0067, lng: -83.0305),
        primaryColorHex: "#a6192e", abbreviation: "OSU"
    )

    static let fresnoState = University(
        id: "univ_fresno", name: "Fresno State", slug: "fresno-state",
        city: "Fresno", state: "CA", location: LatLng(lat: 36.8125, lng: -119.7462),
        primaryColorHex: "#c41230", abbreviation: "FRES"
    )

    static let ucla = University(
        id: "univ_ucla", name: "UCLA", slug: "ucla",
        city: "Los Angeles", state: "CA", location: LatLng(lat: 34.0689, lng: -118.4452),
        primaryColorHex: "#2774ae", abbreviation: "UCLA"
    )

    static let boiseState = University(
        id: "univ_boise", name: "Boise State University", slug: "boise-state",
        city: "Boise", state: "ID", location: LatLng(lat: 43.6035, lng: -116.1996),
        primaryColorHex: "#0033a0", abbreviation: "BSU"
    )

    static let stanford = University(
        id: "univ_stanford", name: "Stanford University", slug: "stanford",
        city: "Stanford", state: "CA", location: LatLng(lat: 37.4275, lng: -122.1697),
        primaryColorHex: "#8c1515", abbreviation: "STAN"
    )

    static let all: [University] = [ohioState, fresnoState, ucla, boiseState, stanford]

    static let covelliCenter = Venue(
        id: "venue_covelli", universityId: ohioState.id, name: "Covelli Center",
        sport: "volleyball", location: LatLng(lat: 40.0093, lng: -83.0225)
    )

    static let venues: [Venue] = [covelliCenter]

    static func university(bySlug slug: String) -> University? {
        all.first { $0.slug == slug }
    }

    static func venue(byId id: String) -> Venue? {
        venues.first { $0.id == id }
    }

    static func search(_ query: String) -> [University] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return all }
        return all.filter {
            $0.name.lowercased().contains(q) || $0.city.lowercased().contains(q) || $0.abbreviation.lowercased().contains(q)
        }
    }
}
