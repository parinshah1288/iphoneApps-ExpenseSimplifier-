import SwiftUI

struct TransactionEditorView: View {
    @EnvironmentObject private var store: ExpenseStore
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var description = ""
    @State private var amount: Decimal = 0
    @State private var categoryId: UUID?

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Description", text: $description)
                    TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                }

                Section("Category") {
                    Picker("Category", selection: $categoryId) {
                        Text("Uncategorized").tag(UUID?.none)
                        ForEach(store.categories) { category in
                            Text(category.name).tag(Optional(category.id))
                        }
                    }
                }
            }
            .navigationTitle("New Transaction")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let transaction = ExpenseTransaction(
                            date: date,
                            description: description,
                            amount: amount,
                            categoryId: categoryId,
                            source: .manual
                        )
                        store.addTransaction(transaction)
                        dismiss()
                    }
                    .disabled(description.isEmpty)
                }
            }
        }
    }
}
