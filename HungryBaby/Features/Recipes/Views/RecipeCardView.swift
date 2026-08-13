import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    let currentStage: BabyStage?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.nameJP)
                        .font(.headline)
                        .lineLimit(2)

                    Text(recipe.descriptionJP)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color(red: 0.0, green: 0.722, blue: 0.420).opacity(0.8))
            }

            HStack(spacing: 8) {
                // 調理時間
                Label("\(recipe.cookingTimeMinutes)分", systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                // 難易度
                Text(recipe.difficultyLevel.displayName)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.appPrimary.opacity(0.08))
                    .foregroundStyle(Color.appPrimary)
                    .clipShape(Capsule())

                Spacer()

                // ステージバッジ
                HStack(spacing: 4) {
                    ForEach(recipe.babyStages) { stage in
                        Circle()
                            .fill(stage.systemColor)
                            .frame(width: 10, height: 10)
                    }
                }
            }

            // タグ
            if !recipe.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(recipe.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.gray.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.appCardBackground, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
}
