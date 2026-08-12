import Foundation
import SwiftData

@Model
final class Ingredient {
    @Attribute(.unique) var ingredientID: String
    var nameJP: String
    var nameEN: String
    var category: String
    var allergen: Bool
    var notes: String?
    @Relationship(deleteRule: .cascade) var safetyInfo: [IngredientSafety]

    init(
        ingredientID: String,
        nameJP: String,
        nameEN: String,
        category: String,
        allergen: Bool,
        notes: String? = nil
    ) {
        self.ingredientID = ingredientID
        self.nameJP = nameJP
        self.nameEN = nameEN
        self.category = category
        self.allergen = allergen
        self.notes = notes
        self.safetyInfo = []
    }

    var ingredientCategory: IngredientCategory {
        IngredientCategory(rawValue: category) ?? .other
    }

    func safety(for stage: BabyStage) -> IngredientSafety? {
        safetyInfo.first { $0.stage == stage.rawValue }
    }

    func safetyLevel(for stage: BabyStage) -> SafetyLevel {
        guard let info = safety(for: stage),
              let level = SafetyLevel(rawValue: info.level) else {
            return .ok
        }
        return level
    }
}
