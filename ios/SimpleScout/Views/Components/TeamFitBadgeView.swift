import SwiftUI

struct TeamFitBadgeView: View {
    let score: Int
    var compact: Bool = false

    private var tone: Color {
        if score >= 85 { return .green }
        if score >= 65 { return .orange }
        return .red
    }

    var body: some View {
        VStack(spacing: 2) {
            Text("\(score)")
                .font(.system(size: compact ? 13 : 15, weight: .bold))
                .foregroundStyle(tone)
                .frame(width: compact ? 34 : 44, height: compact ? 34 : 44)
                .background(Circle().fill(.white))
                .overlay(Circle().stroke(tone, lineWidth: 2.5))
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
            if !compact {
                Text("TEAM FIT")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct PlaceBadgesView: View {
    let tags: [String]
    var max: Int = 3

    private static let labels: [String: String] = [
        "team_friendly": "Team Friendly",
        "bus_parking": "Bus Parking",
        "staff_favorite": "Staff Favorite",
        "department_recommended": "Dept. Recommended",
        "fast_team_meal": "Fast Team Meal",
        "catering": "Catering",
        "open_late": "Open Late",
        "open_now": "Open Now",
        "used_before": "Used Before",
        "private_dining": "Private Dining",
        "large_group_friendly": "Large Group Friendly",
        "value": "Great Value",
        "fits_your_party": "Fits Your Party",
    ]

    var body: some View {
        let visible = Array(tags.prefix(max)).compactMap { Self.labels[$0] }
        if !visible.isEmpty {
            HStack(spacing: 6) {
                ForEach(visible, id: \.self) { label in
                    Text(label)
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(Color(.systemGray6)))
                }
            }
        }
    }
}

struct KnowledgeStripView: View {
    let knowledge: KnowledgeSummary?

    var body: some View {
        if let knowledge {
            VStack(alignment: .leading, spacing: 4) {
                if let visits = knowledge.departmentVisits, visits.visitCount > 0 {
                    Label {
                        Text("Your department has used this \(visits.visitCount)x — \(Set(visits.visits.map(\.teamName)).joined(separator: ", "))")
                    } icon: {
                        Image(systemName: "person.2.fill")
                    }
                    .font(.system(size: 12, weight: .medium))
                }
                if let network = knowledge.networkSignal {
                    Label("\(network.teamsUsedCount) verified teams used this · \(network.recommendCount) recommend it", systemImage: "checkmark.seal.fill")
                        .font(.system(size: 12, weight: .medium))
                }
                if let note = knowledge.topNotes.first {
                    Label("\u{201C}\(note.body)\u{201D}", systemImage: "quote.bubble.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .italic()
                }
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
        }
    }
}
