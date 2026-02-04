import Foundation

struct LocalStore {
    struct Payload: Codable {
        var categories: [ExpenseCategory]
        var transactions: [ExpenseTransaction]
    }

    private let fileURL: URL

    init(filename: String = "expense-data.json") {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        fileURL = documents[0].appendingPathComponent(filename)
    }

    func load() throws -> Payload {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(Payload.self, from: data)
    }

    func save(_ payload: Payload) throws {
        let data = try JSONEncoder().encode(payload)
        try data.write(to: fileURL, options: [.atomic])
    }
}
