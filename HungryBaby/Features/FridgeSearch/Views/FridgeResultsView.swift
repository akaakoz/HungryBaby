import SwiftUI
import SwiftData

struct FridgeResultsView: View {
    @Query private var recipes: [Recipe]
    let viewModel: FridgeSearchViewModel
    @Environment(BabyProfileService.self) private var profileService

    var matchedRecipes: [FridgeSearchViewModel.MatchedRecipe] {
        viewModel.matchedRecipes(from: recipes)
    }

    private var selectedIngredientNames: [String] {
        viewModel.selectedIngredients.map(\.nameJP)
    }

    private var kurashiruSearchLink: some View {
        let kurashiruGreen = Color(red: 0.0, green: 0.722, blue: 0.420)
        return NavigationLink {
            KurashiruWebView(
                url: KurashiruService.searchURL(ingredients: selectedIngredientNames, stage: profileService.currentStage),
                title: "クラシルで検索"
            )
        } label: {
            HStack {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                Text("クラシルで動画を探す")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(kurashiruGreen.opacity(0.08))
            .foregroundStyle(kurashiruGreen)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(kurashiruGreen.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    var body: some View {
        if viewModel.selectedIngredientIDs.isEmpty {
            ContentUnavailableView(
                "食材を選んでください",
                systemImage: "refrigerator",
                description: Text("上の「食材を選ぶ」から冷蔵庫にある食材を選択すると、レシピを提案します")
            )
        } else if matchedRecipes.isEmpty {
            ContentUnavailableView(
                "レシピが見つかりません",
                systemImage: "fork.knife",
                description: Text("選択した食材で作れるレシピがありません。\n他の食材を選んでみてください")
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    kurashiruSearchLink

                    ForEach(matchedRecipes) { matched in
                        NavigationLink {
                            RecipeDetailView(recipe: matched.recipe)
                        } label: {
                            MatchedRecipeCardView(matched: matched)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
    }
}

private struct MatchedRecipeCardView: View {
    let matched: FridgeSearchViewModel.MatchedRecipe

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(matched.recipe.nameJP)
                        .font(.headline)
                    Text(matched.recipe.descriptionJP)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer()

                // マッチバッジ
                VStack(spacing: 2) {
                    if matched.isExactMatch {
                        Text("完全一致")
                            .font(.caption2.bold())
                            .foregroundStyle(Color.appSafe)
                    }
                    Text("\(matched.matchCount)/\(matched.totalSelected)")
                        .font(.caption.bold())
                        .foregroundStyle(Color.appPrimary)
                }
            }

            // マッチ度プログレスバー
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(matched.isExactMatch ? Color.appSafe : Color.appPrimary)
                        .frame(width: geo.size.width * matched.matchScore, height: 6)
                }
            }
            .frame(height: 6)

            HStack {
                Label("\(matched.recipe.cookingTimeMinutes)分", systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(matched.recipe.difficultyLevel.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 4) {
                    ForEach(matched.recipe.babyStages) { stage in
                        Circle()
                            .fill(stage.systemColor)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
        .padding()
        .background(Color.appCardBackground, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
}
