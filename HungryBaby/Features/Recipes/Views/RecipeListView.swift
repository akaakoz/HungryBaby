import SwiftUI
import SwiftData

struct RecipeListView: View {
    @State private var viewModel = RecipeListViewModel()
    @Environment(BabyProfileService.self) private var profileService
    @Environment(\.modelContext) private var context
    @State private var showFilter = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.filteredRecipes.isEmpty {
                    ContentUnavailableView(
                        "レシピが見つかりません",
                        systemImage: "fork.knife",
                        description: Text("フィルターを変更してみてください")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredRecipes) { recipe in
                                NavigationLink {
                                    RecipeDetailView(recipe: recipe)
                                } label: {
                                    RecipeCardView(
                                        recipe: recipe,
                                        currentStage: profileService.currentStage
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "レシピを検索")
            .navigationTitle("かんたんメニュー")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilter = true
                    } label: {
                        Label("フィルター", systemImage: viewModel.hasActiveFilter ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showFilter) {
                RecipeFilterView(
                    selectedStage: $viewModel.selectedStage,
                    selectedDifficulty: $viewModel.selectedDifficulty,
                    selectedCookingTime: $viewModel.selectedCookingTime
                )
            }
            .onAppear {
                viewModel.load(currentStage: profileService.currentStage, context: context)
            }
        }
    }
}

#Preview {
    RecipeListView()
        .environment(BabyProfileService(container: try! .init(for: BabyProfile.self)))
}
