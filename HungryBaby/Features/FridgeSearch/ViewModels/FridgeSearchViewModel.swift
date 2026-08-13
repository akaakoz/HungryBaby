import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class FridgeSearchViewModel {
    var newItemName: String = ""

    func addItem(context: ModelContext) {
        let trimmed = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let item = FridgeItem(name: trimmed)
        context.insert(item)
        newItemName = ""
    }

    func deleteItem(_ item: FridgeItem, context: ModelContext) {
        context.delete(item)
    }
}
