import UIKit

struct CalculationUIHelper {
    private static var previousTitle = ""
    
    static func enableAll(buttons: [FLCListPickerButton]) {
        buttons.forEach {
            $0.setEnabled()
            $0.resetState()
        }
    }
    
    static func getItems(basedOn button: FLCListPickerButton) -> [FLCPickerItem] {
            guard let pickedCountryString = button.titleLabel?.text else { return [] }
            let pickedOption = FLCCountryOption(rawValue: pickedCountryString)
            
            switch pickedOption {
            case .china:
                return CalculationData.chinaDeliveryTypes
            case .turkey:
                return CalculationData.turkeyDeliveryTypes
            case nil:
                return []
            }
    }
    
    static func presentListPickerVC(from button: FLCListPickerButton, listener: FLCCalculationView, type: FLCListPickerContentType, in viewController: UIViewController) {
        let listPickerVC = FLCListPickerVC(from: button, type: type)
        listPickerVC.delegate = listener as? any FLCPickerDelegate
        let navController = UINavigationController(rootViewController: listPickerVC)
        viewController.present(navController, animated: true)
    }
    
    static func presentSheetPickerVC(items: [FLCPickerItem], triggerButton: FLCListPickerButton, listener: FLCCalculationView, in viewController: UIViewController) {
        let sheetPickerVC = FLCSheetPickerVC(items: items, triggerButton: triggerButton)
        sheetPickerVC.delegate = listener as? FLCPickerDelegate
        let navController = UINavigationController(rootViewController: sheetPickerVC)
        guard let sheet = navController.sheetPresentationController else { return }
        sheet.detents = [.medium()]
        viewController.present(navController, animated: true)
    }
    
    static func confirmDataIsValid(in view: FLCCargoParametersView) -> Bool {
        if UIHelper.checkIfFilledAll(textFields: view.flcTextFields) && UIHelper.checkIfFilledAll(buttons: view.flcListPickerButtons)  {
            return true
        } else {
            UIHelper.makeRedAll(textFields: view.flcTextFields)
            UIHelper.makeRedAll(buttons: view.flcListPickerButtons)
            HapticManager.addErrorHaptic()
            FLCPopupView.showOnMainThread(systemImage: "text.insert", title: "Сперва заполните все поля")
            return false
        }
    }
    
    static func confirmCountryIsPicked(in view: FLCTransportParametersView, completion: @escaping (FLCCountryOption?) -> Void) {
        guard view.countryPickerButton.titleLabel?.text == nil else {
            let pickedCountry = FLCCountryOption(rawValue: view.countryPickerButton.titleLabel?.text ?? "")
            completion(pickedCountry)
            return
        }
        FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите страну отправления")
        completion(nil)
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
