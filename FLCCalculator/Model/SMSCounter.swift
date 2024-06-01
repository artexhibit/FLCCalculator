import Foundation

struct SMSCounter: Codable {
    var lastSentSMSDate: Date?
    var alreadySentSMSes: Int = 0
}

extension SMSCounter: UserDefaultsStorable { static var userDefaultsKey: String { Keys.smsCounter } }
