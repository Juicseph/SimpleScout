import Foundation

enum PlaceCategory: String, Codable, Equatable, Hashable {
    case hotel, restaurant, store, caterer, venue, pharmacy, medical, grocery, equipment, tech, transportation, other
}

enum PhotoTheme: String, Codable, Equatable, Hashable {
    case hotelLobby = "hotel-lobby"
    case hotelExterior = "hotel-exterior"
    case restaurantInterior = "restaurant-interior"
    case quickService = "quick-service"
    case catering
    case sportingGoods = "sporting-goods"
    case electronics
    case pharmacy
    case grocery
    case medical
    case venue
}

enum Hours: Codable, Equatable, Hashable {
    case open24h
    case closed
    case ranged(opens: String, closes: String)
}

/// Data that comes from a third-party provider (Google Places today). Never
/// the source of truth for anything proprietary — see docs/ARCHITECTURE.md §14.
struct PlaceExternalRef: Codable, Equatable {
    var provider: String = "google_places"
    let providerPlaceId: String
    var publicRating: Double? = nil
    var publicRatingCount: Int? = nil
    var priceLevel: Int? = nil // 0-4
    var phone: String? = nil
    var website: String? = nil
    var hoursToday: Hours? = nil
    let photoTheme: PhotoTheme
}

struct GroupSalesContact: Codable, Equatable {
    let name: String
    let role: String
    var phone: String? = nil
    var email: String? = nil
}

/// Proprietary, department-agnostic facts SimpleScout owns about a place.
struct AthleticsProfile: Codable, Equatable {
    var busParking: Bool? = nil
    var busParkingNotes: String? = nil
    var maxRecommendedGroup: Int? = nil
    var hasPrivateDining: Bool? = nil
    var hasMeetingSpace: Bool? = nil
    var earlyBreakfastAvailable: Bool? = nil
    var lateCheckoutAvailable: Bool? = nil
    var laundryAvailable: Bool? = nil
    var fitnessRoom: Bool? = nil
    var deliveryAvailable: Bool? = nil
    var pickupAvailable: Bool? = nil
    var cateringAvailable: Bool? = nil
    var onlineOrdering: Bool? = nil
    var dietaryOptions: [String] = []
    var groupSalesContact: GroupSalesContact? = nil
}

struct HotelDetails: Codable, Equatable {
    var totalRooms: Int? = nil
    var supportsRoomBlocks: Bool = true
}

struct RestaurantDetails: Codable, Equatable {
    let cuisine: String
    var familyStyle: Bool? = nil
    var buffet: Bool? = nil
    var reservationRequired: Bool? = nil
    var quickMealFriendly: Bool? = nil
    var estimatedPrepMinutes: Int? = nil
}

struct StoreDetails: Codable, Equatable {
    let storeType: String
    var likelyInventory: [String] = []
}

struct CatererDetails: Codable, Equatable {
    var minOrderCount: Int? = nil
    var leadTimeHours: Int? = nil
    var servesBreakfast: Bool? = nil
    var servesLunch: Bool? = nil
    var servesDinner: Bool? = nil
    var boxedMeals: Bool? = nil
    var buffet: Bool? = nil
    var estimatedCostPerPerson: Double? = nil
}

struct PlaceCapacity: Codable, Equatable {
    var maxPartySize: Int? = nil
    var idealPartySizeMin: Int? = nil
    var idealPartySizeMax: Int? = nil
}

struct Place: Identifiable, Codable, Equatable {
    let id: String
    let category: PlaceCategory
    let name: String
    let address: String
    let location: LatLng
    let universityId: String
    var external: PlaceExternalRef
    var athletics: AthleticsProfile
    var capacity: PlaceCapacity
    var hotel: HotelDetails? = nil
    var restaurant: RestaurantDetails? = nil
    var store: StoreDetails? = nil
    var caterer: CatererDetails? = nil
    var tags: [String] = []
}
