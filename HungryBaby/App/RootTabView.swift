import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            Text("月齢ガイド")
                .tabItem { Label("月齢ガイド", systemImage: "calendar") }
            Text("食材の大きさ")
                .tabItem { Label("食材サイズ", systemImage: "ruler") }
            Text("簡単メニュー")
                .tabItem { Label("レシピ", systemImage: "fork.knife") }
            Text("冷蔵庫検索")
                .tabItem { Label("冷蔵庫", systemImage: "refrigerator") }
        }
    }
}

#Preview {
    RootTabView()
}
