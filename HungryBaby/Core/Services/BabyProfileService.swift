import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class BabyProfileService {
    private let container: ModelContainer
    private(set) var currentProfile: BabyProfile?

    init(container: ModelContainer) {
        self.container = container
        load()
    }

    var currentStage: BabyStage? {
        guard let profile = currentProfile else { return nil }
        return StageCalculator.stage(for: profile.birthDate)
    }

    func save(birthDate: Date, nickname: String) {
        let context = container.mainContext
        if let existing = currentProfile {
            existing.birthDate = birthDate
            existing.nickname = nickname
        } else {
            let profile = BabyProfile(birthDate: birthDate, nickname: nickname)
            context.insert(profile)
            currentProfile = profile
        }
        try? context.save()
    }

    private func load() {
        let context = container.mainContext
        let descriptor = FetchDescriptor<BabyProfile>()
        currentProfile = try? context.fetch(descriptor).first
    }
}
