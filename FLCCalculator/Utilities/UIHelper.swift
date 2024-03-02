import UIKit

struct UIHelper {
    static func checkIfFilledAll(textFields: [FLCNumberTextField]) -> Bool {
        textFields.allSatisfy { !($0.text?.isEmpty ?? true) }
    }
    
    static func makeRedAll(textFields: [FLCNumberTextField]) {
        textFields.forEach { $0.text?.isEmpty ?? true ? $0.switchToRedColors() : nil }
    }
    
    static func checkIfFilledAll(buttons: [FLCListPickerButton]) -> Bool {
        buttons.allSatisfy { !($0.titleLabel?.text?.isEmpty ?? true) }
    }
    
    static func makeRedAll(buttons: [FLCListPickerButton]) {
        buttons.forEach { $0.titleLabel?.text?.isEmpty ?? true ? $0.switchToRedColors() : nil }
    }
    
    static func addProgressTo(_ progressView: UIProgressView) {
        let newProgress = progressView.progress + 0.1
        progressView.setProgress(newProgress, animated: true)
    }
}
