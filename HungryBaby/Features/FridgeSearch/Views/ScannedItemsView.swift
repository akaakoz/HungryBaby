import SwiftUI

struct ScannedItemsView: View {
    @Bindable var viewModel: FridgeSearchViewModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("レシートから読み取った食材です。追加するものを選んでください。")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }

                Section("読み取り結果") {
                    ForEach(viewModel.scannedItems) { item in
                        HStack {
                            Button {
                                viewModel.toggleScannedItem(id: item.id)
                            } label: {
                                Image(systemName: item.isSelected ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(item.isSelected ? Color.appPrimary : .secondary)
                            }
                            .buttonStyle(.plain)

                            TextField("食材名", text: viewModel.bindingForScannedItemName(id: item.id))

                            Button {
                                viewModel.removeScannedItem(id: item.id)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("食材を確認")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("追加") {
                        viewModel.addSelectedScannedItems(context: context)
                        dismiss()
                    }
                    .disabled(viewModel.scannedItems.allSatisfy { !$0.isSelected })
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        viewModel.scannedItems = []
                        dismiss()
                    }
                }
            }
        }
    }
}
