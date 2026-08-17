import SwiftUI

struct RecipeSiteLinkButton: View {
    var body: some View {
        NavigationLink {
            RecipeSiteWebView(
                url: KidsRecipeService.recipesURL(),
                title: "こどもレシピ"
            )
        } label: {
            HStack {
                Image(systemName: "book.circle.fill")
                    .font(.title2)
                Text("こどもレシピで探す")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.appPrimary.opacity(0.08))
            .foregroundStyle(Color.appPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appPrimary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
