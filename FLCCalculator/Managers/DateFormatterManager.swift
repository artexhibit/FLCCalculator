import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    let iso8601Formatter: ISO8601DateFormatter
    var dateFormatter: DateFormatter
    
    private init() {
        iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    }
}
