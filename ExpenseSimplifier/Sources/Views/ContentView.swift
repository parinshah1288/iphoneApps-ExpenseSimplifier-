import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: ExpenseStore
    @State private var selectedCategory: ExpenseCategory?
    @State private var showingImporter = false
    @State private var showingCategorySheet = false
    @State private var importWarnings: [String] = []

    var body: some View {
        NavigationSplitView {
            CategoryListView(selectedCategory: $selectedCategory)
                .navigationTitle("Categories")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingCategorySheet = true
                        } label: {
                            Label("Add Category", systemImage: "plus")
                        }
                    }
                }
        } detail: {
            TransactionListView(selectedCategory: $selectedCategory)
                .navigationTitle(selectedCategory?.name ?? "All Transactions")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            showingImporter = true
                        } label: {
                            Label("Import PDF", systemImage: "doc.text")
                        }
                    }
                }
        }
        .fileImporter(
            isPresented: $showingImporter,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result)
        }
        .sheet(isPresented: $showingCategorySheet) {
            CategoryEditorView()
        }
        .alert("Import Warnings", isPresented: .constant(!importWarnings.isEmpty)) {
            Button("OK") {
                importWarnings.removeAll()
            }
        } message: {
            Text(importWarnings.joined(separator: "\n"))
        }
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        do {
            guard let url = try result.get().first else { return }
            let parser = PDFTransactionParser()
            let parsed = try parser.parse(url: url)
            store.importTransactions(parsed.transactions)
            importWarnings = parsed.warnings
        } catch {
            importWarnings = ["Unable to import PDF: \(error.localizedDescription)"]
        }
    }
}
