import SwiftUI

struct IngredientDetailView: View {
    let ingredient: Ingredient

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // ヘッダー
                VStack(alignment: .leading, spacing: 6) {
                    Text(ingredient.nameJP)
                        .font(.title2.bold())
                    Text(ingredient.ingredientCategory.displayName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if ingredient.allergen {
                        Label("主要アレルゲン", systemImage: "exclamationmark.triangle.fill")
                            .font(.callout)
                            .foregroundStyle(Color.appCaution)
                    }
                }

                Divider()

                // ステージ別安全性テーブル
                VStack(alignment: .leading, spacing: 12) {
                    Text("ステージ別安全性")
                        .font(.headline)

                    ForEach(BabyStage.allCases) { stage in
                        StageSafetyRow(ingredient: ingredient, stage: stage)
                    }
                }

                // 注意事項
                if let notes = ingredient.notes {
                    Divider()
                    VStack(alignment: .leading, spacing: 6) {
                        Label("注意事項", systemImage: "note.text")
                            .font(.headline)
                        Text(notes)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(ingredient.nameJP)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct StageSafetyRow: View {
    let ingredient: Ingredient
    let stage: BabyStage

    private var safety: IngredientSafety? { ingredient.safety(for: stage) }
    private var level: SafetyLevel { ingredient.safetyLevel(for: stage) }

    private var levelColor: Color {
        switch level {
        case .ok: .appSafe
        case .caution: .appCaution
        case .prohibited: .appDanger
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Circle()
                    .fill(stage.systemColor)
                    .frame(width: 10, height: 10)

                Text(stage.displayName)
                    .font(.callout.bold())

                Spacer()

                Text(level.displayName)
                    .font(.callout.bold())
                    .foregroundStyle(levelColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(levelColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            if let reason = safety?.prohibitionReason {
                Text(reason)
                    .font(.caption)
                    .foregroundStyle(Color.appDanger.opacity(0.8))
                    .padding(.leading, 20)
            } else if let guidance = safety?.sizeGuidance {
                Text(guidance)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 20)
            }
        }
        .padding(10)
        .background(.secondary.opacity(0.05), in: RoundedRectangle(cornerRadius: 10))
    }
}
