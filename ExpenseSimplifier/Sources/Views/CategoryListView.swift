import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject private var store: ExpenseStore
    @Binding var selectedCategory: ExpenseCategory?

    var body: some View {
        List(selection: $selectedCategory) {
            Section {
                Label("All Transactions", systemImage: "tray.full")
                    .tag(ExpenseCategory?.none)
            }

            Section("My Categories") {
                ForEach(store.categories) { category in
                    Label(category.name, systemImage: "circle.fill")
                        .foregroundStyle(Color(hex: category.colorHex))
                        .tag(Optional(category))
                }
                .onDelete { indices in
                    indices.map { store.categories[$0] }.forEach(store.deleteCategory)
                }
            }
        }
        .listStyle(.sidebar)
    }
}
