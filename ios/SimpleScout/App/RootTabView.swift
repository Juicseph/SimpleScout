import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var store: TripStore

    private var travelModeActive: Bool {
        store.hasSearched && Trip.isTravelModeActive(startDate: store.context.startDate, endDate: store.context.endDate)
    }

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("Explore", systemImage: "safari") }

            NavigationStack {
                TripBoardView(trip: DemoTrip.trip)
            }
            .tabItem { Label(travelModeActive ? "Travel Mode" : "Trips", systemImage: "map") }

            PlaceholderView(title: "Saved", systemImage: "heart", message: "Places your staff save will collect here.")
                .tabItem { Label("Saved", systemImage: "heart") }

            PlaceholderView(title: "Network", systemImage: "person.3", message: "Ask Another Team and the Athletics Network arrive in a later phase.")
                .tabItem { Label("Network", systemImage: "person.3") }

            PlaceholderView(title: "Profile", systemImage: "person.crop.circle", message: "Account and role settings.")
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .tint(Theme.brand)
    }
}

struct PlaceholderView: View {
    let title: String
    let systemImage: String
    let message: String

    var body: some View {
        NavigationStack {
            ContentUnavailableView(title, systemImage: systemImage, description: Text(message))
                .navigationTitle(title)
        }
    }
}
