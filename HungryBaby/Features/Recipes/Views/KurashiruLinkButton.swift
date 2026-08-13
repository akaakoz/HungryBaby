import SwiftUI

struct KurashiruLinkButton: View {
    let searchQuery: String
    let stage: BabyStage?
    private let kurashiruGreen = Color(red: 0.0, green: 0.722, blue: 0.420)

    var body: some View {
        NavigationLink {
            KurashiruWebView(
                url: KurashiruService.searchURL(recipeName: searchQuery, stage: stage),
                title: "クラシルで検索"
            )
        } label: {
            HStack {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                Text("クラシルで動画を探す")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(kurashiruGreen.opacity(0.08))
            .foregroundStyle(kurashiruGreen)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(kurashiruGreen.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
