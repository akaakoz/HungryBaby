import Foundation
import SwiftData

@Model
final class IngredientSafety {
    var stage: String
    var level: String
    var prohibitionReason: String?
    var sizeGuidance: String?

    init(
        stage: String,
        level: String,
        prohibitionReason: String? = nil,
        sizeGuidance: String? = nil
    ) {
        self.stage = stage
        self.level = level
        self.prohibitionReason = prohibitionReason
        self.sizeGuidance = sizeGuidance
    }

    var babyStage: BabyStage? { BabyStage(rawValue: stage) }
    var safetyLevel: SafetyLevel? { SafetyLevel(rawValue: level) }
}
