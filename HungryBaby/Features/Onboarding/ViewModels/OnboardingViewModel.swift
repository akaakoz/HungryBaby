import Foundation
import Observation

@Observable
@MainActor
final class OnboardingViewModel {
    var birthDate: Date = Calendar.current.date(byAdding: .month, value: -5, to: .now)!
    var nickname: String = ""
    var isCompleted: Bool = false

    func complete(using service: BabyProfileService) {
        service.save(birthDate: birthDate, nickname: nickname)
        isCompleted = true
    }
}
