import Testing
import Foundation
import SwiftData
@testable import HungryBaby

@Suite("AgeGuideViewModel")
@MainActor
struct AgeGuideViewModelTests {

    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([
            BabyProfile.self, Ingredient.self, IngredientSafety.self,
            Recipe.self, RecipeIngredient.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: config)
    }

    private func seedIngredients(in context: ModelContext) {
        // はちみつ（NG）
        let honey = Ingredient(ingredientID: "honey", nameJP: "はちみつ", nameEN: "Honey",
                               category: "other", allergen: false, notes: nil)
        context.insert(honey)
        honey.safetyInfo.append(IngredientSafety(stage: "gokun", level: "prohibited",
                                                  prohibitionReason: "ボツリヌス菌"))
        honey.safetyInfo.append(IngredientSafety(stage: "mogumogu", level: "prohibited"))
        honey.safetyInfo.append(IngredientSafety(stage: "kamikamu", level: "prohibited"))
        honey.safetyInfo.append(IngredientSafety(stage: "pakupaku", level: "ok"))

        // にんじん（OK）
        let carrot = Ingredient(ingredientID: "carrot", nameJP: "にんじん", nameEN: "Carrot",
                                category: "vegetable", allergen: false, notes: nil)
        context.insert(carrot)
        carrot.safetyInfo.append(IngredientSafety(stage: "gokun", level: "ok", sizeGuidance: "すりつぶす"))
        carrot.safetyInfo.append(IngredientSafety(stage: "mogumogu", level: "ok"))

        // そば（注意）
        let soba = Ingredient(ingredientID: "soba", nameJP: "そば", nameEN: "Buckwheat",
                              category: "grain", allergen: true, notes: nil)
        context.insert(soba)
        soba.safetyInfo.append(IngredientSafety(stage: "gokun", level: "prohibited"))
        soba.safetyInfo.append(IngredientSafety(stage: "kamikamu", level: "caution"))

        try? context.save()
    }

    @Test("loadで食材が取得される")
    func testLoadFetchesIngredients() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedIngredients(in: context)

        let vm = AgeGuideViewModel()
        vm.load(stage: .gokun, context: context)

        #expect(vm.ingredients.count == 3)
    }

    @Test("フィルタなしで全食材が表示される")
    func testNoFilterShowsAll() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedIngredients(in: context)

        let vm = AgeGuideViewModel()
        vm.load(stage: .gokun, context: context)

        #expect(vm.filteredIngredients.count == 3)
    }

    @Test("検索テキストで食材が絞り込まれる")
    func testSearchFiltersIngredients() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedIngredients(in: context)

        let vm = AgeGuideViewModel()
        vm.load(stage: .gokun, context: context)
        vm.searchText = "にんじん"

        #expect(vm.filteredIngredients.count == 1)
        #expect(vm.filteredIngredients.first?.ingredientID == "carrot")
    }

    @Test("ソート順: OK → 注意 → NG")
    func testSortOrderByStage() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedIngredients(in: context)

        let vm = AgeGuideViewModel()
        vm.load(stage: .gokun, context: context)

        let levels = vm.filteredIngredients.map { $0.safetyLevel(for: .gokun) }
        // OKが最初、NGが最後に来る
        let okFirst = levels.first == .ok
        let ngLast = levels.last == .prohibited
        #expect(okFirst)
        #expect(ngLast)
    }

    @Test("selectedIngredientの選択")
    func testSelectIngredient() throws {
        let container = try makeContainer()
        let context = container.mainContext
        seedIngredients(in: context)

        let vm = AgeGuideViewModel()
        vm.load(stage: .gokun, context: context)

        let first = vm.filteredIngredients.first
        vm.selectedIngredient = first
        #expect(vm.selectedIngredient?.ingredientID == first?.ingredientID)
    }
}
