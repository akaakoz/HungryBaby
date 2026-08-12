import SwiftUI
import SwiftData

struct IngredientSafetyListView: View {
    let stage: BabyStage
    @State private var viewModel = AgeGuideViewModel()
    @Environment(\.modelContext) private var context

    var body: some View {
        List {
            ForEach(IngredientCategory.allCases, id: \.rawValue) { category in
                ingredientSection(for: category)
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "食材を検索")
        .onAppear {
            viewModel.load(stage: stage, context: context)
        }
    }

    @ViewBuilder
    private func ingredientSection(for category: IngredientCategory) -> some View {
        let items = viewModel.filteredIngredients.filter { $0.category == category.rawValue }
        if !items.isEmpty {
            Section(category.displayName) {
                ForEach(items) { ingredient in
                    NavigationLink {
                        IngredientDetailView(ingredient: ingredient)
                    } label: {
                        IngredientSafetyRowView(ingredient: ingredient, stage: stage)
                    }
                }
            }
        }
    }
}
