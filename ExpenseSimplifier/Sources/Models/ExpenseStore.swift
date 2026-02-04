import Foundation

@MainActor
final class ExpenseStore: ObservableObject {
    @Published private(set) var categories: [ExpenseCategory] = []
    @Published private(set) var transactions: [ExpenseTransaction] = []

    private let persistence = LocalStore()

    init() {
        load()
    }

    func load() {
        do {
            let payload = try persistence.load()
            categories = payload.categories
            transactions = payload.transactions
        } catch {
            categories = [
                ExpenseCategory(name: "Groceries", colorHex: "#4CAF50"),
                ExpenseCategory(name: "Transport", colorHex: "#03A9F4"),
                ExpenseCategory(name: "Utilities", colorHex: "#FF9800"),
                ExpenseCategory(name: "Subscriptions", colorHex: "#9C27B0")
            ]
            transactions = []
        }
    }

    func addCategory(name: String, colorHex: String) {
        categories.append(ExpenseCategory(name: name, colorHex: colorHex))
        save()
    }

    func updateCategory(_ category: ExpenseCategory) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            save()
        }
    }

    func deleteCategory(_ category: ExpenseCategory) {
        categories.removeAll { $0.id == category.id }
        transactions = transactions.map { transaction in
            var updated = transaction
            if updated.categoryId == category.id {
                updated.categoryId = nil
            }
            return updated
        }
        save()
    }

    func addTransaction(_ transaction: ExpenseTransaction) {
        transactions.append(transaction)
        sortTransactions()
        save()
    }

    func updateTransaction(_ transaction: ExpenseTransaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
            sortTransactions()
            save()
        }
    }

    func deleteTransaction(_ transaction: ExpenseTransaction) {
        transactions.removeAll { $0.id == transaction.id }
        save()
    }

    func assignCategory(_ category: ExpenseCategory?, to transaction: ExpenseTransaction) {
        var updated = transaction
        updated.categoryId = category?.id
        updateTransaction(updated)
    }

    func importTransactions(_ imported: [ExpenseTransaction]) {
        transactions.append(contentsOf: imported)
        sortTransactions()
        save()
    }

    private func sortTransactions() {
        transactions.sort { $0.date > $1.date }
    }

    private func save() {
        let payload = LocalStore.Payload(categories: categories, transactions: transactions)
        do {
            try persistence.save(payload)
        } catch {
            // In a production app, surface a user-facing error state.
        }
    }
}
