import Foundation

enum SearchService {
    static func anchorLocation(universityId: String, anchor: DistanceAnchor, currentHotelPlaceId: String?) -> LatLng {
        switch anchor {
        case .venue:
            return DemoUniversities.covelliCenter.location
        case .hotel:
            if let hotelId = currentHotelPlaceId, let hotel = DemoPlaces.byId(hotelId) {
                return hotel.location
            }
            fallthrough
        default:
            return DemoUniversities.all.first { $0.id == universityId }?.location ?? DemoUniversities.ohioState.location
        }
    }

    static func searchPlaces(
        universityId: String,
        category: PlaceCategory?,
        travelParty: TravelParty,
        anchor: DistanceAnchor,
        currentHotelPlaceId: String?,
        requirePartyFit: Bool
    ) -> [RankedPlace] {
        let places = DemoPlaces.byUniversity(universityId, category: category)
        let anchorPoint = anchorLocation(universityId: universityId, anchor: anchor, currentHotelPlaceId: currentHotelPlaceId)

        var options = RankPlacesOptions(partySize: travelParty.total, anchor: anchorPoint)
        options.anchorRadiusMi = 20
        options.knowledgeByPlaceId = DemoKnowledge.summaries
        options.requirePartyFit = requirePartyFit

        return rankPlaces(places, options: options)
    }
}
