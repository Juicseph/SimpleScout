import SwiftUI

struct PhotoTileView: View {
    let theme: PhotoTheme
    var height: CGFloat = 140
    var cornerRadius: CGFloat = 0

    private var gradient: LinearGradient {
        let colors: [Color]
        switch theme {
        case .hotelLobby: colors = [Theme.brand, Color(hex: "#c0392b")]
        case .hotelExterior: colors = [Theme.ink, Theme.brand]
        case .restaurantInterior: colors = [Color(hex: "#b45309"), Color(hex: "#fbbf24")]
        case .quickService: colors = [Color(hex: "#ea580c"), Color(hex: "#facc15")]
        case .catering: colors = [Color(hex: "#be123c"), Color(hex: "#fb923c")]
        case .sportingGoods: colors = [Color(hex: "#047857"), Color(hex: "#2dd4bf")]
        case .electronics: colors = [Color(hex: "#1e293b"), Color(hex: "#64748b")]
        case .pharmacy: colors = [Color(hex: "#0369a1"), Color(hex: "#22d3ee")]
        case .grocery: colors = [Color(hex: "#4d7c0f"), Color(hex: "#4ade80")]
        case .medical: colors = [Color(hex: "#b91c1c"), Color(hex: "#fb7185")]
        case .venue: colors = [Color(hex: "#3730a3"), Color(hex: "#8b5cf6")]
        }
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private var symbolName: String {
        switch theme {
        case .hotelLobby, .hotelExterior: return "building.2.fill"
        case .restaurantInterior: return "fork.knife"
        case .quickService: return "takeoutbag.and.cup.and.straw.fill"
        case .catering: return "flame.fill"
        case .sportingGoods: return "dumbbell.fill"
        case .electronics: return "tv.fill"
        case .pharmacy: return "cross.case.fill"
        case .grocery: return "basket.fill"
        case .medical: return "stethoscope"
        case .venue: return "building.columns.fill"
        }
    }

    var body: some View {
        gradient
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .overlay(Image(systemName: symbolName).font(.system(size: 30)).foregroundStyle(.white.opacity(0.85)))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
