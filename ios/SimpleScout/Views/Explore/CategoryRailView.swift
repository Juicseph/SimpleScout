import SwiftUI

struct CategoryRailView: View {
    @Binding var selected: ExploreCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(ExploreCategory.allCases) { category in
                    Button {
                        selected = category
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: category.systemImage)
                                .font(.system(size: 18, weight: selected == category ? .semibold : .regular))
                            Text(category.label).font(.system(size: 11, weight: .medium))
                        }
                        .foregroundStyle(selected == category ? .primary : .secondary)
                        .overlay(alignment: .bottom) {
                            if selected == category {
                                Rectangle().fill(Theme.ink).frame(height: 2).offset(y: 10)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16).padding(.bottom, 10)
        }
    }
}

struct NeedSomethingNowView: View {
    var onSelect: (ExploreCategory) -> Void

    private let items: [(String, String, ExploreCategory?)] = [
        ("Food", "takeoutbag.and.cup.and.straw.fill", .quickMeals),
        ("Pharmacy", "cross.case.fill", .pharmacy),
        ("Equipment", "dumbbell.fill", .equipment),
        ("Tech", "tv.fill", .tech),
        ("Groceries", "basket.fill", .groceries),
        ("Medical", "stethoscope", .medical),
        ("Printing", "printer.fill", nil),
        ("Transportation", "bus.fill", .transportation),
        ("Other", "ellipsis", nil),
    ]

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Need Something Now?").font(.system(size: 17, weight: .bold))
                Spacer()
                Text("Open now · closest first").font(.system(size: 11)).foregroundStyle(.white.opacity(0.6))
            }
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items, id: \.0) { item in
                    Button {
                        if let category = item.2 { onSelect(category) }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: item.1).font(.system(size: 18))
                            Text(item.0).font(.system(size: 11, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 14).fill(.white.opacity(0.1)))
                        .foregroundStyle(.white)
                        .opacity(item.2 == nil ? 0.6 : 1)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(Theme.ink))
    }
}
