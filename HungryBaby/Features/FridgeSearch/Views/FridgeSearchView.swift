import SwiftUI
import SwiftData

struct FridgeSearchView: View {
    @State private var viewModel = FridgeSearchViewModel()
    @Environment(\.modelContext) private var context
    @Query(sort: \FridgeItem.addedAt, order: .reverse) private var fridgeItems: [FridgeItem]
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 食材入力エリア
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("食材を追加（例：にんじん）", text: $viewModel.newItemName)
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                viewModel.addItem(context: context)
                                isTextFieldFocused = false
                            }
                    }
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    let isEmpty = viewModel.newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    Button {
                        viewModel.addItem(context: context)
                        isTextFieldFocused = false
                    } label: {
                        Text("追加")
                            .font(.callout.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(isEmpty ? Color.gray.opacity(0.4) : Color.appPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(isEmpty)
                }
                .padding()
                .background(Color.appBackground)

                if fridgeItems.isEmpty {
                    ContentUnavailableView(
                        "食材を追加してください",
                        systemImage: "refrigerator",
                        description: Text("上から冷蔵庫にある食材を入力すると、こどもレシピでレシピを検索できます")
                    )
                } else {
                    List {
                        // レシピサイト検索ボタン
                        Section {
                            NavigationLink {
                                RecipeSiteWebView(
                                    url: KidsRecipeService.searchURL(ingredients: fridgeItems.map(\.name)),
                                    title: "こどもレシピで検索"
                                )
                            } label: {
                                HStack {
                                    Image(systemName: "book.circle.fill")
                                        .font(.title2)
                                    Text("こどもレシピで探す")
                                        .font(.headline)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .foregroundStyle(Color.appPrimary)
                            }
                            .buttonStyle(.plain)
                        }

                        // 保存済み食材リスト
                        Section("冷蔵庫の食材") {
                            ForEach(fridgeItems) { item in
                                HStack {
                                    Text(item.name)
                                    Spacer()
                                    Button {
                                        viewModel.deleteItem(item, context: context)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("冷蔵庫検索")
            .toolbar {
                if isTextFieldFocused {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("閉じる") { isTextFieldFocused = false }
                    }
                }
            }
        }
    }
}

#Preview {
    FridgeSearchView()
}
