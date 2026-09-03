import Foundation

enum TeamRole: String, Codable, CaseIterable, Equatable, Hashable {
    case directorOfOps = "director_of_ops"
    case headCoach = "head_coach"
    case assistantCoach = "assistant_coach"
    case athleticTrainer = "athletic_trainer"
    case equipmentManager = "equipment_manager"
    case sportsInformation = "sports_information"
    case admin
}

enum Sport: String, Codable, CaseIterable, Identifiable, Equatable, Hashable {
    case volleyball, basketball, football, soccer, baseball, softball
    case trackAndField = "track_and_field"
    case swimming, tennis, golf, wrestling, other

    var id: String { rawValue }

    var label: String {
        switch self {
        case .trackAndField: return "Track & Field"
        default: return rawValue.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }
}

struct AppUser: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    var avatarUrl: String?
}

struct Team: Identifiable, Codable {
    let id: String
    let athleticDepartmentId: String
    let name: String
    let sport: Sport
}

struct AthleticDepartment: Identifiable, Codable {
    let id: String
    let universityId: String
    let name: String
    let networkParticipation: Bool
}
