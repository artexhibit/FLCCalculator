import UIKit

struct TextFieldManager {
    static let placeholderValue = "0\(NumberFormatter.localeDecimalSeparator)00"
    
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
    
    static func formatBirthdayDate(with mask: String, date: String) -> String {
        let numbers = date.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for char in mask where index < numbers.endIndex {
            if char == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }
        
        if date.last == "." {
            let components = result.split(separator: ".")
            var formattedComponents = [String]()
            
            for (idx, component) in components.enumerated() {
                idx < 2 && component.count == 1 ? formattedComponents.append("0" + component) : formattedComponents.append(String(component))
            }
            result = formattedComponents.joined(separator: ".")
            result.append(".")
        }
        return result
    }
    
    static func isValid(_ type: FLCTextFieldType, _ text: String) -> Bool {
        var dataRegEx = ""
        
        switch type {
        case .email: dataRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .phone: dataRegEx = "^(?:\\D*\\d){11}\\D*$"
        case .username: dataRegEx = "^[\\p{L}0-9 ]+$"
        case .birthdate: dataRegEx = "^(0[1-9]|[12][0-9]|3[01])\\.(0[1-9]|1[0-2])\\.(19[0-9]{2}|20[0-2][0-4])$"
        case .companyName: dataRegEx = "^[\\p{L} ]+$"
        case .taxPayerID: dataRegEx = "^[0-9]{12}$"
        case .customsDeclarationsAmount: dataRegEx = "^[0-9]+$"
        }
        let dataPred = NSPredicate(format: "SELF MATCHES %@", dataRegEx)
        return dataPred.evaluate(with: text)
    }
    
    static func goToNextTextField(activeTF: UITextField, allTFs: [UITextField]) {
        guard let targetTextFieldIndex = allTFs.firstIndex(where: { $0 == activeTF }), targetTextFieldIndex < allTFs.count - 1 else { return }
        _ = allTFs[targetTextFieldIndex + 1].becomeFirstResponder()
    }
    
    static func goToPreviousTextField(activeTF: UITextField, allTFs: [UITextField]) {
        guard let targetTextFieldIndex = allTFs.firstIndex(where: { $0 == activeTF }), targetTextFieldIndex > 0 else { return }
        _ = allTFs[targetTextFieldIndex - 1].becomeFirstResponder()
    }
    
    static func managePhoneTextFieldInput(textField: UITextField, range: NSRange, string: String) {
        guard let text = textField.text else { return }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        let cursorPosition = textField.getCursorPosition()
        let formattedText = formatPhoneNumber(with: "+7 (XXX) XXX-XX-XX", phone: newString)
        
        textField.text = formattedText
        
        let newCursorPosition = string.isEmpty ? max(2, cursorPosition - 1) : cursorPosition + (formattedText.count - text.count)
        textField.moveCursorTo(position: newCursorPosition)
    }
    
    static func manageEmailTextFieldInput(textField: UITextField, range: NSRange, string: String) {
        guard let text = textField.text else { return }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        let cursorPosition = string.isEmpty ? range.location : range.location + string.count
        
        textField.text = newString
        textField.moveCursorTo(position: cursorPosition)
    }
    
    static func manageNameTextFieldInput(textField: UITextField, range: NSRange, string: String) {
        guard let text = textField.text else { return }
        let allowedCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: " "))
        
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil { return }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        
        var modifiedString = ""
        var previousCharacter: Character?
        
        for char in newString {
            if let previous = previousCharacter, previous == " " && char.isLowercase {
                modifiedString.append(char.uppercased())
            } else {
                modifiedString.append(char)
            }
            previousCharacter = char
        }
        let cursorPosition = string.isEmpty ? range.location : range.location + string.count
        
        textField.text = modifiedString
        textField.moveCursorTo(position: cursorPosition)
    }
    
    static func manageBirthdayTextFieldInput(textField: UITextField, range: NSRange, string: String) {
        guard let text = textField.text else { return }
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ",."))
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil { return }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string).replacingOccurrences(of: ",", with: ".")
        let cursorPosition = textField.getCursorPosition()
        let formattedText = formatBirthdayDate(with: "XX.XX.XXXX", date: newString)
        
        textField.text = formattedText
        textField.moveCursorTo(position: cursorPosition + (formattedText.count - text.count))
    }
    
    static func manageCompanyNameTextFieldInput(textField: UITextField, range: NSRange, string: String) {
        guard let text = textField.text else { return }
        let allowedCharacters = CharacterSet.letters.union(CharacterSet.decimalDigits).union(CharacterSet(charactersIn: " -"))
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil { return }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        let cursorPosition = string.isEmpty ? range.location : range.location + string.count
        
        textField.text = newString
        textField.moveCursorTo(position: cursorPosition)
    }
    
    static func manageDigitsTextFieldInput(textField: UITextField, range: NSRange, string: String, maxDigits: Int) {
        guard let text = textField.text else { return }
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil { return }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        if newString.count > maxDigits { return }
        let cursorPosition = string.isEmpty ? range.location : range.location + string.count
        
        textField.text = newString
        textField.moveCursorTo(position: cursorPosition)
    }
    
    static func returnTextFieldsLabelToIdentity(textField: UITextField) {
        guard let numberTextField = textField as? FLCNumberTextField else { return }
        guard let text = numberTextField.text else { return }
        numberTextField.placeholder = ""
        if text.isEmpty { numberTextField.returnToIdentity() }
    }
}
