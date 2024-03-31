import UIKit

extension String {
    func createDouble() -> Double {
        let string = self.replacingOccurrences(of: " ", with: "")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter.number(from: string)?.doubleValue ?? 0.0
    }
    
    func makeAttributed(icon: UIImage, tint: UIColor = .flcNumberTextFieldLabel, size: (x: Int, y: Int, w: Int, h: Int), placeIcon: FLCTextViewLabelImagePlacing) -> NSMutableAttributedString {
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
    
    func formatAsSymbol() -> String { FLCCurrency(rawValue: self)?.symbol ?? "" }
    func getFirstCharacters(_ amount: Int) -> String { String(self.prefix(amount)) }
    func removeFirstCharacters(_ amount: Int) -> String { String(self.dropFirst(amount)) }
}
