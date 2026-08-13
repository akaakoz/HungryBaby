import SwiftUI

enum BabyStage: String, CaseIterable, Codable, Identifiable {
    case gokun = "gokun"
    case mogumogu = "mogumogu"
    case kamikamu = "kamikamu"
    case pakupaku = "pakupaku"
    case oneAndHalf = "oneAndHalf"
    case twoYears = "twoYears"
    case threeYearsPlus = "threeYearsPlus"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .gokun: "ゴックン期"
        case .mogumogu: "モグモグ期"
        case .kamikamu: "カミカミ期"
        case .pakupaku: "パクパク期"
        case .oneAndHalf: "1歳半"
        case .twoYears: "2歳"
        case .threeYearsPlus: "3歳以上"
        }
    }

    /// 対象月齢（ヶ月）
    var ageRange: ClosedRange<Int> {
        switch self {
        case .gokun: 5...6
        case .mogumogu: 7...8
        case .kamikamu: 9...11
        case .pakupaku: 12...18
        case .oneAndHalf: 19...23
        case .twoYears: 24...35
        case .threeYearsPlus: 36...72
        }
    }

    var ageRangeDescription: String {
        switch self {
        case .gokun: "生後5〜6ヶ月"
        case .mogumogu: "生後7〜8ヶ月"
        case .kamikamu: "生後9〜11ヶ月"
        case .pakupaku: "生後12〜18ヶ月"
        case .oneAndHalf: "1歳半〜2歳"
        case .twoYears: "2歳〜3歳"
        case .threeYearsPlus: "3歳以上"
        }
    }

    var textureDescription: String {
        switch self {
        case .gokun: "なめらかなペースト状"
        case .mogumogu: "舌でつぶせる軟らかさ（約3mm）"
        case .kamikamu: "歯ぐきでつぶせる軟らかさ（約5〜7mm）"
        case .pakupaku: "歯ぐきで噛める軟らかさ（約1cm）"
        case .oneAndHalf: "奥歯で噛める軟らかさ"
        case .twoYears: "ほぼ大人と同じ形状"
        case .threeYearsPlus: "大人と同じ形状"
        }
    }

    /// サイズの目安（mm）。ペースト状・大人と同じはnil
    var approximateSizeMM: Int? {
        switch self {
        case .gokun: nil
        case .mogumogu: 3
        case .kamikamu: 7
        case .pakupaku: 10
        case .oneAndHalf: 15
        case .twoYears: 20
        case .threeYearsPlus: nil
        }
    }

    var porridgeRatio: String {
        switch self {
        case .gokun: "10倍粥"
        case .mogumogu: "7倍粥"
        case .kamikamu: "5倍粥"
        case .pakupaku: "軟飯"
        case .oneAndHalf: "普通のごはん"
        case .twoYears: "普通のごはん"
        case .threeYearsPlus: "普通のごはん"
        }
    }

    var colorName: String {
        switch self {
        case .gokun: "StageGokun"
        case .mogumogu: "StageMogumogu"
        case .kamikamu: "StageKamikamu"
        case .pakupaku: "StagePakupaku"
        case .oneAndHalf: "StageOneAndHalf"
        case .twoYears: "StageTwoYears"
        case .threeYearsPlus: "StageThreePlus"
        }
    }

    var icon: String {
        switch self {
        case .gokun: "drop.fill"
        case .mogumogu: "circle.fill"
        case .kamikamu: "square.fill"
        case .pakupaku: "star.fill"
        case .oneAndHalf: "heart.fill"
        case .twoYears: "leaf.fill"
        case .threeYearsPlus: "sun.max.fill"
        }
    }

    /// クラシル検索用キーワード
    var searchKeyword: String {
        switch self {
        case .gokun: "離乳食初期"
        case .mogumogu: "離乳食中期"
        case .kamikamu: "離乳食後期"
        case .pakupaku: "離乳食完了期"
        case .oneAndHalf: "幼児食 1歳半"
        case .twoYears: "幼児食 2歳"
        case .threeYearsPlus: "幼児食 3歳"
        }
    }

    var feedingFrequency: String {
        switch self {
        case .gokun: "1日1回"
        case .mogumogu: "1日2回"
        case .kamikamu: "1日3回"
        case .pakupaku: "1日3回（大人と同じリズム）"
        case .oneAndHalf: "1日3回＋おやつ"
        case .twoYears: "1日3回＋おやつ"
        case .threeYearsPlus: "1日3回＋おやつ"
        }
    }
}

enum IngredientCategory: String, CaseIterable, Codable, Identifiable {
    case grain = "grain"
    case vegetable = "vegetable"
    case fruit = "fruit"
    case protein = "protein"
    case dairy = "dairy"
    case fish = "fish"
    case seaweed = "seaweed"
    case seasoning = "seasoning"
    case other = "other"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .grain: "穀物"
        case .vegetable: "野菜"
        case .fruit: "果物"
        case .protein: "たんぱく質"
        case .dairy: "乳製品"
        case .fish: "魚・魚介"
        case .seaweed: "海藻"
        case .seasoning: "調味料"
        case .other: "その他"
        }
    }

    var icon: String {
        switch self {
        case .grain: "🌾"
        case .vegetable: "🥦"
        case .fruit: "🍎"
        case .protein: "🥚"
        case .dairy: "🧀"
        case .fish: "🐟"
        case .seaweed: "🌿"
        case .seasoning: "🧂"
        case .other: "🍽️"
        }
    }
}

enum SafetyLevel: String, Codable {
    case ok = "ok"
    case caution = "caution"
    case prohibited = "prohibited"

    var displayName: String {
        switch self {
        case .ok: "OK"
        case .caution: "注意"
        case .prohibited: "NG"
        }
    }

    var icon: String {
        switch self {
        case .ok: "checkmark.circle.fill"
        case .caution: "exclamationmark.triangle.fill"
        case .prohibited: "xmark.circle.fill"
        }
    }
}

enum Difficulty: String, CaseIterable, Codable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"

    var displayName: String {
        switch self {
        case .easy: "かんたん"
        case .medium: "ふつう"
        case .hard: "手間あり"
        }
    }
}

enum CookingTime: String, CaseIterable, Codable {
    case quick = "quick"
    case medium = "medium"
    case slow = "slow"

    var displayName: String {
        switch self {
        case .quick: "〜10分"
        case .medium: "〜20分"
        case .slow: "20分以上"
        }
    }

    static func from(minutes: Int) -> CookingTime {
        switch minutes {
        case ..<11: .quick
        case ..<21: .medium
        default: .slow
        }
    }
}
