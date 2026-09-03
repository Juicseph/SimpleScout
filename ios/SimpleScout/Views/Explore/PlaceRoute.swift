import Foundation

/// Navigation value used to push Place Details from anywhere in the app —
/// routing by id (not the whole Place) keeps model changes from needing to
/// stay Hashable end-to-end.
struct PlaceRoute: Hashable {
    let placeId: String
}
