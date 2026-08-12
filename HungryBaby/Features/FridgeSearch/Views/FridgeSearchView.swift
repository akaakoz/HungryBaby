import SwiftUI

struct FridgeSearchView: View {
    @State private var viewModel = FridgeSearchViewModel()
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 選択中の食材チップ
                if !viewModel.selectedIngredients.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.selectedIngredients) { ingredient in
                                IngredientChipView(
                                    ingredient: ingredient,
                                    isSelected: true,
                                    onTap: { viewModel.toggle(ingredient: ingredient) }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                    .background(Color(.systemGroupedBackground))

                    Divider()
                }

                // レシピ結果
                FridgeResultsView(viewModel: viewModel)
            }
            .navigationTitle("冷蔵庫検索")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showIngredientPicker = true
                    } label: {
                        Label("食材を選ぶ", systemImage: "plus.circle.fill")
                    }
                }
                if !viewModel.selectedIngredientIDs.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("クリア") {
                            viewModel.selectedIngredientIDs.removeAll()
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showIngredientPicker) {
                IngredientPickerView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.load(context: context)
            }
        }
    }
}

#Preview {
    FridgeSearchView()
}
