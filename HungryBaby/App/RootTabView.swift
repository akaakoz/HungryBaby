import SwiftUI
import SwiftData

struct RootTabView: View {
    @Environment(BabyProfileService.self) private var profileService
    @State private var showOnboarding: Bool = false

    var body: some View {
        TabView {
            Tab("冷蔵庫", systemImage: "refrigerator") {
                FridgeSearchView()
            }
            Tab("月齢ガイド", systemImage: "calendar") {
                AgeGuideView()
            }
            Tab("設定", systemImage: "gearshape") {
                SettingsView()
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
