import UIKit

struct TextFieldManager {
    static let placeholderValue = "0\(NumberFormatter().decimalSeparator ?? "")00"
    
    static func createFormattedNumber(from string: String, using formatter: NumberFormatter) -> String {
        var newFormatter = formatter
        
        let completeString = string.replacingOccurrences(of: newFormatter.groupingSeparator, with: "").replacingOccurrences(of: ",", with: ".")
        
        if completeString.contains(".") { newFormatter = NumberFormatter.getFLCNumberFormatter() }
        let formattedNumber = newFormatter.string(from: NSNumber(value: Double(completeString) ?? 0)) ?? ""
        return formattedNumber
    }
    
    static func calculateCursorOffset(range: NSRange, text: String, string: String, formatter: NumberFormatter, number: String) -> Int {
        var cursorOffset = range.location + string.count
        let oldNumberOfGroupingSeparators = text.filter { $0 == formatter.groupingSeparator.first }.count
        let newNumberOfGroupingSeparators = number.filter { $0 == formatter.groupingSeparator.first }.count
        cursorOffset += (newNumberOfGroupingSeparators - oldNumberOfGroupingSeparators)
        return cursorOffset
    }
    
    static func replaceFirstCharacter(with string: String, in textField: UITextField, and text: String) {
        textField.text = string + text.dropFirst()
        textField.moveCursorAfterTypedNumber()
    }
    
    static func removeCharacterBefore(positon: Int, and textField: UITextField, inText text: String, withDecimalSeparator decimalSeparator: String, using formatter: NumberFormatter) -> Bool {
        guard positon > 0, positon <= text.count else { return false }
        
        guard let charBeforeSeparator = Range(NSRange(location: positon - 1, length: 1), in: text) else { return false }
        let newValue = text.replacingCharacters(in: charBeforeSeparator, with: "")
        textField.text = createFormattedNumber(from: newValue, using: formatter)
        
        let cursorPosition = textField.text == placeholderValue ? 2 : 3
        textField.moveCursorTo(position: textField.getCursorPosition() - cursorPosition)
        
        if textField.text?.firstIndex(of: Character(decimalSeparator)) == textField.text?.startIndex {
            textField.text = placeholderValue
            textField.moveCursorTo(position: positon)
        }
        return false
    }
    
    static func moveCursorToDecimals(in textField: UITextField, withText text: String, decimalSeparator: String, separatorPositon: Int) -> Bool {
        if text.contains(decimalSeparator) {
            if textField.getCursorPosition() > separatorPositon { return false }
            textField.moveCursorTo(position: separatorPositon + 1)
        } else {
            textField.text = text + "\(decimalSeparator)00"
            textField.moveCursorTo(position: separatorPositon + 1)
        }
        return false
    }
    
    static func formatPhoneNumber(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = "+7 "
        var index = numbers.startIndex
        
        if index < numbers.endIndex && numbers[index] == "7" { index = numbers.index(after: index) }
        
        for char in mask.dropFirst(3) where index < numbers.endIndex {
            if char == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
}
