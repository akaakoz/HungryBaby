import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(BabyProfileService.self) private var profileService
    @State private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            Form {
                // 赤ちゃん情報
                Section("赤ちゃんの情報") {
                    if viewModel.isEditing {
                        TextField("ニックネーム（任意）", text: $viewModel.nickname)

                        DatePicker(
                            "生年月日",
                            selection: $viewModel.birthDate,
                            in: ...Date.now,
                            displayedComponents: .date
                        )
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                    } else {
                        LabeledContent("ニックネーム") {
                            Text(profileService.currentProfile?.nickname.isEmpty == false
                                 ? profileService.currentProfile!.nickname
                                 : "未設定")
                                .foregroundStyle(.secondary)
                        }

                        if let profile = profileService.currentProfile {
                            LabeledContent("生年月日") {
                                Text(profile.birthDate, style: .date)
                                    .foregroundStyle(.secondary)
                                    .environment(\.locale, Locale(identifier: "ja_JP"))
                            }
                        }
                    }
                }

                // 現在のステージ
                if let stage = profileService.currentStage {
                    Section("現在のステージ") {
                        HStack {
                            Circle()
                                .fill(stage.systemColor)
                                .frame(width: 12, height: 12)
                            Text(stage.displayName)
                                .font(.body.bold())
                        }
                        LabeledContent("月齢") {
                            Text(stage.ageRangeDescription)
                                .foregroundStyle(.secondary)
                        }
                        LabeledContent("テクスチャ") {
                            Text(stage.textureDescription)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.trailing)
                        }
                        LabeledContent("お粥の硬さ") {
                            Text(stage.porridgeRatio)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // アプリ情報
                Section("アプリ情報") {
                    LabeledContent("バージョン") {
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("設定")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isEditing {
                        Button("保存") {
                            viewModel.save(using: profileService)
                        }
                        .fontWeight(.bold)
                    } else {
                        Button("編集") {
                            viewModel.load(from: profileService)
                            viewModel.isEditing = true
                        }
                    }
                }
                if viewModel.isEditing {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("キャンセル") {
                            viewModel.isEditing = false
                        }
                    }
                }
            }
            .onAppear {
                viewModel.load(from: profileService)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(BabyProfileService(container: try! .init(for: BabyProfile.self)))
}
