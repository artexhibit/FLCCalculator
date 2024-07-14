import UIKit

extension String {
    var flcWarehouseFromRusName: FLCWarehouse? { return FLCWarehouse.allCases.first(where: { $0.rusName == self }) }
    
    func createDouble(removeSymbols: Bool = false) -> Double {
        var decimalSeparatorFound = false
        var string = self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\u{00A0}", with: "").replacingOccurrences(of: ",", with: ".")
        if removeSymbols { string = string.removeCurrencySymbols() }
        
        let stringWithoutGroupingSeparators = string.reversed().reduce("") { result, char -> String in
            if char == "." {
                if decimalSeparatorFound {
                    return result
                } else {
                    decimalSeparatorFound = true
                    return result + String(char)
                }
            } else {
                return result + String(char)
            }
        }
        string = String(stringWithoutGroupingSeparators.reversed())
        string = string.replacingOccurrences(of: ".", with: Locale.current.decimalSeparator ?? ".")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        
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
    
    func makeAttributed(text: String, attributes: [NSAttributedString.Key], linkValue: String = "", font: UIFont = UIFont()) -> NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: self)
        guard let range = self.range(of: text) else { return nil }
        let nsRange = NSRange(range, in: self)
        
        for attribute in attributes {
            switch attribute {
            case .underlineStyle:
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
            case .link:
                attributedString.addAttribute(.link, value: linkValue, range: nsRange)
            case .font:
                attributedString.addAttribute(.font, value: font, range: nsRange)
            default: break
            }
        }
        return attributedString
    }
    
    func createRange() -> ClosedRange<Double>? {
        let components = self.split(separator: "-")
        guard components.count == 2, let lowerBound = Double(components[0]), let upperBound = Double(components[1]) else { return nil }
        return lowerBound...upperBound
    }
    
    func createDate(format: FLCDateFormat) -> Date? {
        DateFormatterManager.shared.dateFormatter.dateFormat = format.rawValue
        if let date = DateFormatterManager.shared.dateFormatter.date(from: self) { return date }
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
    
    func formatNumbers(separator: String) -> String {
        let components = self.components(separatedBy: CharacterSet(charactersIn: separator))
        
        return components.map { component -> String in
            let currencySymbol = component.extractCurrencySymbol() ?? ""
            let modifiedComponent = component.createDouble(removeSymbols: true).formatAsNumber()
            return "\(modifiedComponent) \(currencySymbol)"
        }.joined(separator: " \(separator) ")
    }
    
    func getDataBetweenCharacter(char: String = " ", returnFirstHalf: Bool = true) -> String? {
        let components = self.components(separatedBy: CharacterSet(charactersIn: char))
        guard components.count > 1 else { return nil }
        return returnFirstHalf ? components[0].trimmingCharacters(in: .whitespaces) : components[1].trimmingCharacters(in: .whitespaces)
    }
    
    func removeStringPart(_ part: String) -> String { self.replacingOccurrences(of: part, with: "").trimmingCharacters(in: .whitespacesAndNewlines) }
    func formatAsSymbol() -> String { FLCCurrency(rawValue: self)?.symbol ?? "" }
    func extractCurrencySymbol() -> String? { self.first { FLCCurrency.symbols.contains(String($0)) }.map { String($0) } }
    func getFirstCharacters(_ amount: Int) -> String { String(self.prefix(amount)) }
    func getLastCharacters(_ amount: Int) -> String { String(self.suffix(amount)) }
    func removeFirstCharacters(_ amount: Int) -> String { String(self.dropFirst(amount)) }
    func removeLastCharacters(_ amount: Int) -> String { String(self.dropLast(amount)) }
    func extractDigits() -> String { self.filter { $0.isNumber } }
    func extractCharacters() -> String { self.filter { $0.isLetter } }
    func isContains(_ target: String) -> Bool { self.range(of: target) != nil }
}
