import Foundation

extension Date {
    func makeString(dateStyle: DateFormatter.Style? = nil, format: FLCDateFormat = .dotDMY) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let dateStyle = dateStyle {
            formatter.dateStyle = dateStyle
        }
        return formatter.string(from: self)
    }
}
