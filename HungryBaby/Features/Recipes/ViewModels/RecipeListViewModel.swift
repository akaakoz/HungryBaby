import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class RecipeListViewModel {
    private(set) var recipes: [Recipe] = []
    var searchText: String = ""
    var selectedStage: BabyStage?
    var selectedDifficulty: Difficulty?
    var selectedCookingTime: CookingTime?

    var filteredRecipes: [Recipe] {
        var result = recipes

        if !searchText.isEmpty {
            result = result.filter { $0.nameJP.localizedStandardContains(searchText) }
        }

        if let stage = selectedStage {
            result = result.filter { $0.isAvailable(for: stage) }
        }

        if let difficulty = selectedDifficulty {
            result = result.filter { $0.difficulty == difficulty.rawValue }
        }

        if let time = selectedCookingTime {
            result = result.filter { $0.cookingTime == time }
        }

        return result.sorted { $0.cookingTimeMinutes < $1.cookingTimeMinutes }
    }

    var hasActiveFilter: Bool {
        selectedStage != nil || selectedDifficulty != nil || selectedCookingTime != nil
    }

    func load(currentStage: BabyStage?, context: ModelContext) {
        selectedStage = currentStage
        let descriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.cookingTimeMinutes)])
        recipes = (try? context.fetch(descriptor)) ?? []
    }

    func clearFilters() {
        selectedDifficulty = nil
        selectedCookingTime = nil
        selectedStage = nil
    }
}
