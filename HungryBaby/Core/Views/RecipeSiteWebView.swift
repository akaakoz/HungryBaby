import SwiftUI
import WebKit

struct RecipeSiteWebView: View {
    let url: URL
    let title: String

    var body: some View {
        WebView(url: url)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}
