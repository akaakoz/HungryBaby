import SwiftUI

struct SizeGuideCardView: View {
    let guide: SizeGuideContent
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle()
                    .fill(guide.stage.systemColor)
                    .frame(width: 12, height: 12)

                Text(guide.stage.displayName)
                    .font(.headline)

                Spacer()

                Text(guide.stage.ageRangeDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(guide.textureName)
                .font(.subheadline.bold())
                .foregroundStyle(guide.stage.systemColor)

            Text(guide.sizeDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            isSelected ? guide.stage.systemColor.opacity(0.12) : Color(.secondarySystemBackground),
            in: RoundedRectangle(cornerRadius: 12)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? guide.stage.systemColor : .clear, lineWidth: 2)
        )
    }
}
