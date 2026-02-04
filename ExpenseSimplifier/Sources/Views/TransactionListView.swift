import SwiftUI

struct TransactionListView: View {
    @EnvironmentObject private var store: ExpenseStore
    @Binding var selectedCategory: ExpenseCategory?
    @State private var showingNewTransaction = false

    var body: some View {
        List {
            Section {
                ForEach(filteredTransactions) { transaction in
                    NavigationLink {
                        TransactionDetailView(transaction: transaction)
                    } label: {
                        TransactionRowView(transaction: transaction)
                    }
                }
                .onDelete { indices in
                    indices.map { filteredTransactions[$0] }.forEach(store.deleteTransaction)
                }
            }
        }
        .overlay(alignment: .center) {
            if filteredTransactions.isEmpty {
                ContentUnavailableView(
                    "No transactions",
                    systemImage: "tray",
                    description: Text("Import a PDF or add a manual expense to get started.")
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingNewTransaction = true
                } label: {
                    Label("Add Transaction", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewTransaction) {
            TransactionEditorView()
        }
    }

    private var filteredTransactions: [ExpenseTransaction] {
        guard let selectedCategory else {
            return store.transactions
        }
        return store.transactions.filter { $0.categoryId == selectedCategory.id }
    }
}
