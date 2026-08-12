import Foundation
import SwiftData

// MARK: - JSON Decodable DTOs (used only for seeding)

private struct IngredientDTO: Decodable {
    let id: String
    let nameJP: String
    let nameEN: String
    let category: String
    let allergen: Bool
    let notes: String?
    let safety: [String: SafetyDTO]

    struct SafetyDTO: Decodable {
        let level: String
        let prohibitionReason: String?
        let sizeGuidance: String?
    }
}

private struct RecipeDTO: Decodable {
    let id: String
    let nameJP: String
    let descriptionJP: String
    let stages: [String]
    let cookingTimeMinutes: Int
    let difficulty: String
    let kurashiruID: String?
    let steps: [String]
    let tags: [String]
    let ingredients: [RecipeIngredientDTO]

    struct RecipeIngredientDTO: Decodable {
        let ingredientID: String
        let quantity: String
        let stageNotes: String?
    }
}

// MARK: - SeedDataService

enum SeedDataService {
    private static let seededKey = "hungryBaby.seedDataVersion"
    private static let currentVersion = 1

    /// 初回起動時（またはバージョンアップ時）にJSONデータをSwiftDataへ投入する
    @MainActor
    static func seedIfNeeded(in container: ModelContainer) async {
        let defaults = UserDefaults.standard
        guard defaults.integer(forKey: seededKey) < currentVersion else { return }

        let context = container.mainContext
        do {
            try await seedIngredients(in: context)
            try await seedRecipes(in: context)
            defaults.set(currentVersion, forKey: seededKey)
        } catch {
            print("[SeedDataService] Seed failed: \(error)")
        }
    }

    @MainActor
    private static func seedIngredients(in context: ModelContext) async throws {
        let dtos = try Bundle.main.decode([IngredientDTO].self, from: "ingredients.json")
        for dto in dtos {
            let ingredient = Ingredient(
                ingredientID: dto.id,
                nameJP: dto.nameJP,
                nameEN: dto.nameEN,
                category: dto.category,
                allergen: dto.allergen,
                notes: dto.notes
            )
            context.insert(ingredient)

            for (stageKey, safetyDTO) in dto.safety {
                let safety = IngredientSafety(
                    stage: stageKey,
                    level: safetyDTO.level,
                    prohibitionReason: safetyDTO.prohibitionReason,
                    sizeGuidance: safetyDTO.sizeGuidance
                )
                ingredient.safetyInfo.append(safety)
            }
        }
        try context.save()
    }

    @MainActor
    private static func seedRecipes(in context: ModelContext) async throws {
        let dtos = try Bundle.main.decode([RecipeDTO].self, from: "recipes.json")

        // Ingredient の ID → インスタンス のマップを作る
        let descriptor = FetchDescriptor<Ingredient>()
        let allIngredients = try context.fetch(descriptor)
        let ingredientMap = Dictionary(uniqueKeysWithValues: allIngredients.map { ($0.ingredientID, $0) })

        for dto in dtos {
            let recipe = Recipe(
                recipeID: dto.id,
                nameJP: dto.nameJP,
                descriptionJP: dto.descriptionJP,
                stages: dto.stages,
                cookingTimeMinutes: dto.cookingTimeMinutes,
                difficulty: dto.difficulty,
                kurashiruID: dto.kurashiruID,
                steps: dto.steps,
                tags: dto.tags
            )
            context.insert(recipe)

            for ri in dto.ingredients {
                let recipeIngredient = RecipeIngredient(
                    quantity: ri.quantity,
                    stageNotes: ri.stageNotes,
                    ingredient: ingredientMap[ri.ingredientID]
                )
                recipe.recipeIngredients.append(recipeIngredient)
            }
        }
        try context.save()
    }
}
