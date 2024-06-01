import Foundation

struct SMSManager {
    
    private static let oneHourInMinutes: TimeInterval = 60
    private static let minimumUpdateTimeToSendSMSAgain: TimeInterval = 2 * oneHourInMinutes * oneHourInMinutes
    private static let maximumAmountOfSMS = 3
    private static var timer: Timer?
    
    static var smsCounter: SMSCounter {
        get {
            guard let counter: SMSCounter = UserDefaultsPercistenceManager.retrieveItemFromUserDefaults() else { return SMSCounter() }
            return counter
        }
        set {
            _ = UserDefaultsPercistenceManager.updateItemInUserDefaults(item: newValue)
        }
    }
    
    static func resetSMSCounter() {
        var counter = smsCounter
        counter.alreadySentSMSes = 0
        counter.lastSentSMSDate = nil
        smsCounter = counter
    }
    
    static func increaseSMSCounter() {
        var counter = smsCounter
        counter.alreadySentSMSes += 1
        counter.lastSentSMSDate = Date()
        smsCounter = counter
    }
    
    static func canSendSMS() -> Bool {
        let counter = smsCounter
        if counter.alreadySentSMSes < maximumAmountOfSMS { return true }
        
        guard let lastSentSMSDate = counter.lastSentSMSDate else { return false }
        let timeInterval = Date().timeIntervalSince(lastSentSMSDate)
        
        if timeInterval >= minimumUpdateTimeToSendSMSAgain {
            resetSMSCounter()
            return true
        }
        return false
    }
    
    static func timeUntilNextSMS() -> String {
        let counter = smsCounter
        if counter.alreadySentSMSes < maximumAmountOfSMS { return "" }
        
        guard let lastSentSMSDate = counter.lastSentSMSDate else { return "" }
        let timeInterval = Date().timeIntervalSince(lastSentSMSDate)
        
        if timeInterval < minimumUpdateTimeToSendSMSAgain {
            let totalLeftTime = minimumUpdateTimeToSendSMSAgain - timeInterval
            return "\(Int(totalLeftTime) / 3600) ч. \((Int(totalLeftTime) % 3600) / Int(oneHourInMinutes)) мин."
        }
        return ""
    }
    
    static func checkAndResetSMSCounter() { if canSendSMS() { resetSMSCounter() } }
    static func startTimer() { timer = Timer.scheduledTimer(withTimeInterval: minimumUpdateTimeToSendSMSAgain / oneHourInMinutes, repeats: true) { _ in checkAndResetSMSCounter() } }
    
    static func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
