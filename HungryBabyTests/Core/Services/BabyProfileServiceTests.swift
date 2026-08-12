import Testing
import Foundation
import SwiftData
@testable import HungryBaby

@Suite("BabyProfileService")
@MainActor
struct BabyProfileServiceTests {

    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([
            BabyProfile.self,
            Ingredient.self,
            IngredientSafety.self,
            Recipe.self,
            RecipeIngredient.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: config)
    }

    @Test("初期状態でcurrentProfileはnil")
    func testInitialProfileIsNil() throws {
        let container = try makeContainer()
        let service = BabyProfileService(container: container)
        #expect(service.currentProfile == nil)
    }

    @Test("初期状態でcurrentStageはnil")
    func testInitialStageIsNil() throws {
        let container = try makeContainer()
        let service = BabyProfileService(container: container)
        #expect(service.currentStage == nil)
    }

    @Test("プロフィールを保存するとcurrentProfileが更新される")
    func testSaveUpdatesCurrentProfile() throws {
        let container = try makeContainer()
        let service = BabyProfileService(container: container)
        let birthDate = Calendar.current.date(byAdding: .month, value: -7, to: .now)!

        service.save(birthDate: birthDate, nickname: "はなちゃん")

        #expect(service.currentProfile != nil)
        #expect(service.currentProfile?.nickname == "はなちゃん")
    }

    @Test("7ヶ月の生年月日からモグモグ期が返る")
    func testStageFromBirthDate() throws {
        let container = try makeContainer()
        let service = BabyProfileService(container: container)
        let birthDate = Calendar.current.date(byAdding: .month, value: -7, to: .now)!

        service.save(birthDate: birthDate, nickname: "テスト")

        #expect(service.currentStage == .mogumogu)
    }

    @Test("プロフィールを更新すると既存レコードが上書きされる")
    func testUpdateDoesNotCreateDuplicate() throws {
        let container = try makeContainer()
        let service = BabyProfileService(container: container)
        let birthDate1 = Calendar.current.date(byAdding: .month, value: -7, to: .now)!
        let birthDate2 = Calendar.current.date(byAdding: .month, value: -10, to: .now)!

        service.save(birthDate: birthDate1, nickname: "first")
        service.save(birthDate: birthDate2, nickname: "second")

        let context = container.mainContext
        let count = try context.fetchCount(FetchDescriptor<BabyProfile>())
        #expect(count == 1)
        #expect(service.currentProfile?.nickname == "second")
        #expect(service.currentStage == .kamikamu)
    }
}
