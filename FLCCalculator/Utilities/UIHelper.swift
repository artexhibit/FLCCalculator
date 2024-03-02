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
    
    static func setEnabledAll(buttons: [FLCListPickerButton]) {
        buttons.forEach {
            $0.setEnabled()
            $0.showsMenuAsPrimaryAction = true
        }
    }
    
    static func setDeliveryTypeData(for destButton: FLCListPickerButton, basedOn button: FLCListPickerButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            guard let pickedCountryString = button.titleLabel?.text else { return }
            let pickedOption = FLCCountryOptions(rawValue: pickedCountryString)
            
            switch pickedOption {
            case .china:
                destButton.menu = destButton.configureUIMenu(with: CalculationData.chinaDeliveryTypes)
            case .turkey:
                destButton.menu = destButton.configureUIMenu(with: CalculationData.turkeyDeliveryTypes)
            case nil:
                return
            }
        }
    }
    
    static func checkIfTitleIsEmpty(in button: FLCListPickerButton) -> Bool {
        return button.titleLabel?.text == nil ? true : false
    }
}
