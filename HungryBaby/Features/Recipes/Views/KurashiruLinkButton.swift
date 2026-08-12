import SwiftUI

struct KurashiruLinkButton: View {
    let recipeID: String

    /// クラシルのブランドカラー
    private let kurashiruGreen = Color(red: 0.0, green: 0.722, blue: 0.420)

    var body: some View {
        Button {
            let url = KurashiruService.url(for: recipeID)
            UIApplication.shared.open(url)
        } label: {
            HStack {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                Text("クラシルで動画を見る")
                    .font(.headline)
                Spacer()
                Image(systemName: "arrow.up.right.square")
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
