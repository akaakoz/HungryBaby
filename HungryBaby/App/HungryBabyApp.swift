//
//  HungryBabyApp.swift
//  HungryBaby
//
//  Created by Akiya Ozawa on R 8/08/12.
//

import SwiftUI
import SwiftData

@main
struct HungryBabyApp: App {
    let container: ModelContainer
    @State private var profileService: BabyProfileService

    init() {
        let schema = Schema([
            BabyProfile.self,
            Ingredient.self,
            IngredientSafety.self,
            Recipe.self,
            RecipeIngredient.self,
            FridgeItem.self
        ])
        let modelContainer = try! ModelContainer(for: schema)
        container = modelContainer
        _profileService = State(initialValue: BabyProfileService(container: modelContainer))
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .modelContainer(container)
                .environment(profileService)
                .preferredColorScheme(.light)
                .task {
                    await SeedDataService.seedIfNeeded(in: container)
                }
        }
    }
}
