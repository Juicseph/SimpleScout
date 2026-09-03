import Foundation

struct TeamFitFactor: Identifiable {
    var id: String { key }
    let key: String
    let label: String
    let value: Double // 0-1
}

struct TeamFitResult {
    let score: Int // 0-100
    let factors: [TeamFitFactor]
    let headline: String
    let fitsParty: Bool
}

private func groupExperienceScore(_ place: Place) -> Double {
    let a = place.athletics
    var points = 0.3
    if a.hasPrivateDining == true { points += 0.2 }
    if a.hasMeetingSpace == true { points += 0.15 }
    if a.busParking == true { points += 0.2 }
    if place.restaurant?.familyStyle == true || place.restaurant?.buffet == true { points += 0.15 }
    return min(1, points)
}

private func athleticsHistoryScore(_ knowledge: KnowledgeSummary?) -> Double {
    guard let knowledge else { return 0.4 }
    var score = 0.35
    if let rating = knowledge.athleticsRating { score += (rating / 5) * 0.35 }
    let visits = knowledge.departmentVisits?.visitCount ?? 0
    if visits > 0 { score += min(0.2, Double(visits) * 0.07) }
    if let network = knowledge.networkSignal, network.teamsUsedCount > 0 {
        score += min(0.15, Double(network.teamsUsedCount) * 0.01)
    }
    return min(1, score)
}

private func hoursFitScore(_ place: Place, nowHour: Int?) -> Double {
    guard let hours = place.external.hoursToday else { return 0.6 }
    switch hours {
    case .open24h: return 1
    case .closed: return 0.05
    case .ranged(let opens, let closes):
        guard let nowHour else { return 0.75 }
        let opensH = Int(opens.split(separator: ":").first ?? "0") ?? 0
        let closesH = Int(closes.split(separator: ":").first ?? "23") ?? 23
        return (nowHour >= opensH && nowHour < closesH) ? 1 : 0.15
    }
}

private func dietaryScore(_ place: Place) -> Double {
    guard place.category == .restaurant || place.category == .caterer else { return 0.7 }
    return min(1, 0.25 + Double(place.athletics.dietaryOptions.count) * 0.18)
}

private func valueScore(_ place: Place) -> Double {
    guard let level = place.external.priceLevel else { return 0.6 }
    let table = [0.55, 0.85, 1, 0.75, 0.5]
    return level >= 0 && level < table.count ? table[level] : 0.6
}

private func publicRatingScore(_ place: Place) -> Double {
    guard let rating = place.external.publicRating else { return 0.5 }
    return min(1, rating / 5)
}

func computeTeamFitScore(
    place: Place,
    partySize: Int,
    anchor: LatLng,
    anchorRadiusMi: Double = 15,
    knowledge: KnowledgeSummary? = nil,
    nowHour: Int? = nil
) -> TeamFitResult {
    let w = weights(for: place.category)
    let miles = haversineMiles(anchor, place.location)

    let factors: [TeamFitFactor] = [
        .init(key: "partySizeFit", label: "Fits your party size", value: partySizeFit(partySize, capacity: place.capacity)),
        .init(key: "distance", label: "Distance", value: distanceScore(miles, maxRadiusMi: anchorRadiusMi)),
        .init(key: "groupExperience", label: "Group experience", value: groupExperienceScore(place)),
        .init(key: "athleticsHistory", label: "Athletics history", value: athleticsHistoryScore(knowledge)),
        .init(key: "hoursFit", label: "Hours fit", value: hoursFitScore(place, nowHour: nowHour)),
        .init(key: "dietary", label: "Dietary accommodation", value: dietaryScore(place)),
        .init(key: "value", label: "Value fit", value: valueScore(place)),
        .init(key: "publicRating", label: "Public rating", value: publicRatingScore(place)),
    ]

    let weightMap: [String: Double] = [
        "partySizeFit": w.partySizeFit, "distance": w.distance, "groupExperience": w.groupExperience,
        "athleticsHistory": w.athleticsHistory, "hoursFit": w.hoursFit, "dietary": w.dietary,
        "value": w.value, "publicRating": w.publicRating,
    ]

    let weighted = factors.reduce(0.0) { $0 + $1.value * (weightMap[$1.key] ?? 0) }
    let score = Int((weighted * 100).rounded())

    let fitsParty = place.capacity.maxPartySize.map { partySize <= $0 } ?? true
    let visits = knowledge?.departmentVisits?.visitCount ?? 0

    let headline: String
    if !fitsParty {
        headline = "May be tight for a party of \(partySize)"
    } else if visits > 0 {
        headline = "Great fit for your party of \(partySize) · \(visits) previous department visit\(visits > 1 ? "s" : "")"
    } else {
        let roundedMiles = (miles * 10).rounded() / 10
        headline = "Great fit for your party of \(partySize) · \(roundedMiles) mi away"
    }

    return TeamFitResult(score: score, factors: factors, headline: headline, fitsParty: fitsParty)
}
