import Foundation

extension Date {
    func makeString(dateStyle: DateFormatter.Style? = nil, format: FLCDateFormat = .dotDMY) -> String {
        DateFormatterManager.shared.dateFormatter.dateFormat = format.rawValue
        
        if let dateStyle = dateStyle { DateFormatterManager.shared.dateFormatter.dateStyle = dateStyle }
        return DateFormatterManager.shared.dateFormatter.string(from: self)
    }
}
