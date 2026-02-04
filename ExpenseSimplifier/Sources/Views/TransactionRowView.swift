import SwiftUI

struct TransactionRowView: View {
    @EnvironmentObject private var store: ExpenseStore
    let transaction: ExpenseTransaction

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(.headline)
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(currencyString)
                    .font(.headline)
                if let category = category {
                    Text(category.name)
                        .font(.caption)
                        .foregroundStyle(Color(hex: category.colorHex))
                } else {
                    Text("Uncategorized")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var category: ExpenseCategory? {
        store.categories.first { $0.id == transaction.categoryId }
    }

    private var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: transaction.amount as NSDecimalNumber) ?? "$0.00"
    }
}
