import Foundation
import Observation
import SwiftData
import UIKit

@Observable
@MainActor
final class FridgeSearchViewModel {
    var newItemName: String = ""
    var showCamera: Bool = false
    var showScannedItems: Bool = false
    var scannedItems: [ScannedItem] = []
    var isScanning: Bool = false

    struct ScannedItem: Identifiable {
        let id = UUID()
        let name: String
        var isSelected: Bool = true
    }

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

    func processReceiptImage(_ image: UIImage) async {
        isScanning = true
        let ingredients = await ReceiptScannerService.recognizeIngredients(from: image)
        scannedItems = ingredients.map { ScannedItem(name: $0) }
        isScanning = false
        if !scannedItems.isEmpty {
            showScannedItems = true
        }
    }

    func addSelectedScannedItems(context: ModelContext) {
        for item in scannedItems where item.isSelected {
            let fridgeItem = FridgeItem(name: item.name)
            context.insert(fridgeItem)
        }
        scannedItems = []
        showScannedItems = false
    }
}
