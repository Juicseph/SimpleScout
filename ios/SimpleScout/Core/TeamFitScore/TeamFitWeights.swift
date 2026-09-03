import Foundation

struct TeamFitWeights {
    var partySizeFit: Double
    var distance: Double
    var groupExperience: Double
    var athleticsHistory: Double
    var hoursFit: Double
    var dietary: Double
    var value: Double
    var publicRating: Double
}

private let defaultWeights = TeamFitWeights(
    partySizeFit: 0.25, distance: 0.15, groupExperience: 0.15, athleticsHistory: 0.15,
    hoursFit: 0.10, dietary: 0.10, value: 0.05, publicRating: 0.05
)

private let hotelWeights = TeamFitWeights(
    partySizeFit: 0.28, distance: 0.18, groupExperience: 0.20, athleticsHistory: 0.16,
    hoursFit: 0.02, dietary: 0.02, value: 0.08, publicRating: 0.06
)

private let restaurantWeights = TeamFitWeights(
    partySizeFit: 0.24, distance: 0.14, groupExperience: 0.14, athleticsHistory: 0.14,
    hoursFit: 0.14, dietary: 0.12, value: 0.04, publicRating: 0.04
)

private let catererWeights = TeamFitWeights(
    partySizeFit: 0.30, distance: 0.05, groupExperience: 0.10, athleticsHistory: 0.15,
    hoursFit: 0.20, dietary: 0.15, value: 0.03, publicRating: 0.02
)

/// Category-specific config — see docs/ARCHITECTURE.md §10.
func weights(for category: PlaceCategory) -> TeamFitWeights {
    switch category {
    case .hotel: return hotelWeights
    case .restaurant: return restaurantWeights
    case .caterer: return catererWeights
    default: return defaultWeights
    }
}
