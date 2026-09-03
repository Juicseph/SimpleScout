import Foundation

enum PartySizeBucket: String, Equatable, Hashable {
    case tiny = "1-10"
    case small = "11-20"
    case medium = "21-30"
    case large = "31-50"
    case xlarge = "50+"
}

func partySizeBucket(_ size: Int) -> PartySizeBucket {
    switch size {
    case ...10: return .tiny
    case ...20: return .small
    case ...30: return .medium
    case ...50: return .large
    default: return .xlarge
    }
}

/// How well a place's capacity fits an exact party size, 0-1.
/// A place under its ideal range still "fits" if it's under max; a place at or
/// over max is demoted sharply rather than hidden — see docs/ARCHITECTURE.md §9.
func partySizeFit(_ partySize: Int, capacity: PlaceCapacity) -> Double {
    if let maxPartySize = capacity.maxPartySize, partySize > maxPartySize {
        let overBy = Double(partySize - maxPartySize)
        return max(0.05, 0.35 - overBy / Double(maxPartySize + 1))
    }

    if let min = capacity.idealPartySizeMin, let max = capacity.idealPartySizeMax {
        if partySize >= min && partySize <= max { return 1 }
        if partySize < min {
            let gap = Double(min - partySize)
            return Swift.max(0.5, 1 - gap / Double(min + 1))
        }
        let gap = Double(partySize - max)
        return Swift.max(0.4, 1 - gap / Double(max + 1))
    }

    if let maxPartySize = capacity.maxPartySize {
        return partySize <= maxPartySize ? 0.85 : 0.2
    }

    return 0.6 // unknown capacity — neutral, not disqualifying
}

func meetsPartyRequirement(_ partySize: Int, capacity: PlaceCapacity) -> Bool {
    guard let maxPartySize = capacity.maxPartySize else { return true }
    return partySize <= maxPartySize
}
