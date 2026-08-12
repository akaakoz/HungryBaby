import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class FridgeSearchViewModel {
    private(set) var allIngredients: [Ingredient] = []
    var selectedIngredientIDs: Set<String> = []
    var searchText: String = ""
    var showIngredientPicker: Bool = false

    struct MatchedRecipe: Identifiable {
        let id: String
        let recipe: Recipe
        let matchCount: Int
        let totalSelected: Int
        var matchScore: Double { totalSelected > 0 ? Double(matchCount) / Double(totalSelected) : 0 }
        var isExactMatch: Bool { matchCount == totalSelected }
    }

    private(set) var matchedRecipes: [MatchedRecipe] = []

    var selectedIngredients: [Ingredient] {
        allIngredients.filter { selectedIngredientIDs.contains($0.ingredientID) }
    }

    var filteredIngredients: [Ingredient] {
        if searchText.isEmpty { return allIngredients }
        return allIngredients.filter { $0.nameJP.localizedStandardContains(searchText) }
    }

    func toggle(ingredient: Ingredient) {
        if selectedIngredientIDs.contains(ingredient.ingredientID) {
            selectedIngredientIDs.remove(ingredient.ingredientID)
        } else {
            selectedIngredientIDs.insert(ingredient.ingredientID)
        }
        updateMatches()
    }

    func isSelected(_ ingredient: Ingredient) -> Bool {
        selectedIngredientIDs.contains(ingredient.ingredientID)
    }

    func load(context: ModelContext) {
        let descriptor = FetchDescriptor<Ingredient>(sortBy: [SortDescriptor(\.nameJP)])
        allIngredients = (try? context.fetch(descriptor)) ?? []
    }

    private func updateMatches() {
        guard !selectedIngredientIDs.isEmpty else {
            matchedRecipes = []
            return
        }
        // レシピの食材と選択食材の一致スコアを計算
        // Note: matchedRecipes updates are driven by selectedIngredientIDs changes
        // The actual recipe matching is done in FridgeResultsView using @Query
    }

    func matchedRecipes(from recipes: [Recipe]) -> [MatchedRecipe] {
        guard !selectedIngredientIDs.isEmpty else { return [] }

        return recipes.compactMap { recipe in
            let recipeIngredientIDs = Set(recipe.recipeIngredients.compactMap { $0.ingredient?.ingredientID })
            let matchCount = selectedIngredientIDs.intersection(recipeIngredientIDs).count
            guard matchCount > 0 else { return nil }
            return MatchedRecipe(
                id: recipe.recipeID,
                recipe: recipe,
                matchCount: matchCount,
                totalSelected: selectedIngredientIDs.count
            )
        }
        .sorted {
            if $0.matchCount != $1.matchCount { return $0.matchCount > $1.matchCount }
            return $0.recipe.cookingTimeMinutes < $1.recipe.cookingTimeMinutes
        }
    }
}
