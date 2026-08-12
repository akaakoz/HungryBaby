import Testing
import Foundation
import SwiftData
@testable import HungryBaby

@Suite("SeedDataService")
@MainActor
struct SeedDataServiceTests {

    private func makeInMemoryContainer() throws -> ModelContainer {
        let schema = Schema([
            BabyProfile.self,
            Ingredient.self,
            IngredientSafety.self,
            Recipe.self,
            RecipeIngredient.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: config)
    }

    @Test("初回シードでIngredientが1件以上登録される")
    func testSeedCreatesIngredients() async throws {
        let container = try makeInMemoryContainer()
        await SeedDataService.seedIfNeeded(in: container)

        let context = container.mainContext
        let count = try context.fetchCount(FetchDescriptor<Ingredient>())
        #expect(count > 0)
    }

    @Test("初回シードでRecipeが1件以上登録される")
    func testSeedCreatesRecipes() async throws {
        let container = try makeInMemoryContainer()
        await SeedDataService.seedIfNeeded(in: container)

        let context = container.mainContext
        let count = try context.fetchCount(FetchDescriptor<Recipe>())
        #expect(count > 0)
    }

    @Test("はちみつのゴックン期安全性はNG")
    func testHoneyIsProhibitedForGokun() async throws {
        let container = try makeInMemoryContainer()
        await SeedDataService.seedIfNeeded(in: container)

        let context = container.mainContext
        var descriptor = FetchDescriptor<Ingredient>(
            predicate: #Predicate { $0.ingredientID == "honey" }
        )
        descriptor.fetchLimit = 1
        let honey = try context.fetch(descriptor).first
        #expect(honey != nil)

        let safetyLevel = honey?.safetyLevel(for: .gokun)
        #expect(safetyLevel == .prohibited)
    }

    @Test("2回目のシードでデータが重複しない")
    func testSeedDoesNotDuplicate() async throws {
        let container = try makeInMemoryContainer()
        await SeedDataService.seedIfNeeded(in: container)
        await SeedDataService.seedIfNeeded(in: container)

        let context = container.mainContext
        let count = try context.fetchCount(FetchDescriptor<Ingredient>())
        // 1回目と同じ件数（重複していない）
        let dtos = try Bundle.main.decode([IngredientDTO_Test].self, from: "ingredients.json")
        #expect(count == dtos.count)
    }
}

// テスト用の最小DTOは内部でJSONパース確認に使う
private struct IngredientDTO_Test: Decodable {
    let id: String
}
