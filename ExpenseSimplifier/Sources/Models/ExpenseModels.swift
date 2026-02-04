import Foundation

struct ExpenseCategory: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var colorHex: String

    init(id: UUID = UUID(), name: String, colorHex: String) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
    }
}

struct ExpenseTransaction: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var description: String
    var amount: Decimal
    var categoryId: UUID?
    var source: TransactionSource

    init(
        id: UUID = UUID(),
        date: Date,
        description: String,
        amount: Decimal,
        categoryId: UUID? = nil,
        source: TransactionSource = .manual
    ) {
        self.id = id
        self.date = date
        self.description = description
        self.amount = amount
        self.categoryId = categoryId
        self.source = source
    }
}

enum TransactionSource: String, Codable, Hashable {
    case manual
    case pdfImport
}
