import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // ヘッダー情報
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.descriptionJP)
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        Label("\(recipe.cookingTimeMinutes)分", systemImage: "clock")
                        Label(recipe.difficultyLevel.displayName, systemImage: "chart.bar")
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)

                    // 対応ステージ
                    HStack(spacing: 6) {
                        ForEach(recipe.babyStages) { stage in
                            Text(stage.displayName)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(stage.systemColor.opacity(0.12))
                                .foregroundStyle(stage.systemColor)
                                .clipShape(Capsule())
                        }
                    }
                }

                Divider()

                // クラシルリンク
                if let kurashiruID = recipe.kurashiruID {
                    KurashiruLinkButton(recipeID: kurashiruID)
                    Divider()
                }

                // 材料
                VStack(alignment: .leading, spacing: 10) {
                    Label("材料", systemImage: "list.bullet")
                        .font(.headline)

                    ForEach(recipe.recipeIngredients) { ri in
                        HStack {
                            Text(ri.ingredient?.nameJP ?? "")
                                .font(.body)
                            Spacer()
                            Text(ri.quantity)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 2)

                        if let notes = ri.stageNotes {
                            Text(notes)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.leading, 8)
                        }

                        Divider()
                    }
                }

                // 手順
                VStack(alignment: .leading, spacing: 12) {
                    Label("作り方", systemImage: "checklist")
                        .font(.headline)

                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 28, height: 28)
                                .background(Color.appPrimary)
                                .clipShape(Circle())

                            Text(step)
                                .font(.body)
                        }
                    }
                }

                // タグ
                if !recipe.tags.isEmpty {
                    Divider()
                    HStack {
                        ForEach(recipe.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.gray.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(recipe.nameJP)
        .navigationBarTitleDisplayMode(.large)
    }
}
