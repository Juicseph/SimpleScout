import Foundation

enum ExploreCategory: String, CaseIterable, Identifiable, Equatable, Hashable {
    case stay, teamMeals, quickMeals, catering, groceries, equipment, tech, pharmacy, medical, transportation

    var id: String { rawValue }

    var label: String {
        switch self {
        case .stay: return "Stay"
        case .teamMeals: return "Team Meals"
        case .quickMeals: return "Quick Meals"
        case .catering: return "Catering"
        case .groceries: return "Groceries"
        case .equipment: return "Equipment"
        case .tech: return "Tech"
        case .pharmacy: return "Pharmacy"
        case .medical: return "Medical"
        case .transportation: return "Transportation"
        }
    }

    var systemImage: String {
        switch self {
        case .stay: return "bed.double.fill"
        case .teamMeals: return "fork.knife"
        case .quickMeals: return "takeoutbag.and.cup.and.straw.fill"
        case .catering: return "flame.fill"
        case .groceries: return "basket.fill"
        case .equipment: return "dumbbell.fill"
        case .tech: return "tv.fill"
        case .pharmacy: return "cross.case.fill"
        case .medical: return "stethoscope"
        case .transportation: return "bus.fill"
        }
    }

    var placeCategory: PlaceCategory? {
        switch self {
        case .stay: return .hotel
        case .teamMeals, .quickMeals: return .restaurant
        case .catering: return .caterer
        case .groceries: return .grocery
        case .equipment, .tech: return .store
        case .pharmacy: return .pharmacy
        case .medical: return .medical
        case .transportation: return .transportation
        }
    }

    func matches(_ place: Place) -> Bool {
        switch self {
        case .teamMeals: return place.category == .restaurant && place.restaurant?.quickMealFriendly != true
        case .quickMeals: return place.category == .restaurant && place.restaurant?.quickMealFriendly == true
        case .equipment: return place.category == .store && place.store?.storeType == "sporting_goods"
        case .tech: return place.category == .store && place.store?.storeType == "electronics"
        default: return place.category == placeCategory
        }
    }
}
