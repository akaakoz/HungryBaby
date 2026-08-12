import Testing
import Foundation
import SwiftData
@testable import HungryBaby

@Suite("FridgeSearchViewModel")
@MainActor
struct FridgeSearchViewModelTests {

    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([
            BabyProfile.self, Ingredient.self, IngredientSafety.self,
            Recipe.self, RecipeIngredient.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: config)
    }

    private func setupData(in context: ModelContext) -> (carrot: Ingredient, potato: Ingredient, onion: Ingredient, recipe1: Recipe, recipe2: Recipe) {
        let carrot = Ingredient(ingredientID: "carrot", nameJP: "にんじん", nameEN: "Carrot",
                                category: "vegetable", allergen: false)
        let potato = Ingredient(ingredientID: "potato", nameJP: "じゃがいも", nameEN: "Potato",
                                category: "vegetable", allergen: false)
        let onion = Ingredient(ingredientID: "onion", nameJP: "玉ねぎ", nameEN: "Onion",
                               category: "vegetable", allergen: false)
        context.insert(carrot)
        context.insert(potato)
        context.insert(onion)

        // レシピ1: にんじん + じゃがいも
        let recipe1 = Recipe(recipeID: "r1", nameJP: "にんじんじゃがいも", descriptionJP: "test",
                             stages: ["mogumogu"], cookingTimeMinutes: 10, difficulty: "easy",
                             steps: [], tags: [])
        context.insert(recipe1)
        let ri1a = RecipeIngredient(quantity: "30g", ingredient: carrot)
        let ri1b = RecipeIngredient(quantity: "30g", ingredient: potato)
        recipe1.recipeIngredients.append(ri1a)
        recipe1.recipeIngredients.append(ri1b)

        // レシピ2: にんじん + 玉ねぎ
        let recipe2 = Recipe(recipeID: "r2", nameJP: "にんじん玉ねぎ", descriptionJP: "test",
                             stages: ["kamikamu"], cookingTimeMinutes: 15, difficulty: "easy",
                             steps: [], tags: [])
        context.insert(recipe2)
        let ri2a = RecipeIngredient(quantity: "20g", ingredient: carrot)
        let ri2b = RecipeIngredient(quantity: "15g", ingredient: onion)
        recipe2.recipeIngredients.append(ri2a)
        recipe2.recipeIngredients.append(ri2b)

        try? context.save()
        return (carrot, potato, onion, recipe1, recipe2)
    }

    @Test("食材未選択でマッチなし")
    func testEmptySelectionReturnsNoMatches() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let (_, _, _, recipe1, recipe2) = setupData(in: context)

        let vm = FridgeSearchViewModel()
        vm.load(context: context)

        let matches = vm.matchedRecipes(from: [recipe1, recipe2])
        #expect(matches.isEmpty)
    }

    @Test("にんじんを選択するとにんじんを含むレシピがマッチ")
    func testSingleIngredientMatchesBothRecipes() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let (carrot, _, _, recipe1, recipe2) = setupData(in: context)

        let vm = FridgeSearchViewModel()
        vm.load(context: context)
        vm.toggle(ingredient: carrot)

        let matches = vm.matchedRecipes(from: [recipe1, recipe2])
        #expect(matches.count == 2)
    }

    @Test("にんじん+じゃがいもを選択するとレシピ1が完全一致")
    func testExactMatchWhenAllIngredientsMatch() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let (carrot, potato, _, recipe1, recipe2) = setupData(in: context)

        let vm = FridgeSearchViewModel()
        vm.load(context: context)
        vm.toggle(ingredient: carrot)
        vm.toggle(ingredient: potato)

        let matches = vm.matchedRecipes(from: [recipe1, recipe2])
        let recipe1Match = matches.first { $0.recipe.recipeID == "r1" }
        let recipe2Match = matches.first { $0.recipe.recipeID == "r2" }

        #expect(recipe1Match?.isExactMatch == true)   // r1は2/2で完全一致
        #expect(recipe2Match?.isExactMatch == false)  // r2は1/2で部分一致
    }

    @Test("マッチ数が多いレシピが上位に表示される")
    func testHigherMatchCountSortedFirst() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let (carrot, potato, onion, recipe1, recipe2) = setupData(in: context)

        let vm = FridgeSearchViewModel()
        vm.load(context: context)
        vm.toggle(ingredient: carrot)
        vm.toggle(ingredient: potato)
        vm.toggle(ingredient: onion)  // 3食材選択

        // recipe1: carrot+potato → 2マッチ
        // recipe2: carrot+onion → 2マッチ（同数なので調理時間順）
        let matches = vm.matchedRecipes(from: [recipe1, recipe2])
        #expect(matches.count == 2)
        // 同マッチ数の場合、調理時間が短い順
        #expect(matches.first?.recipe.recipeID == "r1")
    }

    @Test("同じ食材を2回タップすると選択解除される")
    func testToggleDeselects() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let (carrot, _, _, _, _) = setupData(in: context)

        let vm = FridgeSearchViewModel()
        vm.load(context: context)

        vm.toggle(ingredient: carrot)
        #expect(vm.isSelected(carrot) == true)

        vm.toggle(ingredient: carrot)
        #expect(vm.isSelected(carrot) == false)
    }

    @Test("食材を選択するとselectedIngredientsに含まれる")
    func testSelectedIngredients() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let (carrot, potato, _, _, _) = setupData(in: context)

        let vm = FridgeSearchViewModel()
        vm.load(context: context)
        vm.toggle(ingredient: carrot)
        vm.toggle(ingredient: potato)

        #expect(vm.selectedIngredients.count == 2)
    }
}
