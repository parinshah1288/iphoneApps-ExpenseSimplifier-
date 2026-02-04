import Foundation
import PDFKit

struct PDFTransactionParser {
    struct ParsedResult {
        var transactions: [ExpenseTransaction]
        var warnings: [String]
    }

    func parse(url: URL) throws -> ParsedResult {
        guard let document = PDFDocument(url: url) else {
            throw ParserError.invalidPDF
        }

        let fullText = (0..<document.pageCount)
            .compactMap { document.page(at: $0)?.string }
            .joined(separator: "\n")

        return parse(text: fullText)
    }

    func parse(text: String) -> ParsedResult {
        var transactions: [ExpenseTransaction] = []
        var warnings: [String] = []

        let lines = text
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"

        for line in lines {
            if let transaction = parseLine(line, dateFormatter: dateFormatter) {
                transactions.append(transaction)
            }
        }

        if transactions.isEmpty {
            warnings.append("No transactions matched the expected format. Consider adjusting the parser to your bank statement layout.")
        }

        return ParsedResult(transactions: transactions, warnings: warnings)
    }

    private func parseLine(_ line: String, dateFormatter: DateFormatter) -> ExpenseTransaction? {
        let components = line.split(separator: " ")
        guard components.count >= 3 else { return nil }

        guard let date = dateFormatter.date(from: String(components[0])) else { return nil }

        let amountString = components.last.map(String.init) ?? ""
        let description = components.dropFirst().dropLast().joined(separator: " ")

        guard let amount = Decimal(string: amountString.replacingOccurrences(of: ",", with: "")) else { return nil }

        return ExpenseTransaction(date: date, description: description, amount: amount, source: .pdfImport)
    }

    enum ParserError: Error {
        case invalidPDF
    }
}
