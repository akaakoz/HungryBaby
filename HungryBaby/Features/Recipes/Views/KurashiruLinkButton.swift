import SwiftUI

struct KurashiruLinkButton: View {
    let recipeID: String

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
            .background(.red.opacity(0.08))
            .foregroundStyle(.red)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
