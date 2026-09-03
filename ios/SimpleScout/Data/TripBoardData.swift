import Foundation

struct TripLogistics {
    let airportName: String
    let airportCode: String
    let airportNotes: String
    let generalNotes: [String]
}

enum DemoTripBoard {
    private static let tripId = DemoTrip.trip.id

    static let places: [TripPlace] = [
        TripPlace(id: "tp_hotel", tripId: tripId, placeId: "place_marriott_columbus", section: .hotel),
        TripPlace(id: "tp_team_dinner", tripId: tripId, placeId: "place_hyde_park_steakhouse", section: .teamDinner, notes: "Private room upstairs, requested by 5:15 PM for a 6:00 PM sit-down."),
        TripPlace(id: "tp_pregame_meal", tripId: tripId, placeId: "place_bibibop", section: .pregameMeal, notes: "Order called in for pickup 90 minutes before the bus departs the hotel."),
        TripPlace(id: "tp_postgame_meal", tripId: tripId, placeId: "place_adriaticos", section: .postgameMeal, notes: "Open until 2:30 AM — good fallback if the match runs long."),
        TripPlace(id: "tp_catering", tripId: tripId, placeId: "place_cameron_mitchell_catering", section: .catering),
        TripPlace(id: "tp_grocery", tripId: tripId, placeId: "place_kroger", section: .grocery),
        TripPlace(id: "tp_equipment", tripId: tripId, placeId: "place_dicks_sporting_goods", section: .equipment),
        TripPlace(id: "tp_emergency_pharmacy", tripId: tripId, placeId: "place_cvs_pharmacy", section: .emergencyResources),
        TripPlace(id: "tp_emergency_medical", tripId: tripId, placeId: "place_ohiohealth_urgent_care", section: .emergencyResources),
    ]

    static let logistics = TripLogistics(
        airportName: "John Glenn Columbus International Airport",
        airportCode: "CMH",
        airportNotes: "Charter arrives at the general aviation terminal — bus staged curbside for a direct load.",
        generalNotes: [
            "Athletic trainer is carrying the full medical kit as checked baggage — cleared with the airline in advance.",
            "Equipment manager confirmed ball cart + film equipment ships separately via team freight, arriving Thursday.",
        ]
    )

    static let itinerary: [ItineraryItem] = [
        ItineraryItem(id: "it_1", tripId: tripId, title: "Arrive Airport", startsAt: "2026-09-12T14:30:00", notes: "CMH general aviation terminal"),
        ItineraryItem(id: "it_2", tripId: tripId, title: "Depart Airport", startsAt: "2026-09-12T15:15:00", notes: "Bus direct to hotel"),
        ItineraryItem(id: "it_3", tripId: tripId, placeId: "place_marriott_columbus", title: "Hotel Check-In", startsAt: "2026-09-12T15:45:00"),
        ItineraryItem(id: "it_4", tripId: tripId, placeId: "place_hyde_park_steakhouse", title: "Team Dinner", startsAt: "2026-09-12T17:30:00", endsAt: "2026-09-12T19:00:00"),
        ItineraryItem(id: "it_5", tripId: tripId, venueId: "venue_covelli", title: "Practice", startsAt: "2026-09-12T19:30:00", endsAt: "2026-09-12T21:00:00"),
        ItineraryItem(id: "it_6", tripId: tripId, placeId: "place_marriott_columbus", title: "Breakfast", startsAt: "2026-09-13T08:00:00", notes: "Early spread available from 6:30 AM on request."),
        ItineraryItem(id: "it_7", tripId: tripId, title: "Film Session", startsAt: "2026-09-13T10:00:00", endsAt: "2026-09-13T11:00:00", notes: "Hotel meeting room, 2nd floor"),
        ItineraryItem(id: "it_8", tripId: tripId, placeId: "place_bibibop", title: "Pregame Meal", startsAt: "2026-09-13T12:00:00"),
        ItineraryItem(id: "it_9", tripId: tripId, venueId: "venue_covelli", title: "Match vs. Ohio State", startsAt: "2026-09-13T16:00:00", endsAt: "2026-09-13T18:30:00"),
        ItineraryItem(id: "it_10", tripId: tripId, placeId: "place_adriaticos", title: "Postgame Meal", startsAt: "2026-09-13T19:30:00"),
        ItineraryItem(id: "it_11", tripId: tripId, placeId: "place_marriott_columbus", title: "Breakfast", startsAt: "2026-09-14T09:00:00"),
        ItineraryItem(id: "it_12", tripId: tripId, placeId: "place_marriott_columbus", title: "Hotel Check-Out", startsAt: "2026-09-14T10:30:00"),
        ItineraryItem(id: "it_13", tripId: tripId, title: "Depart for Airport", startsAt: "2026-09-14T11:00:00"),
    ]
}
