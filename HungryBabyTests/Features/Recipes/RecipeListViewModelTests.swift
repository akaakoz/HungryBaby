import Testing
import Foundation
import SwiftData
@testable import HungryBaby

@Suite("RecipeListViewModel")
@MainActor
struct RecipeListViewModelTests {

    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([
            BabyProfile.self, Ingredient.self, IngredientSafety.self,
            Recipe.self, RecipeIngredient.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: config)
    }

    private func seedRecipes(in context: ModelContext) {
        // ゴックン期・かんたん・5分
        let r1 = Recipe(recipeID: "r1", nameJP: "10倍粥", descriptionJP: "基本",
                        stages: ["gokun"], cookingTimeMinutes: 5, difficulty: "easy",
                        steps: ["手順1"], tags: [])
        context.insert(r1)

        // モグモグ期・ふつう・15分
        let r2 = Recipe(recipeID: "r2", nameJP: "豆腐スープ", descriptionJP: "たんぱく質",
                        stages: ["mogumogu", "kamikamu"], cookingTimeMinutes: 15, difficulty: "medium",
                        steps: ["手順1"], tags: [])
        context.insert(r2)

        // パクパク期・手間・25分
        let r3 = Recipe(recipeID: "r3", nameJP: "五目粥", descriptionJP: "全部入り",
                        stages: ["mogumogu", "kamikamu", "pakupaku"], cookingTimeMinutes: 25, difficulty: "hard",
                        steps: ["手順1"], tags: [])
        context.insert(r3)

        try? context.save()
    }

    @Test("loadで全レシピが取得される")
    func testLoadFetchesAllRecipes() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedRecipes(in: context)

        let vm = RecipeListViewModel()
        vm.load(currentStage: nil, context: context)

        #expect(vm.recipes.count == 3)
    }

    @Test("ステージフィルタでゴックン期のみ表示")
    func testFilterByStage() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedRecipes(in: context)

        let vm = RecipeListViewModel()
        vm.load(currentStage: .gokun, context: context)

        #expect(vm.filteredRecipes.count == 1)
        #expect(vm.filteredRecipes.first?.recipeID == "r1")
    }

    @Test("難易度フィルタ（medium）")
    func testFilterByDifficulty() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedRecipes(in: context)

        let vm = RecipeListViewModel()
        vm.load(currentStage: nil, context: context)
        vm.selectedDifficulty = .medium

        #expect(vm.filteredRecipes.count == 1)
        #expect(vm.filteredRecipes.first?.recipeID == "r2")
    }

    @Test("調理時間フィルタ（quick: 10分以内）")
    func testFilterByCookingTime() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedRecipes(in: context)

        let vm = RecipeListViewModel()
        vm.load(currentStage: nil, context: context)
        vm.selectedCookingTime = .quick

        #expect(vm.filteredRecipes.count == 1)
        #expect(vm.filteredRecipes.first?.recipeID == "r1")
    }

    @Test("フィルタクリアで全件表示")
    func testClearFilters() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedRecipes(in: context)

        let vm = RecipeListViewModel()
        vm.load(currentStage: .gokun, context: context)
        #expect(vm.filteredRecipes.count == 1)

        vm.clearFilters()
        #expect(vm.filteredRecipes.count == 3)
    }

    @Test("hasActiveFilterはフィルタ設定時にtrueになる")
    func testHasActiveFilter() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedRecipes(in: context)

        let vm = RecipeListViewModel()
        vm.load(currentStage: nil, context: context)
        #expect(!vm.hasActiveFilter)

        vm.selectedDifficulty = .easy
        #expect(vm.hasActiveFilter)

        vm.clearFilters()
        #expect(!vm.hasActiveFilter)
    }

    @Test("検索テキストでフィルタリング")
    func testSearchText() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedRecipes(in: context)

        let vm = RecipeListViewModel()
        vm.load(currentStage: nil, context: context)
        vm.searchText = "豆腐"

        #expect(vm.filteredRecipes.count == 1)
        #expect(vm.filteredRecipes.first?.recipeID == "r2")
    }
}
