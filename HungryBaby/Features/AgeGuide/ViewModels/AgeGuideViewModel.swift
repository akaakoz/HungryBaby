import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class AgeGuideViewModel {
    private(set) var ingredients: [Ingredient] = []
    var selectedIngredient: Ingredient?
    var searchText: String = ""
    var selectedCategory: IngredientCategory?

    var filteredIngredients: [Ingredient] {
        var result = ingredients

        if !searchText.isEmpty {
            result = result.filter { $0.nameJP.localizedStandardContains(searchText) }
        }

        if let category = selectedCategory {
            result = result.filter { $0.category == category.rawValue }
        }

        return result.sorted { lhs, rhs in
            // NG → 注意 → OK の順（NGが上に来る）
            // ただし表示上は安全なものを上にしたい場合は逆順にする
            let lhsLevel = lhs.safetyLevel(for: currentStage)
            let rhsLevel = rhs.safetyLevel(for: currentStage)
            if lhsLevel != rhsLevel {
                return safetyOrder(lhsLevel) < safetyOrder(rhsLevel)
            }
            return lhs.nameJP < rhs.nameJP
        }
    }

    private var currentStage: BabyStage = .gokun

    func load(stage: BabyStage, context: ModelContext) {
        currentStage = stage
        let descriptor = FetchDescriptor<Ingredient>(sortBy: [SortDescriptor(\.nameJP)])
        ingredients = (try? context.fetch(descriptor)) ?? []
    }

    private func safetyOrder(_ level: SafetyLevel) -> Int {
        switch level {
        case .ok: 0
        case .caution: 1
        case .prohibited: 2
        }
    }
}
