import Foundation

enum StageCalculator {
    /// 生年月日と基準日から離乳食ステージを計算する。
    /// 5ヶ月未満はnilを返す（離乳食開始前）。
    static func stage(for birthDate: Date, at referenceDate: Date = .now) -> BabyStage? {
        let months = Calendar.current.dateComponents([.month], from: birthDate, to: referenceDate).month ?? 0
        switch months {
        case 5...6: return .gokun
        case 7...8: return .mogumogu
        case 9...11: return .kamikamu
        case 12...18: return .pakupaku
        case 19...23: return .oneAndHalf
        case 24...35: return .twoYears
        case 36...: return .threeYearsPlus
        default: return nil
        }
    }
}
