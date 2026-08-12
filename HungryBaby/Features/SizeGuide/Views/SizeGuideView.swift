import SwiftUI

struct SizeGuideView: View {
    @State private var viewModel = SizeGuideViewModel()
    @Environment(BabyProfileService.self) private var profileService

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // ステージ選択カード
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(BabyStage.allCases) { stage in
                                let guide = SizeGuideContent.guide(for: stage)
                                Button {
                                    viewModel.selectedStage = stage
                                } label: {
                                    SizeGuideCardView(
                                        guide: guide,
                                        isSelected: viewModel.selectedStage == stage
                                    )
                                    .frame(width: 200)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // 詳細表示
                    TextureDetailView(guide: viewModel.currentGuide)
                }
            }
            .navigationTitle("食材の大きさ")
            .onAppear {
                if let stage = profileService.currentStage {
                    viewModel.selectedStage = stage
                }
            }
        }
    }
}

#Preview {
    SizeGuideView()
        .environment(BabyProfileService(container: try! .init(for: BabyProfile.self)))
}
