import SwiftUI

struct TextureDetailView: View {
    let guide: SizeGuideContent

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // サイズ視覚化
                VStack(spacing: 12) {
                    SizeVisualizationView(stage: guide.stage)
                }
                .padding()
                .background(guide.stage.systemColor.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))

                // 調理のコツ
                VStack(alignment: .leading, spacing: 10) {
                    Label("調理のコツ", systemImage: "flame.fill")
                        .font(.headline)
                        .foregroundStyle(guide.stage.systemColor)

                    ForEach(guide.cookingTips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.callout)
                                .padding(.top, 1)
                            Text(tip)
                                .font(.body)
                        }
                    }
                }

                // 食材例
                VStack(alignment: .leading, spacing: 10) {
                    Label("食材・メニュー例", systemImage: "fork.knife")
                        .font(.headline)

                    FlowLayout(items: guide.exampleFoods) { food in
                        Text(food)
                            .font(.callout)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(guide.stage.systemColor.opacity(0.12))
                            .foregroundStyle(guide.stage.systemColor)
                            .clipShape(Capsule())
                    }
                }

                // 注意事項
                if let caution = guide.cautionNote {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("注意事項", systemImage: "exclamationmark.triangle.fill")
                            .font(.headline)
                            .foregroundStyle(.orange)
                        Text(caution)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.orange.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
    }
}

private struct SizeVisualizationView: View {
    let stage: BabyStage

    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 6) {
                Text(stage.displayName)
                    .font(.caption.bold())
                    .foregroundStyle(stage.systemColor)

                if let sizeMM = stage.approximateSizeMM {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(stage.systemColor)
                            .frame(width: CGFloat(sizeMM) * 3, height: CGFloat(sizeMM) * 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(stage.systemColor.opacity(0.5), lineWidth: 1)
                            )
                    }
                    .frame(width: 60, height: 60)

                    Text("約\(sizeMM)mm")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(stage.systemColor)
                        .frame(width: 60, height: 60)

                    Text("ペースト状")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(stage.textureDescription)
                    .font(.callout.bold())
                Text(stage.ageRangeDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("授乳回数: \(stage.feedingFrequency)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("お粥: \(stage.porridgeRatio)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}

// シンプルなFlow Layout
private struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let items: Data
    let content: (Data.Element) -> Content

    var body: some View {
        // シンプルな実装: LazyVGrid で代用
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .leading, spacing: 8) {
            ForEach(Array(items), id: \.self) { item in
                content(item)
            }
        }
    }
}
