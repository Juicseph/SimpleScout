import Foundation

struct RankedPlace: Identifiable {
    var id: String { place.id }
    let place: Place
    let fit: TeamFitResult
    let knowledge: KnowledgeSummary?
    let distanceMi: Double
    let driveMinutes: Int
}

struct RankPlacesOptions {
    let partySize: Int
    let anchor: LatLng
    var anchorRadiusMi: Double = 15
    var nowHour: Int?
    var knowledgeByPlaceId: [String: KnowledgeSummary] = [:]
    /// When true, places that can't fit the party are pushed below a divider
    /// instead of ranked purely on score — used by "Can Fit Our Team".
    var requirePartyFit: Bool = false
}

func rankPlaces(_ places: [Place], options: RankPlacesOptions) -> [RankedPlace] {
    var ranked = places.map { place -> RankedPlace in
        let knowledge = options.knowledgeByPlaceId[place.id]
        let fit = computeTeamFitScore(
            place: place,
            partySize: options.partySize,
            anchor: options.anchor,
            anchorRadiusMi: options.anchorRadiusMi,
            knowledge: knowledge,
            nowHour: options.nowHour
        )
        let distanceMi = haversineMiles(options.anchor, place.location)
        return RankedPlace(place: place, fit: fit, knowledge: knowledge, distanceMi: distanceMi, driveMinutes: estimatedDriveMinutes(distanceMi))
    }

    ranked.sort { a, b in
        if options.requirePartyFit && a.fit.fitsParty != b.fit.fitsParty {
            return a.fit.fitsParty && !b.fit.fitsParty
        }
        return a.fit.score > b.fit.score
    }

    return ranked
}
