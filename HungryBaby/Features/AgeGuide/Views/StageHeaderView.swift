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
        .background(stage.systemColor.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        ForEach(BabyStage.allCases) { stage in
            StageHeaderView(stage: stage)
        }
    }
}
