import SwiftUI

extension Color {
    static func stage(_ stage: BabyStage) -> Color {
        Color(stage.colorName)
    }
}

extension BabyStage {
    var color: Color { .stage(self) }

    /// フォールバック用のシステムカラー（Assets未設定時）
    var systemColor: Color {
        switch self {
        case .gokun: .orange
        case .mogumogu: .green
        case .kamikamu: .blue
        case .pakupaku: .purple
        }
    }
}
