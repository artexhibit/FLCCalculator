import UIKit

struct CalculationUIHelper {
    private static var previousTitle = ""
    
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
    
    static func enableAll(buttons: [FLCListPickerButton]) {
        buttons.forEach {
            $0.setEnabled()
            $0.resetState()
        }
    }
    
    static func getItems<T: Hashable>(basedOn pickedCountry: FLCCountryOption, for button: FLCListPickerButton) -> [T] {
        
        switch pickedCountry {
        case .china:
            if button.smallLabelView.smallLabel.text == "Условия Поставки" {
                return CalculationData.chinaDeliveryTypes as? [T] ?? []
            } else {
                return CalculationData.chinaLocations as? [T] ?? []
            }
        case .turkey:
            if button.smallLabelView.smallLabel.text == "Условия Поставки" {
                return CalculationData.turkeyDeliveryTypes as? [T] ?? []
            } else {
                return CalculationData.turkeyLocations as? [T] ?? []
            }
        }
    }
    
    static func presentListPickerVC(from button: FLCListPickerButton, listener: FLCCalculationView, type: FLCListPickerContentType, in viewController: UIViewController) {
        let listPickerVC = FLCListPickerVC(from: button, type: type)
        listPickerVC.delegate = listener as? any FLCPickerDelegate
        let navController = UINavigationController(rootViewController: listPickerVC)
        viewController.present(navController, animated: true)
    }
    
    static func presentSheetPickerVC(items: [FLCPickerItem], triggerButton: FLCListPickerButton, listener: FLCCalculationView, in viewController: UIViewController, size: CGFloat = 0.5) {
        let sheetPickerVC = FLCSheetPickerVC(items: items, triggerButton: triggerButton)
        sheetPickerVC.delegate = listener as? FLCPickerDelegate
        let navController = UINavigationController(rootViewController: sheetPickerVC)
        navController.sheetPresentationController?.getFLCSheetPresentationController(in: viewController.view, size: size)
        viewController.present(navController, animated: true)
    }
    
    static func confirmDataIsValid(in view: FLCCargoParametersView) -> Bool {
        if checkIfFilledAll(textFields: view.flcTextFields) && checkIfFilledAll(buttons: view.flcListPickerButtons)  {
            return true
        } else {
            makeRedAll(textFields: view.flcTextFields)
            makeRedAll(buttons: view.flcListPickerButtons)
            HapticManager.addErrorHaptic()
            FLCPopupView.showOnMainThread(systemImage: "text.insert", title: "Сперва заполните все поля")
            return false
        }
    }
    
    static func setupDestinationButtonTitle(_ button: FLCListPickerButton, basedOn deliveryTypeButton: FLCListPickerButton) {
        guard let text = deliveryTypeButton.titleLabel?.text else { return }
      
        if text.contains(CalculationData.russianWarehouseCity) {
            button.smallLabelView.moveUpSmallLabel()
            button.setTitle(CalculationData.russianWarehouseCity, for: .normal)
            button.titleLabel?.text = CalculationData.russianWarehouseCity
        } else {
            button.resetState()
        }
        button.setEnabled()
    }
    
    static func adjustProgressView(basedOn destButton: FLCListPickerButton, and deliveryButton: FLCListPickerButton) -> ProgressViewOption? {
        let destTitle = destButton.titleLabel?.text ?? ""
        let deliveryTitle = deliveryButton.titleLabel?.text ?? ""
        
        if previousTitle.contains(CalculationData.russianWarehouseCity) && deliveryTitle.contains(CalculationData.russianWarehouseCity) { return nil }
        
        if deliveryTitle.contains(CalculationData.russianWarehouseCity) {
            previousTitle = deliveryTitle
            return destTitle.contains(CalculationData.russianWarehouseCity) ? .increase : .decrease
        } else {
            if previousTitle.contains(CalculationData.russianWarehouseCity) && destTitle == "" {
                previousTitle = deliveryTitle
                return .decrease
            }
        }
        return nil
    }
}
