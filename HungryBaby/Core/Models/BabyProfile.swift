import Foundation
import SwiftData

@Model
final class BabyProfile {
    var birthDate: Date
    var nickname: String

    init(birthDate: Date, nickname: String = "") {
        self.birthDate = birthDate
        self.nickname = nickname
    }
}
