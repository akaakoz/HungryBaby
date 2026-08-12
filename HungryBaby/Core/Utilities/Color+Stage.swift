import SwiftUI

// MARK: - App Theme Colors (babyFood Flutter app の #FF8A65 基調に合わせた配色)

extension Color {
    /// アプリのプライマリカラー（#FF8A65 Warm Deep Orange）
    static let appPrimary = Color(red: 1.0, green: 0.541, blue: 0.396)
    /// プライマリの淡い背景用
    static let appPrimaryLight = Color(red: 1.0, green: 0.541, blue: 0.396).opacity(0.12)
    /// 安全（OK）表示用グリーン
    static let appSafe = Color(red: 0.298, green: 0.686, blue: 0.314)
    /// 注意表示用オレンジ
    static let appCaution = Color(red: 1.0, green: 0.596, blue: 0.0)
    /// 禁止表示用レッド
    static let appDanger = Color(red: 0.898, green: 0.224, blue: 0.208)
    /// 画面背景用のやわらかいベージュ
    static let appBackground = Color(red: 0.996, green: 0.976, blue: 0.957)
    /// カード背景
    static let appCardBackground = Color.white
}

// MARK: - Stage Colors

extension Color {
    static func stage(_ stage: BabyStage) -> Color {
        stage.systemColor
    }
}

extension BabyStage {
    var color: Color { .stage(self) }

    /// babyFood Flutter app と雰囲気を合わせたパステル系カラー
    var systemColor: Color {
        switch self {
        case .gokun:    Color(red: 1.0, green: 0.596, blue: 0.396)    // やわらかいオレンジ
        case .mogumogu: Color(red: 0.506, green: 0.780, blue: 0.518)  // やさしいグリーン
        case .kamikamu: Color(red: 0.506, green: 0.694, blue: 0.898)  // 穏やかなブルー
        case .pakupaku: Color(red: 0.733, green: 0.557, blue: 0.827)  // やわらかいパープル
        }
    }

    /// ステージの淡い背景色
    var lightColor: Color {
        systemColor.opacity(0.12)
    }
}
