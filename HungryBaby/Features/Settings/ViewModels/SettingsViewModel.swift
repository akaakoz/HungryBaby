import Foundation
import Observation

@Observable
@MainActor
final class SettingsViewModel {
    var birthDate: Date = .now
    var nickname: String = ""
    var isEditing: Bool = false

    func load(from service: BabyProfileService) {
        if let profile = service.currentProfile {
            birthDate = profile.birthDate
            nickname = profile.nickname
        }
    }

    func save(using service: BabyProfileService) {
        service.save(birthDate: birthDate, nickname: nickname)
        isEditing = false
    }
}
