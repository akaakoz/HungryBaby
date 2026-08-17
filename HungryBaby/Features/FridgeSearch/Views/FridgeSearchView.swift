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
                VStack(spacing: 8) {
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

                    // レシート撮影ボタン
                    Button {
                        isTextFieldFocused = false
                        viewModel.showCamera = true
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("レシートを撮影して追加")
                                .font(.callout)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemBackground))
                        .foregroundStyle(Color.appPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
                .background(Color.appBackground)

                if viewModel.isScanning {
                    VStack(spacing: 12) {
                        ProgressView()
                            .controlSize(.large)
                        Text("レシートを読み取り中...")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if fridgeItems.isEmpty {
                    ContentUnavailableView(
                        "食材を追加してください",
                        systemImage: "refrigerator",
                        description: Text("食材を入力するか、レシートを撮影して追加できます")
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
            .fullScreenCover(isPresented: $viewModel.showCamera) {
                CameraView { image in
                    Task {
                        await viewModel.processReceiptImage(image)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showScannedItems) {
                ScannedItemsView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    FridgeSearchView()
}
