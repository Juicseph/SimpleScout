import Foundation

private let earthRadiusMi = 3958.8

func haversineMiles(_ a: LatLng, _ b: LatLng) -> Double {
    func toRad(_ deg: Double) -> Double { deg * .pi / 180 }
    let dLat = toRad(b.lat - a.lat)
    let dLng = toRad(b.lng - a.lng)
    let lat1 = toRad(a.lat)
    let lat2 = toRad(b.lat)

    let h = pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLng / 2), 2)
    return earthRadiusMi * 2 * asin(sqrt(h))
}

/// Rough drive-time estimate for demo purposes (avg urban/suburban speed).
func estimatedDriveMinutes(_ miles: Double) -> Int {
    let avgMph: Double = miles < 2 ? 18 : (miles < 8 ? 28 : 42)
    return max(2, Int((miles / avgMph * 60).rounded()))
}

/// 0-1 score, 1 = essentially at the anchor, decaying to 0 by maxRadiusMi.
func distanceScore(_ miles: Double, maxRadiusMi: Double = 15) -> Double {
    if miles <= 0.5 { return 1 }
    if miles >= maxRadiusMi { return 0.05 }
    return max(0.05, 1 - miles / maxRadiusMi)
}
