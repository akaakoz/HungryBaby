import SwiftUI

struct IngredientSafetyRowView: View {
    let ingredient: Ingredient
    let stage: BabyStage

    private var safetyLevel: SafetyLevel {
        ingredient.safetyLevel(for: stage)
    }

    private var safetyColor: Color {
        switch safetyLevel {
        case .ok: .appSafe
        case .caution: .appCaution
        case .prohibited: .appDanger
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(ingredient.nameJP)
                    .font(.body)

                if let sizeGuidance = ingredient.safety(for: stage)?.sizeGuidance {
                    Text(sizeGuidance)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            if ingredient.allergen {
                Text("アレルゲン")
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.appCaution.opacity(0.15))
                    .foregroundStyle(Color.appCaution)
                    .clipShape(Capsule())
            }

            Label(safetyLevel.displayName, systemImage: safetyLevel.icon)
                .font(.callout.bold())
                .foregroundStyle(safetyColor)
                .labelStyle(.titleOnly)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(safetyColor.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}
