import Foundation
import SwiftData

@Model
final class Recipe {
    @Attribute(.unique) var recipeID: String
    var nameJP: String
    var descriptionJP: String
    var stages: [String]
    var cookingTimeMinutes: Int
    var difficulty: String
    var kurashiruID: String?
    var steps: [String]
    var tags: [String]
    @Relationship(deleteRule: .cascade) var recipeIngredients: [RecipeIngredient]

    init(
        recipeID: String,
        nameJP: String,
        descriptionJP: String,
        stages: [String],
        cookingTimeMinutes: Int,
        difficulty: String,
        kurashiruID: String? = nil,
        steps: [String],
        tags: [String]
    ) {
        self.recipeID = recipeID
        self.nameJP = nameJP
        self.descriptionJP = descriptionJP
        self.stages = stages
        self.cookingTimeMinutes = cookingTimeMinutes
        self.difficulty = difficulty
        self.kurashiruID = kurashiruID
        self.steps = steps
        self.tags = tags
        self.recipeIngredients = []
    }

    var babyStages: [BabyStage] {
        stages.compactMap { BabyStage(rawValue: $0) }
    }

    var difficultyLevel: Difficulty {
        Difficulty(rawValue: difficulty) ?? .easy
    }

    var cookingTime: CookingTime {
        CookingTime.from(minutes: cookingTimeMinutes)
    }

    func isAvailable(for stage: BabyStage) -> Bool {
        stages.contains(stage.rawValue)
    }
}
