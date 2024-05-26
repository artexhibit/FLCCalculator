import UIKit

extension String {
    var flcWarehouseFromRusName: FLCWarehouse? { return FLCWarehouse.allCases.first(where: { $0.rusName == self }) }
    
    func createDouble(removeSymbols: Bool = false) -> Double {
        var string = self.replacingOccurrences(of: " ", with: "")
        if removeSymbols { string = string.removeCurrencySymbols() }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter.number(from: string)?.doubleValue ?? 0.0
    }
    
    func removeCurrencySymbols() -> String {
        return FLCCurrency.allCases.reduce(self) { result, currency in
            result.replacingOccurrences(of: currency.symbol, with: "")
        }
    }
    
    func makeAttributed(icon: UIImage, tint: UIColor = .flcCalculationResultCellSecondary, size: (x: Double, y: Double, w: Double, h: Double), placeIcon: FLCTextViewLabelImagePlacing) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let imageView = UIImageView(image: icon.withTintColor(tint).withRenderingMode(.alwaysTemplate))
        
        let icon = NSTextAttachment()
        icon.image = imageView.image
        icon.bounds = CGRect(x: size.x, y: size.y, width: size.w, height: size.h)
        
        let padding = NSTextAttachment()
        padding.image = UIImage()
        padding.bounds = CGRect(x: 0, y: 0, width: 5, height: 1)
        
        switch placeIcon {
        case .afterText:
            attributedString.append(NSAttributedString(string: self))
            attributedString.append(NSAttributedString(attachment: padding))
            attributedString.append(NSAttributedString(attachment: icon))
        case .beforeText:
            attributedString.append(NSAttributedString(attachment: icon))
            attributedString.append(NSAttributedString(attachment: padding))
            attributedString.append(NSAttributedString(string: self))
        }
        return attributedString
    }
    
    func createRange() -> ClosedRange<Double>? {
        let components = self.split(separator: "-")
        guard components.count == 2, let lowerBound = Double(components[0]), let upperBound = Double(components[1]) else { return nil }
        return lowerBound...upperBound
    }
    
    func createDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = dateFormatter.date(from: self) { return date }
        return nil
    }
    
    func extractCurrencySymbol() -> FLCCurrency? {
        for char in self {
            if let currency = FLCCurrency.allCases.first(where: { $0.symbol == String(char) }) {
                return currency
            }
        }
        return nil
    }
    
    func getDataInsideCharacters(char: String = "()") -> String? {
        let components = self.components(separatedBy: CharacterSet(charactersIn: char))
        guard components.count > 1 else { return nil }
        return components[1].trimmingCharacters(in: .whitespaces)
    }
    
    func getDataOutsideCharacters(char: String = "()") -> String? {
        let components = self.components(separatedBy: CharacterSet(charactersIn: char))
        guard components.count > 1 else { return nil }
        return components.first?.trimmingCharacters(in: .whitespaces)
    }
    
    func getDataBetweenCharacter(char: String = " ", returnFirstHalf: Bool = true) -> String? {
        let components = self.components(separatedBy: CharacterSet(charactersIn: char))
        guard components.count > 1 else { return nil }
        return returnFirstHalf ? components[0].trimmingCharacters(in: .whitespaces) : components[1].trimmingCharacters(in: .whitespaces)
    }
    
    func removeStringPart(_ part: String) -> String { self.replacingOccurrences(of: part, with: "").trimmingCharacters(in: .whitespacesAndNewlines) }
    func formatAsSymbol() -> String { FLCCurrency(rawValue: self)?.symbol ?? "" }
    func getFirstCharacters(_ amount: Int) -> String { String(self.prefix(amount)) }
    func getLastCharacters(_ amount: Int) -> String { String(self.suffix(amount)) }
    func removeFirstCharacters(_ amount: Int) -> String { String(self.dropFirst(amount)) }
    func removeLastCharacters(_ amount: Int) -> String { String(self.dropLast(amount)) }
    func extractDigits() -> String { self.filter { $0.isNumber } }
}
