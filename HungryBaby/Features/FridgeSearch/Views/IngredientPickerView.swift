import SwiftUI

struct IngredientPickerView: View {
    @Bindable var viewModel: FridgeSearchViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(IngredientCategory.allCases) { category in
                    let items = viewModel.filteredIngredients.filter { $0.category == category.rawValue }
                    if !items.isEmpty {
                        Section(category.displayName) {
                            ForEach(items) { ingredient in
                                HStack {
                                    Text(ingredient.nameJP)
                                    if ingredient.allergen {
                                        Text("アレルゲン")
                                            .font(.caption2)
                                            .foregroundStyle(.orange)
                                    }
                                    Spacer()
                                    if viewModel.isSelected(ingredient) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.orange)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.toggle(ingredient: ingredient)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "食材を検索")
            .navigationTitle("食材を選ぶ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完了") { dismiss() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("クリア") {
                        viewModel.selectedIngredientIDs.removeAll()
                    }
                }
            }
        }
    }
}
