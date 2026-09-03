import SwiftUI

@main
struct SimpleScoutApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(TripStore.shared)
        }
    }
}
