import SwiftUI

struct StageHeaderView: View {
    let stage: BabyStage

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: stage.icon)
                    .font(.title2)
                Text(stage.displayName)
                    .font(.title2.bold())
            }
            .foregroundStyle(.white)

            Text(stage.ageRangeDescription)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))

            Text(stage.textureDescription)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.85))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [stage.systemColor, stage.systemColor.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        ForEach(BabyStage.allCases) { stage in
            StageHeaderView(stage: stage)
        }
    }
    .background(Color.appBackground)
}
