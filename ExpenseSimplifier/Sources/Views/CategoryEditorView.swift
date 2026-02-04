import SwiftUI

struct CategoryEditorView: View {
    @EnvironmentObject private var store: ExpenseStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var colorHex = "#4CAF50"

    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    TextField("Name", text: $name)
                    TextField("Color Hex", text: $colorHex)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                    HStack {
                        Text("Preview")
                        Spacer()
                        Circle()
                            .fill(Color(hex: colorHex))
                            .frame(width: 24, height: 24)
                    }
                }

                Section("Suggestions") {
                    ForEach(["#4CAF50", "#03A9F4", "#FF9800", "#9C27B0", "#607D8B"], id: \.self) { hex in
                        Button {
                            colorHex = hex
                        } label: {
                            HStack {
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 16, height: 16)
                                Text(hex)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Category")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        store.addCategory(name: name, colorHex: colorHex)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
