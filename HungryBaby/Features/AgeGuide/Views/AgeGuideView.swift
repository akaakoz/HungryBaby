import SwiftUI
import SwiftData

struct AgeGuideView: View {
    @Environment(BabyProfileService.self) private var profileService
    @State private var selectedStage: BabyStage = .gokun

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // 現在のステージバナー
                    if let stage = profileService.currentStage {
                        StageHeaderView(stage: stage)
                            .onAppear { selectedStage = stage }
                    }

                    // ステージ切り替え
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(BabyStage.allCases) { stage in
                                Button {
                                    selectedStage = stage
                                } label: {
                                    Text(stage.displayName)
                                        .font(.callout.bold())
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(selectedStage == stage ? stage.systemColor : Color(.secondarySystemBackground))
                                        .foregroundStyle(selectedStage == stage ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // 授乳回数情報
                    HStack {
                        Label(selectedStage.feedingFrequency, systemImage: "calendar.badge.clock")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Label(selectedStage.porridgeRatio, systemImage: "fork.knife")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                }
            }

            // 食材リスト
            IngredientSafetyListView(stage: selectedStage)
        }
        .navigationTitle("月齢ガイド")
    }
}

#Preview {
    AgeGuideView()
        .environment(BabyProfileService(container: try! .init(for: BabyProfile.self)))
}
