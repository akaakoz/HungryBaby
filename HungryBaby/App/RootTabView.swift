import SwiftUI

struct RootTabView: View {
    @Environment(BabyProfileService.self) private var profileService
    @State private var showOnboarding: Bool = false

    var body: some View {
        TabView {
            Tab("月齢ガイド", systemImage: "calendar") {
                AgeGuideView()
            }
            Tab("食材サイズ", systemImage: "ruler") {
                Text("食材の大きさガイド（実装予定）")
            }
            Tab("レシピ", systemImage: "fork.knife") {
                Text("簡単メニュー（実装予定）")
            }
            Tab("冷蔵庫", systemImage: "refrigerator") {
                Text("冷蔵庫検索（実装予定）")
            }
        }
        .onAppear {
            if profileService.currentProfile == nil {
                showOnboarding = true
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
                .interactiveDismissDisabled(profileService.currentProfile == nil)
        }
    }
}

#Preview {
    RootTabView()
        .environment(BabyProfileService(container: try! .init(for: BabyProfile.self)))
}
