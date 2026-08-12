import Foundation
import SwiftData

@Model
final class RecipeIngredient {
    var quantity: String
    var stageNotes: String?
    var ingredient: Ingredient?

    init(quantity: String, stageNotes: String? = nil, ingredient: Ingredient? = nil) {
        self.quantity = quantity
        self.stageNotes = stageNotes
        self.ingredient = ingredient
    }
}
