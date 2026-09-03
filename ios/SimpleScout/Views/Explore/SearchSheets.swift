import SwiftUI

struct DestinationPickerSheet: View {
    @Binding var selectedId: String
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    var body: some View {
        NavigationStack {
            List(DemoUniversities.search(query)) { university in
                Button {
                    selectedId = university.id
                    dismiss()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(university.name).foregroundStyle(.primary)
                            Text("\(university.city), \(university.state)").font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        if university.id == selectedId {
                            Image(systemName: "checkmark").foregroundStyle(Theme.brand)
                        }
                    }
                }
            }
            .searchable(text: $query, prompt: "Search universities")
            .navigationTitle("Where are you going?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }
}

struct StartingFromPickerSheet: View {
    @Binding var selectedId: String?
    let excluding: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(DemoUniversities.all.filter { $0.id != excluding }) { university in
                Button {
                    selectedId = university.id
                    dismiss()
                } label: {
                    HStack {
                        Text(university.name).foregroundStyle(.primary)
                        Spacer()
                        if university.id == selectedId {
                            Image(systemName: "checkmark").foregroundStyle(Theme.brand)
                        }
                    }
                }
            }
            .navigationTitle("Starting From")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }
}

struct DatesPickerSheet: View {
    @Binding var startDate: String
    @Binding var endDate: String
    @Environment(\.dismiss) private var dismiss

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    @State private var start: Date = Date()
    @State private var end: Date = Date()

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Depart", selection: $start, displayedComponents: .date)
                DatePicker("Return", selection: $end, in: start..., displayedComponents: .date)
            }
            .navigationTitle("When?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        startDate = Self.formatter.string(from: start)
                        endDate = Self.formatter.string(from: end)
                        dismiss()
                    }
                }
            }
            .onAppear {
                start = Self.formatter.date(from: startDate) ?? Date()
                end = Self.formatter.date(from: endDate) ?? Date()
            }
        }
    }
}

struct WhoTravelingSheet: View {
    @Binding var party: TravelParty
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Stepper("Athletes: \(party.athletes)", value: $party.athletes, in: 0...100)
                Stepper("Coaches: \(party.coaches)", value: $party.coaches, in: 0...20)
                Stepper("Staff: \(party.staff)", value: $party.staff, in: 0...20)
                HStack {
                    Text("Total Travel Party").fontWeight(.semibold)
                    Spacer()
                    Text("\(party.total)").font(.title3).fontWeight(.bold)
                }
            }
            .navigationTitle("Who's Traveling?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }
}

struct SportPickerSheet: View {
    @Binding var selectedSport: Sport
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Sport.allCases) { sport in
                        Button {
                            selectedSport = sport
                            dismiss()
                        } label: {
                            Text(sport.label)
                                .font(.system(size: 14, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(sport == selectedSport ? Theme.brand.opacity(0.12) : Color(.systemGray6)))
                                .foregroundStyle(sport == selectedSport ? Theme.brand : .primary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Sport")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }
}
