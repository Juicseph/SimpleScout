import Foundation

enum DemoPlaces {
    private static let univ = DemoUniversities.ohioState.id

    static let marriottColumbus = Place(
        id: "place_marriott_columbus", category: .hotel, name: "Columbus Marriott University Area",
        address: "3100 Olentangy River Rd, Columbus, OH", location: LatLng(lat: 40.0106, lng: -83.0192),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_marriott_columbus", publicRating: 4.5, publicRatingCount: 1840, priceLevel: 2,
            phone: "(614) 559-2200", website: "https://marriott.com", hoursToday: .open24h, photoTheme: .hotelExterior
        ),
        athletics: AthleticsProfile(
            busParking: true, busParkingNotes: "Dedicated lot behind the hotel — easy in/out for a 56-passenger coach.",
            maxRecommendedGroup: 60, hasMeetingSpace: true, earlyBreakfastAvailable: true, lateCheckoutAvailable: true,
            laundryAvailable: true, fitnessRoom: true,
            groupSalesContact: GroupSalesContact(name: "Dana Whitfield", role: "Group Sales Manager", phone: "(614) 559-2244")
        ),
        capacity: PlaceCapacity(maxPartySize: 60, idealPartySizeMin: 15, idealPartySizeMax: 55),
        hotel: HotelDetails(totalRooms: 300, supportsRoomBlocks: true),
        tags: ["team_friendly", "bus_parking", "staff_favorite", "department_recommended"]
    )

    static let hyattPlaceOSU = Place(
        id: "place_hyatt_place_osu", category: .hotel, name: "Hyatt Place Columbus/OSU",
        address: "3005 Kenny Rd, Columbus, OH", location: LatLng(lat: 40.0131, lng: -83.0298),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_hyatt_osu", publicRating: 4.3, publicRatingCount: 960, priceLevel: 2,
            phone: "(614) 442-4855", website: "https://hyatt.com", hoursToday: .open24h, photoTheme: .hotelLobby
        ),
        athletics: AthleticsProfile(
            busParking: true, busParkingNotes: "Street-side loading only — fine for a single bus, tight for two.",
            maxRecommendedGroup: 40, hasMeetingSpace: false, earlyBreakfastAvailable: true, laundryAvailable: false,
            fitnessRoom: true,
            groupSalesContact: GroupSalesContact(name: "Marcus Ito", role: "Sales Coordinator", phone: "(614) 442-4860")
        ),
        capacity: PlaceCapacity(maxPartySize: 40, idealPartySizeMin: 10, idealPartySizeMax: 35),
        hotel: HotelDetails(totalRooms: 152, supportsRoomBlocks: true),
        tags: ["bus_parking", "fits_your_party"]
    )

    static let home2SuitesOSU = Place(
        id: "place_home2_suites_osu", category: .hotel, name: "Home2 Suites Columbus/OSU",
        address: "1546 N High St, Columbus, OH", location: LatLng(lat: 40.0058, lng: -83.0033),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_home2_osu", publicRating: 4.4, publicRatingCount: 512, priceLevel: 1,
            phone: "(614) 291-8000", website: "https://hilton.com", hoursToday: .open24h, photoTheme: .hotelLobby
        ),
        athletics: AthleticsProfile(
            busParking: false, busParkingNotes: "No dedicated lot — buses have used the metered lane on High St with advance notice.",
            maxRecommendedGroup: 30, hasMeetingSpace: false, earlyBreakfastAvailable: false, laundryAvailable: true,
            fitnessRoom: true
        ),
        capacity: PlaceCapacity(maxPartySize: 30, idealPartySizeMin: 8, idealPartySizeMax: 26),
        hotel: HotelDetails(totalRooms: 96, supportsRoomBlocks: true),
        tags: ["value"]
    )

    static let blackwellInn = Place(
        id: "place_blackwell_inn", category: .hotel, name: "The Blackwell Inn",
        address: "2110 Tuttle Park Pl, Columbus, OH", location: LatLng(lat: 40.0002, lng: -83.0157),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_blackwell", publicRating: 4.6, publicRatingCount: 720, priceLevel: 3,
            phone: "(614) 247-4000", website: "https://theblackwell.com", hoursToday: .open24h, photoTheme: .hotelExterior
        ),
        athletics: AthleticsProfile(
            busParking: false, busParkingNotes: "Small circular drive only — not built for coach buses.",
            maxRecommendedGroup: 20, hasMeetingSpace: true, laundryAvailable: false, fitnessRoom: true
        ),
        capacity: PlaceCapacity(maxPartySize: 20, idealPartySizeMin: 4, idealPartySizeMax: 18),
        hotel: HotelDetails(totalRooms: 221, supportsRoomBlocks: false),
        tags: []
    )

    static let hydeParkSteakhouse = Place(
        id: "place_hyde_park_steakhouse", category: .restaurant, name: "Hyde Park Prime Steakhouse",
        address: "1615 Old Henderson Rd, Columbus, OH", location: LatLng(lat: 40.0234, lng: -83.0561),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_hyde_park", publicRating: 4.6, publicRatingCount: 1420, priceLevel: 3,
            phone: "(614) 442-3310", website: "https://hydeparkrestaurants.com",
            hoursToday: .ranged(opens: "16:00", closes: "22:00"), photoTheme: .restaurantInterior
        ),
        athletics: AthleticsProfile(
            busParking: true, hasPrivateDining: true, maxRecommendedGroup: 35,
            dietaryOptions: ["vegetarian", "gluten_free"],
            groupSalesContact: GroupSalesContact(name: "Renee Coble", role: "Private Dining Manager", phone: "(614) 442-3312")
        ),
        capacity: PlaceCapacity(maxPartySize: 35, idealPartySizeMin: 15, idealPartySizeMax: 32),
        restaurant: RestaurantDetails(cuisine: "Steakhouse", familyStyle: true, reservationRequired: true),
        tags: ["large_group_friendly", "private_dining", "staff_favorite", "team_friendly"]
    )

    static let bibibop = Place(
        id: "place_bibibop", category: .restaurant, name: "Bibibop Asian Grill",
        address: "1900 N High St, Columbus, OH", location: LatLng(lat: 40.0028, lng: -83.0057),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_bibibop", publicRating: 4.4, publicRatingCount: 980, priceLevel: 1,
            phone: "(614) 298-9999", website: "https://bibibop.com",
            hoursToday: .ranged(opens: "10:30", closes: "22:00"), photoTheme: .quickService
        ),
        athletics: AthleticsProfile(
            deliveryAvailable: true, pickupAvailable: true, onlineOrdering: true, maxRecommendedGroup: 35,
            dietaryOptions: ["vegetarian", "vegan", "gluten_free"]
        ),
        capacity: PlaceCapacity(maxPartySize: 40, idealPartySizeMin: 15, idealPartySizeMax: 35),
        restaurant: RestaurantDetails(cuisine: "Fast Casual · Korean-Asian", quickMealFriendly: true, estimatedPrepMinutes: 20),
        tags: ["fast_team_meal", "team_friendly"]
    )

    static let chipotleLane = Place(
        id: "place_chipotle_lane", category: .restaurant, name: "Chipotle Mexican Grill",
        address: "1636 N High St, Columbus, OH", location: LatLng(lat: 40.0018, lng: -83.0043),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_chipotle_lane", publicRating: 4.1, publicRatingCount: 1250, priceLevel: 1,
            phone: "(614) 421-9200", website: "https://chipotle.com",
            hoursToday: .ranged(opens: "10:45", closes: "23:00"), photoTheme: .quickService
        ),
        athletics: AthleticsProfile(
            deliveryAvailable: true, pickupAvailable: true, onlineOrdering: true, maxRecommendedGroup: 40,
            dietaryOptions: ["vegetarian", "vegan", "gluten_free"]
        ),
        capacity: PlaceCapacity(maxPartySize: 40, idealPartySizeMin: 15, idealPartySizeMax: 40),
        restaurant: RestaurantDetails(cuisine: "Fast Casual · Mexican", quickMealFriendly: true, estimatedPrepMinutes: 15),
        tags: ["fast_team_meal", "open_late", "team_friendly", "used_before"]
    )

    static let piada = Place(
        id: "place_piada", category: .restaurant, name: "Piada Italian Street Food",
        address: "2277 Olentangy River Rd, Columbus, OH", location: LatLng(lat: 40.0159, lng: -83.0223),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_piada", publicRating: 4.3, publicRatingCount: 640, priceLevel: 1,
            phone: "(614) 429-4900", website: "https://piada.com",
            hoursToday: .ranged(opens: "10:30", closes: "22:00"), photoTheme: .quickService
        ),
        athletics: AthleticsProfile(
            deliveryAvailable: true, pickupAvailable: true, onlineOrdering: true, maxRecommendedGroup: 30,
            cateringAvailable: true, dietaryOptions: ["vegetarian", "gluten_free"]
        ),
        capacity: PlaceCapacity(maxPartySize: 32, idealPartySizeMin: 10, idealPartySizeMax: 30),
        restaurant: RestaurantDetails(cuisine: "Fast Casual · Italian", quickMealFriendly: true, estimatedPrepMinutes: 18),
        tags: ["fast_team_meal", "catering"]
    )

    static let thurmanCafe = Place(
        id: "place_thurman_cafe", category: .restaurant, name: "The Thurman Cafe",
        address: "183 Thurman Ave, Columbus, OH", location: LatLng(lat: 39.9505, lng: -83.0018),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_thurman", publicRating: 4.7, publicRatingCount: 3400, priceLevel: 2,
            phone: "(614) 443-1570", website: "https://thethurmancafe.com",
            hoursToday: .ranged(opens: "11:00", closes: "22:00"), photoTheme: .restaurantInterior
        ),
        athletics: AthleticsProfile(busParking: false, maxRecommendedGroup: 12),
        capacity: PlaceCapacity(maxPartySize: 12, idealPartySizeMin: 2, idealPartySizeMax: 10),
        restaurant: RestaurantDetails(cuisine: "American · Burgers", reservationRequired: false),
        tags: []
    )

    static let adriaticos = Place(
        id: "place_adriaticos", category: .restaurant, name: "Adriatico's Restaurant & Pizza",
        address: "2183 N High St, Columbus, OH", location: LatLng(lat: 40.0086, lng: -83.0093),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_adriaticos", publicRating: 4.4, publicRatingCount: 810, priceLevel: 1,
            phone: "(614) 291-1618", website: "https://adriaticos.com",
            hoursToday: .ranged(opens: "11:00", closes: "02:30"), photoTheme: .quickService
        ),
        athletics: AthleticsProfile(
            deliveryAvailable: true, pickupAvailable: true, onlineOrdering: true, maxRecommendedGroup: 30,
            cateringAvailable: true, dietaryOptions: ["vegetarian"]
        ),
        capacity: PlaceCapacity(maxPartySize: 32, idealPartySizeMin: 10, idealPartySizeMax: 30),
        restaurant: RestaurantDetails(cuisine: "Pizza", quickMealFriendly: true, estimatedPrepMinutes: 25),
        tags: ["open_late", "fast_team_meal"]
    )

    static let cameronMitchellCatering = Place(
        id: "place_cameron_mitchell_catering", category: .caterer, name: "Cameron Mitchell Premier Events Catering",
        address: "281 W Nationwide Blvd, Columbus, OH", location: LatLng(lat: 39.9721, lng: -83.0086),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_cm_catering", publicRating: 4.8, publicRatingCount: 210, priceLevel: 2,
            phone: "(614) 621-3663", website: "https://cameronmitchell.com/catering",
            hoursToday: .ranged(opens: "08:00", closes: "20:00"), photoTheme: .catering
        ),
        athletics: AthleticsProfile(
            cateringAvailable: true, maxRecommendedGroup: 200,
            dietaryOptions: ["vegetarian", "vegan", "gluten_free", "dairy_free"],
            groupSalesContact: GroupSalesContact(name: "Priya Nair", role: "Catering Director", phone: "(614) 621-3665")
        ),
        capacity: PlaceCapacity(maxPartySize: 200, idealPartySizeMin: 20, idealPartySizeMax: 150),
        caterer: CatererDetails(
            minOrderCount: 20, leadTimeHours: 24, servesBreakfast: true, servesLunch: true, servesDinner: true,
            boxedMeals: true, buffet: true, estimatedCostPerPerson: 18
        ),
        tags: ["catering", "department_recommended"]
    )

    static let dicksSportingGoods = Place(
        id: "place_dicks_sporting_goods", category: .store, name: "DICK'S Sporting Goods",
        address: "1534 Bethel Rd, Columbus, OH", location: LatLng(lat: 40.0673, lng: -83.0656),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_dicks", publicRating: 4.3, publicRatingCount: 1120, priceLevel: 2,
            phone: "(614) 442-7500", website: "https://dickssportinggoods.com",
            hoursToday: .ranged(opens: "09:00", closes: "21:00"), photoTheme: .sportingGoods
        ),
        athletics: AthleticsProfile(pickupAvailable: true),
        capacity: PlaceCapacity(),
        store: StoreDetails(storeType: "sporting_goods", likelyInventory: ["Athletic Tape", "Volleyballs", "Knee Pads", "Ball Pumps"]),
        tags: []
    )

    static let bestBuy = Place(
        id: "place_best_buy", category: .store, name: "Best Buy",
        address: "1585 W Lane Ave, Columbus, OH", location: LatLng(lat: 40.0075, lng: -83.0459),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_bestbuy", publicRating: 4.2, publicRatingCount: 980, priceLevel: 2,
            phone: "(614) 486-8730", website: "https://bestbuy.com",
            hoursToday: .ranged(opens: "10:00", closes: "21:00"), photoTheme: .electronics
        ),
        athletics: AthleticsProfile(pickupAvailable: true),
        capacity: PlaceCapacity(),
        store: StoreDetails(storeType: "electronics", likelyInventory: ["HDMI Cable", "Phone Charger", "Laptop Charger", "Power Strip"]),
        tags: []
    )

    static let cvsPharmacy = Place(
        id: "place_cvs_pharmacy", category: .pharmacy, name: "CVS Pharmacy",
        address: "1826 N High St, Columbus, OH", location: LatLng(lat: 40.0022, lng: -83.0047),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_cvs", publicRating: 3.9, publicRatingCount: 340, priceLevel: 1,
            phone: "(614) 291-9270", website: "https://cvs.com", hoursToday: .open24h, photoTheme: .pharmacy
        ),
        athletics: AthleticsProfile(pickupAvailable: true),
        capacity: PlaceCapacity(),
        store: StoreDetails(storeType: "pharmacy", likelyInventory: ["First Aid Supplies", "Ibuprofen", "Athletic Tape"]),
        tags: ["open_now"]
    )

    static let kroger = Place(
        id: "place_kroger", category: .grocery, name: "Kroger",
        address: "1350 N High St, Columbus, OH", location: LatLng(lat: 39.9924, lng: -83.0032),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_kroger", publicRating: 4.0, publicRatingCount: 610, priceLevel: 1,
            phone: "(614) 299-4341", website: "https://kroger.com",
            hoursToday: .ranged(opens: "06:00", closes: "23:00"), photoTheme: .grocery
        ),
        athletics: AthleticsProfile(pickupAvailable: true),
        capacity: PlaceCapacity(),
        store: StoreDetails(storeType: "grocery", likelyInventory: ["Water", "Ice", "Snacks", "Gatorade"]),
        tags: []
    )

    static let ohioHealthUrgentCare = Place(
        id: "place_ohiohealth_urgent_care", category: .medical, name: "OhioHealth Urgent Care",
        address: "2101 N High St, Columbus, OH", location: LatLng(lat: 40.0067, lng: -83.0071),
        universityId: univ,
        external: PlaceExternalRef(
            providerPlaceId: "g_ohiohealth", publicRating: 4.4, publicRatingCount: 260, priceLevel: 1,
            phone: "(614) 442-9000", website: "https://ohiohealth.com",
            hoursToday: .ranged(opens: "08:00", closes: "20:00"), photoTheme: .medical
        ),
        athletics: AthleticsProfile(),
        capacity: PlaceCapacity(),
        tags: []
    )

    static let all: [Place] = [
        marriottColumbus, hyattPlaceOSU, home2SuitesOSU, blackwellInn,
        hydeParkSteakhouse, bibibop, chipotleLane, piada, thurmanCafe, adriaticos,
        cameronMitchellCatering,
        dicksSportingGoods, bestBuy, cvsPharmacy, kroger, ohioHealthUrgentCare,
    ]

    static func byId(_ id: String) -> Place? {
        all.first { $0.id == id }
    }

    static func byUniversity(_ universityId: String, category: PlaceCategory? = nil) -> [Place] {
        all.filter { $0.universityId == universityId && (category == nil || $0.category == category) }
    }
}
