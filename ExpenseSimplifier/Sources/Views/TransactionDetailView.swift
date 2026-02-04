import SwiftUI

struct TransactionDetailView: View {
    @EnvironmentObject private var store: ExpenseStore
    @State private var transaction: ExpenseTransaction

    init(transaction: ExpenseTransaction) {
        _transaction = State(initialValue: transaction)
    }

    var body: some View {
        Form {
            Section("Details") {
                DatePicker("Date", selection: $transaction.date, displayedComponents: .date)
                TextField("Description", text: $transaction.description)
                TextField("Amount", value: $transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }

            Section("Category") {
                Picker("Category", selection: $transaction.categoryId) {
                    Text("Uncategorized").tag(UUID?.none)
                    ForEach(store.categories) { category in
                        Text(category.name).tag(Optional(category.id))
                    }
                }
            }

            Section("Source") {
                Text(transaction.source == .manual ? "Manual" : "PDF Import")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    store.updateTransaction(transaction)
                }
            }
        }
    }
}
