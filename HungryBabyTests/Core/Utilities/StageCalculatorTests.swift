import Testing
import Foundation
@testable import HungryBaby

@Suite("StageCalculator")
struct StageCalculatorTests {

    private func date(monthsAgo months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: -months, to: .now)!
    }

    @Test("5ヶ月でゴックン期")
    func testFiveMonthsIsGokun() {
        let result = StageCalculator.stage(for: date(monthsAgo: 5))
        #expect(result == .gokun)
    }

    @Test("6ヶ月でゴックン期")
    func testSixMonthsIsGokun() {
        let result = StageCalculator.stage(for: date(monthsAgo: 6))
        #expect(result == .gokun)
    }

    @Test("7ヶ月でモグモグ期")
    func testSevenMonthsIsMogumogu() {
        let result = StageCalculator.stage(for: date(monthsAgo: 7))
        #expect(result == .mogumogu)
    }

    @Test("8ヶ月でモグモグ期")
    func testEightMonthsIsMogumogu() {
        let result = StageCalculator.stage(for: date(monthsAgo: 8))
        #expect(result == .mogumogu)
    }

    @Test("9ヶ月でカミカミ期")
    func testNineMonthsIsKamikamu() {
        let result = StageCalculator.stage(for: date(monthsAgo: 9))
        #expect(result == .kamikamu)
    }

    @Test("11ヶ月でカミカミ期")
    func testElevenMonthsIsKamikamu() {
        let result = StageCalculator.stage(for: date(monthsAgo: 11))
        #expect(result == .kamikamu)
    }

    @Test("12ヶ月でパクパク期")
    func testTwelveMonthsIsPakupaku() {
        let result = StageCalculator.stage(for: date(monthsAgo: 12))
        #expect(result == .pakupaku)
    }

    @Test("18ヶ月でパクパク期")
    func testEighteenMonthsIsPakupaku() {
        let result = StageCalculator.stage(for: date(monthsAgo: 18))
        #expect(result == .pakupaku)
    }

    @Test("4ヶ月はnilを返す（離乳食開始前）")
    func testFourMonthsIsNil() {
        let result = StageCalculator.stage(for: date(monthsAgo: 4))
        #expect(result == nil)
    }

    @Test("0ヶ月はnilを返す")
    func testZeroMonthsIsNil() {
        let result = StageCalculator.stage(for: .now)
        #expect(result == nil)
    }

    @Test("基準日を指定できる")
    func testCustomReferenceDate() {
        let birthDate = Calendar.current.date(byAdding: .month, value: -7, to: .now)!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        // 7ヶ月前 → 昨日を基準にしても7ヶ月
        let result = StageCalculator.stage(for: birthDate, at: yesterday)
        #expect(result == .mogumogu)
    }
}
