import Foundation
import Observation

@Observable
@MainActor
final class SizeGuideViewModel {
    var selectedStage: BabyStage = .gokun

    var currentGuide: SizeGuideContent {
        SizeGuideContent.guide(for: selectedStage)
    }
}

struct SizeGuideContent {
    let stage: BabyStage
    let textureName: String
    let sizeDescription: String
    let cookingTips: [String]
    let exampleFoods: [String]
    let cautionNote: String?

    static func guide(for stage: BabyStage) -> SizeGuideContent {
        switch stage {
        case .gokun:
            return SizeGuideContent(
                stage: .gokun,
                textureName: "なめらかなペースト状",
                sizeDescription: "サラサラ〜なめらかな液状",
                cookingTips: [
                    "食材をやわらかく茹でてすりつぶす",
                    "裏ごしして粒をなくす",
                    "母乳やミルク・だし汁でのばす",
                    "スプーンから流れ落ちるくらいのとろみが目安"
                ],
                exampleFoods: ["10倍粥（裏ごし）", "かぼちゃペースト", "さつまいもペースト", "にんじんペースト"],
                cautionNote: "粒が残っていると窒息の危険があります。必ず完全にすりつぶしてください。"
            )
        case .mogumogu:
            return SizeGuideContent(
                stage: .mogumogu,
                textureName: "舌でつぶせる軟らかさ",
                sizeDescription: "約3mm（豆腐程度の軟らかさ）",
                cookingTips: [
                    "舌と上あごで押しつぶせる軟らかさが目安",
                    "食材は3mm程度の大きさに切る",
                    "やわらかく茹でてから刻む",
                    "とろみをつけると飲み込みやすい"
                ],
                exampleFoods: ["7倍粥", "やわらか豆腐（3mm角）", "茹でにんじん（3mm角）", "ほぐした白身魚"],
                cautionNote: "丸のみしていないか確認してください。"
            )
        case .kamikamu:
            return SizeGuideContent(
                stage: .kamikamu,
                textureName: "歯ぐきでつぶせる軟らかさ",
                sizeDescription: "約5〜7mm（バナナ程度の軟らかさ）",
                cookingTips: [
                    "歯ぐきでつぶせる軟らかさが目安",
                    "食材は5〜7mm程度の大きさに切る",
                    "少し形が残る程度でOK",
                    "手づかみ食べも積極的に取り入れる"
                ],
                exampleFoods: ["5倍粥", "やわらかく茹でた野菜（5mm角）", "ほぐした魚・肉", "柔らかいパン"],
                cautionNote: "喉に詰まる危険のある食材（ナッツ、生の野菜、こんにゃく）は避けましょう。"
            )
        case .pakupaku:
            return SizeGuideContent(
                stage: .pakupaku,
                textureName: "歯ぐきで噛める軟らかさ",
                sizeDescription: "約1cm（大人と同じ食材・小さめサイズ）",
                cookingTips: [
                    "大人と同じ食材を小さく切って与えられる",
                    "1cm角程度の大きさを目安に",
                    "軟飯から徐々に普通ご飯へ移行",
                    "大人の食事から取り分けが可能になる"
                ],
                exampleFoods: ["軟飯", "やわらかく煮た野菜（1cm角）", "鶏肉（1cm角、しっかり加熱）", "うどん（1cm程度）"],
                cautionNote: "薄皮のある食材（枝豆・ぶどうなど）は窒息リスクあり。引き続き注意が必要です。"
            )
        }
    }
}
