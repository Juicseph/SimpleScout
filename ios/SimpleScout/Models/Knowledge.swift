import Foundation

enum VisibilityLevel: String, Codable, Equatable, Hashable {
    case personal, team, department, network

    var label: String { rawValue.capitalized }
}

struct AthleticsReview: Identifiable, Codable, Equatable {
    let id: String
    let placeId: String
    let authorName: String
    let authorRole: String
    let teamName: String
    var visibility: VisibilityLevel
    let overallRating: Double
    let categoryRatings: [String: Double]
    var body: String? = nil
    let createdAt: String
}

struct StaffNote: Identifiable, Codable, Equatable {
    let id: String
    let placeId: String
    let authorName: String
    let authorRole: String
    var teamName: String? = nil
    var visibility: VisibilityLevel
    let body: String
    let createdAt: String
}

struct TeamVisit: Identifiable, Codable, Equatable {
    let id: String
    let placeId: String
    let teamName: String
    let sport: String
    let visitedOn: String // yyyy-MM-dd
}

struct DepartmentVisitSummary: Codable, Equatable {
    let placeId: String
    let visitCount: Int
    var lastVisitedOn: String? = nil
    let visits: [TeamVisit]
}

struct NetworkRecommendationSummary: Codable, Equatable {
    let placeId: String
    let teamsUsedCount: Int
    let recommendCount: Int
    let commonNotes: [String]
}

/// Composed, read-time aggregation — see docs/ARCHITECTURE.md §8.
struct KnowledgeSummary: Codable, Equatable {
    var athleticsRating: Double? = nil
    var athleticsReviewCount: Int = 0
    var departmentVisits: DepartmentVisitSummary? = nil
    var topNotes: [StaffNote] = []
    var networkSignal: NetworkRecommendationSummary? = nil
}
