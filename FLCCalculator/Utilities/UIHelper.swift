import UIKit

struct UIHelper {
    static func checkIfFilledAll(textFields: [FLCNumberTextField]) -> Bool {
        textFields.forEach { $0.text?.isEmpty ?? true ? $0.switchToRedColors() : nil }
        return textFields.allSatisfy { !($0.text?.isEmpty ?? true) }
    }
    
    static func checkIfFilledAll(buttons: [FLCListPickerButton]) -> Bool {
        buttons.forEach { $0.titleLabel?.text?.isEmpty ?? true ? $0.switchToRedColors() : nil }
        return buttons.allSatisfy { !($0.titleLabel?.text?.isEmpty ?? true) }
    }
}
