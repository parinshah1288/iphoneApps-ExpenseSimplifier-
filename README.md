# Expense Simplifier (iPhone + iPad)

Expense Simplifier is an offline-first iOS/iPadOS app concept for tracking monthly expenses, importing PDF bank statements, and categorizing transactions with a clean, modern SwiftUI experience.

## Highlights
- **Offline-only**: All data is stored locally in the device documents directory.
- **PDF import**: Basic parser to extract transactions from bank statement text.
- **Category management**: Create, edit, and assign categories to transactions.
- **Universal UI**: NavigationSplitView layout that adapts to iPhone and iPad.

## Next Steps
- Tune `PDFTransactionParser` to match your bank’s statement format.
- Add richer categorization rules and recurring expenses.
- Add charts for monthly summaries.

## Build
Open the folder in Xcode, create a new iOS App target, and add the `ExpenseSimplifier/Sources` files to the target.
