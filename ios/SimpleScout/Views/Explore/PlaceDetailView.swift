import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let placeId: String
    @EnvironmentObject private var store: TripStore
    @State private var saved = false

    private var place: Place? { DemoPlaces.byId(placeId) }
    private var knowledge: KnowledgeSummary? { DemoKnowledge.forPlace(placeId) }

    private var anchor: LatLng { DemoUniversities.ohioState.location }

    private var fit: TeamFitResult? {
        guard let place else { return nil }
        return computeTeamFitScore(place: place, partySize: store.context.travelParty.total, anchor: anchor, knowledge: knowledge)
    }

    var body: some View {
        Group {
            if let place, let fit {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        header(place: place, fit: fit)
                        factsCard(place: place)
                        athleticsHistoryCard
                        reviewsCard(place: place)
                        mapCard(place: place)
                        contactCard(place: place)
                        notesCard
                    }
                    .padding(16)
                }
                .background(Theme.sand)
                .navigationTitle(place.name)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView("Place not found", systemImage: "questionmark.folder")
            }
        }
    }

    // MARK: - Header

    private func header(place: Place, fit: TeamFitResult) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            PhotoTileView(theme: place.external.photoTheme, height: 200, cornerRadius: 20)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name).font(.system(size: 22, weight: .bold))
                    Text(place.address).font(.system(size: 13)).foregroundStyle(.secondary)
                }
                Spacer()
                TeamFitBadgeView(score: fit.score)
            }

            HStack(spacing: 14) {
                Label(place.external.publicRating.map { String(format: "%.1f public", $0) } ?? "— public", systemImage: "star.fill")
                if let rating = knowledge?.athleticsRating {
                    Text("Athletics \(String(format: "%.1f", rating))")
                        .font(.system(size: 11, weight: .semibold))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(Theme.brand.opacity(0.12)))
                        .foregroundStyle(Theme.brand)
                }
            }
            .font(.system(size: 13))

            Text(fit.headline).font(.system(size: 13)).foregroundStyle(.secondary)

            HStack(spacing: 10) {
                actionButton(saved ? "Saved" : "Save", icon: saved ? "heart.fill" : "heart") { saved.toggle() }
                actionButton("Share", icon: "square.and.arrow.up") {}
                actionButton("Recommend", icon: "hand.thumbsup") {}
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20).fill(.background))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.systemGray5)))
    }

    private func actionButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 12).padding(.vertical, 8)
                .overlay(Capsule().stroke(Color(.systemGray4)))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Facts

    private func factsCard(place: Place) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview").font(.system(size: 16, weight: .bold))
            fact("Category", place.category.rawValue.capitalized)
            if let hours = place.external.hoursToday { fact("Hours today", hoursLabel(hours)) }
            if let hotel = place.hotel { fact("Rooms", hotel.totalRooms.map(String.init) ?? "—") }
            if let restaurant = place.restaurant { fact("Cuisine", restaurant.cuisine) }
            if place.athletics.busParking != nil { fact("Bus parking", place.athletics.busParking == true ? "Yes" : "No") }
            if let max = place.athletics.maxRecommendedGroup { fact("Max recommended group", "\(max)") }
            if !place.athletics.dietaryOptions.isEmpty { fact("Dietary options", place.athletics.dietaryOptions.joined(separator: ", ")) }
        }
        .cardStyle()
    }

    private func hoursLabel(_ hours: Hours) -> String {
        switch hours {
        case .open24h: return "Open 24 hours"
        case .closed: return "Closed"
        case .ranged(let opens, let closes): return "\(opens) – \(closes)"
        }
    }

    private func fact(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 13)).foregroundStyle(.secondary)
            Spacer()
            Text(value).font(.system(size: 13, weight: .medium))
        }
    }

    // MARK: - Athletics history

    private var athleticsHistoryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Athletics History").font(.system(size: 16, weight: .bold))
            if let visits = knowledge?.departmentVisits, visits.visitCount > 0 {
                Label("Your department has stayed here \(visits.visitCount)x", systemImage: "person.2.fill")
                    .font(.system(size: 14, weight: .semibold))
                ForEach(visits.visits) { visit in
                    Text("\(visit.teamName) · \(visit.visitedOn)").font(.system(size: 12)).foregroundStyle(.secondary)
                }
            }
            if let network = knowledge?.networkSignal {
                Label("\(network.teamsUsedCount) verified teams used this · \(network.recommendCount) recommend it", systemImage: "checkmark.seal.fill")
                    .font(.system(size: 14, weight: .semibold))
                ForEach(network.commonNotes, id: \.self) { note in
                    Text("• \(note)").font(.system(size: 12)).foregroundStyle(.secondary)
                }
            }
            if knowledge?.departmentVisits == nil && knowledge?.networkSignal == nil {
                Text("No department history yet — once your team travels here, visits will show up for every future trip.")
                    .font(.system(size: 12)).foregroundStyle(.secondary)
            }
        }
        .cardStyle()
    }

    // MARK: - Reviews

    private func reviewsCard(place: Place) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Reviews").font(.system(size: 16, weight: .bold))
            HStack {
                Image(systemName: "star.fill").foregroundStyle(.yellow)
                Text(place.external.publicRating.map { String(format: "%.1f", $0) } ?? "—").fontWeight(.semibold)
                Text("public · \(place.external.publicRatingCount ?? 0) reviews").font(.system(size: 12)).foregroundStyle(.secondary)
            }
            let reviews = DemoKnowledge.reviews(forPlace: place.id)
            if reviews.isEmpty {
                Text("No athletics reviews yet.").font(.system(size: 12)).foregroundStyle(.secondary)
            } else {
                ForEach(reviews) { review in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(review.authorName).font(.system(size: 13, weight: .semibold))
                                Text("\(review.authorRole) · \(review.teamName)").font(.system(size: 11)).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Label(String(format: "%.1f", review.overallRating), systemImage: "star.fill")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        if let body = review.body {
                            Text("\u{201C}\(body)\u{201D}").font(.system(size: 12)).italic().foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 6)
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Map

    private func mapCard(place: Place) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Map").font(.system(size: 16, weight: .bold))
            Map(initialPosition: .region(MKCoordinateRegion(center: place.location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))) {
                Marker(place.name, coordinate: place.location.coordinate)
                    .tint(Theme.brand)
            }
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .cardStyle()
    }

    // MARK: - Contact

    private func contactCard(place: Place) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Contact").font(.system(size: 16, weight: .bold))
            if let phone = place.external.phone {
                Label(phone, systemImage: "phone.fill").font(.system(size: 13))
            }
            if let website = place.external.website {
                Label(website.replacingOccurrences(of: "https://", with: ""), systemImage: "globe").font(.system(size: 13))
            }
            if let contact = place.athletics.groupSalesContact {
                VStack(alignment: .leading, spacing: 2) {
                    Text("GROUP SALES CONTACT").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                    Text(contact.name).font(.system(size: 13, weight: .medium))
                    Text(contact.role).font(.system(size: 12)).foregroundStyle(.secondary)
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            }
        }
        .cardStyle()
    }

    // MARK: - Notes

    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Notes").font(.system(size: 16, weight: .bold))
            if let notes = knowledge?.topNotes, !notes.isEmpty {
                ForEach(notes) { note in
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\u{201C}\(note.body)\u{201D}").font(.system(size: 13))
                        Text("\(note.authorName) · \(note.authorRole) · \(note.visibility.label)")
                            .font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 4)
                }
            } else {
                Text("No staff notes yet.").font(.system(size: 12)).foregroundStyle(.secondary)
            }
        }
        .cardStyle()
    }
}

private extension View {
    func cardStyle() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 20).fill(.background))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.systemGray5)))
    }
}
