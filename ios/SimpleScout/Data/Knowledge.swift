import Foundation

enum DemoKnowledge {
    private static let marriottVisits: [TeamVisit] = [
        TeamVisit(id: "visit_1", placeId: "place_marriott_columbus", teamName: "Women's Basketball", sport: "basketball", visitedOn: "2024-03-08"),
        TeamVisit(id: "visit_2", placeId: "place_marriott_columbus", teamName: "Women's Basketball", sport: "basketball", visitedOn: "2025-02-14"),
        TeamVisit(id: "visit_3", placeId: "place_marriott_columbus", teamName: "Softball", sport: "softball", visitedOn: "2026-03-21"),
    ]

    private static let marriottNotes: [StaffNote] = [
        StaffNote(id: "note_1", placeId: "place_marriott_columbus", authorName: "Jamie Ortega", authorRole: "Director of Operations", teamName: "Women's Basketball", visibility: .department, body: "Easy bus parking behind the hotel — plan to arrive from the north entrance.", createdAt: "2025-02-16"),
        StaffNote(id: "note_2", placeId: "place_marriott_columbus", authorName: "Sam Delgado", authorRole: "Director of Operations", teamName: "Softball", visibility: .department, body: "They opened breakfast at 6:00 AM specifically for us with advance notice.", createdAt: "2026-03-23"),
        StaffNote(id: "note_3", placeId: "place_marriott_columbus", authorName: "Jamie Ortega", authorRole: "Director of Operations", teamName: "Women's Basketball", visibility: .department, body: "Ask for rooms on floors 3 and 4 — quietest and closest to the elevator bank.", createdAt: "2025-02-16"),
    ]

    private static let hydeParkNotes: [StaffNote] = [
        StaffNote(id: "note_4", placeId: "place_hyde_park_steakhouse", authorName: "Jamie Ortega", authorRole: "Director of Operations", teamName: "Women's Basketball", visibility: .department, body: "Private room upstairs fit our full traveling party with room to spare for film setup.", createdAt: "2025-02-15"),
    ]

    private static let chipotleNotes: [StaffNote] = [
        StaffNote(id: "note_5", placeId: "place_chipotle_lane", authorName: "Priya Shah", authorRole: "Equipment Manager", teamName: "Women's Volleyball", visibility: .team, body: "Call ahead 45 minutes for a 25+ person order — they'll have it bagged and labeled by player.", createdAt: "2025-09-10"),
    ]

    static let summaries: [String: KnowledgeSummary] = [
        "place_marriott_columbus": KnowledgeSummary(
            athleticsRating: 4.9, athleticsReviewCount: 6,
            departmentVisits: DepartmentVisitSummary(placeId: "place_marriott_columbus", visitCount: 4, lastVisitedOn: "2026-03-21", visits: marriottVisits),
            topNotes: marriottNotes,
            networkSignal: NetworkRecommendationSummary(placeId: "place_marriott_columbus", teamsUsedCount: 12, recommendCount: 11, commonNotes: ["Excellent bus parking", "Early breakfast available", "Large meeting room"])
        ),
        "place_hyde_park_steakhouse": KnowledgeSummary(
            athleticsRating: 4.8, athleticsReviewCount: 3,
            departmentVisits: DepartmentVisitSummary(placeId: "place_hyde_park_steakhouse", visitCount: 1, lastVisitedOn: "2025-02-15", visits: [
                TeamVisit(id: "visit_4", placeId: "place_hyde_park_steakhouse", teamName: "Women's Basketball", sport: "basketball", visitedOn: "2025-02-15"),
            ]),
            topNotes: hydeParkNotes
        ),
        "place_chipotle_lane": KnowledgeSummary(
            athleticsRating: 4.6, athleticsReviewCount: 4,
            departmentVisits: DepartmentVisitSummary(placeId: "place_chipotle_lane", visitCount: 2, lastVisitedOn: "2026-03-22", visits: [
                TeamVisit(id: "visit_5", placeId: "place_chipotle_lane", teamName: "Women's Volleyball", sport: "volleyball", visitedOn: "2025-09-10"),
                TeamVisit(id: "visit_6", placeId: "place_chipotle_lane", teamName: "Softball", sport: "softball", visitedOn: "2026-03-22"),
            ]),
            topNotes: chipotleNotes
        ),
        "place_cameron_mitchell_catering": KnowledgeSummary(
            athleticsRating: 4.9, athleticsReviewCount: 2,
            topNotes: [
                StaffNote(id: "note_6", placeId: "place_cameron_mitchell_catering", authorName: "Sam Delgado", authorRole: "Director of Operations", teamName: "Softball", visibility: .department, body: "Boxed postgame meals were ready 15 minutes early and held hot.", createdAt: "2026-03-21"),
            ]
        ),
    ]

    static func forPlace(_ placeId: String) -> KnowledgeSummary? { summaries[placeId] }

    static let athleticsReviews: [String: [AthleticsReview]] = [
        "place_marriott_columbus": [
            AthleticsReview(id: "areview_1", placeId: "place_marriott_columbus", authorName: "Jamie Ortega", authorRole: "Director of Operations", teamName: "Women's Basketball", visibility: .department, overallRating: 4.9, categoryRatings: [
                "Team Friendly": 5, "Bus Access": 5, "Breakfast": 5, "Meeting Space": 4.5, "Location": 4.5, "Staff": 5, "Room Blocks": 5, "Laundry": 4.5, "Value": 4,
            ], body: "Our go-to in Columbus — they treat traveling teams like regulars at this point.", createdAt: "2026-03-23"),
        ],
        "place_hyde_park_steakhouse": [
            AthleticsReview(id: "areview_2", placeId: "place_hyde_park_steakhouse", authorName: "Jamie Ortega", authorRole: "Director of Operations", teamName: "Women's Basketball", visibility: .department, overallRating: 4.8, categoryRatings: [
                "Large Group Friendly": 5, "Speed": 4, "Food Quality": 5, "Bus Access": 4.5, "Private Dining": 5, "Dietary Options": 4.5, "Team Friendly": 5, "Value": 3.5,
            ], body: "Pricier, but worth it for a big pregame or celebration dinner with a private room.", createdAt: "2025-02-16"),
        ],
        "place_chipotle_lane": [
            AthleticsReview(id: "areview_3", placeId: "place_chipotle_lane", authorName: "Priya Shah", authorRole: "Equipment Manager", teamName: "Women's Volleyball", visibility: .team, overallRating: 4.6, categoryRatings: [
                "Large Group Friendly": 4.5, "Speed": 4.5, "Food Quality": 4, "Bus Access": 4, "Private Dining": 2, "Dietary Options": 5, "Team Friendly": 5, "Value": 5,
            ], body: "Reliable fallback for a fast pregame meal — call ahead and it's bagged by the time we arrive.", createdAt: "2025-09-11"),
        ],
    ]

    static func reviews(forPlace placeId: String) -> [AthleticsReview] { athleticsReviews[placeId] ?? [] }
}
