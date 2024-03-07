import UIKit

struct CalculationUIHelper {
    static func setDeliveryTypeData(for destButton: FLCListPickerButton, basedOn button: FLCListPickerButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            guard let pickedCountryString = button.titleLabel?.text else { return }
            let pickedOption = FLCCountryOption(rawValue: pickedCountryString)
            
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
    
    static func presentListPickerVC(from button: FLCListPickerButton, listener: FLCCalculationView, type: FLCListPickerContentType, in viewController: UIViewController) {
        let listPickerVC = FLCListPickerVC(from: button, type: type)
        listPickerVC.delegate = listener as? any FLCListPickerDelegate
        let navController = UINavigationController(rootViewController: listPickerVC)
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
    
    static func setupDestinationButtonTitle(_ button: FLCListPickerButton, basedOn deliveryTypeButton: FLCListPickerButton, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            guard let text = deliveryTypeButton.titleLabel?.text else {
                completion(false)
                return
            }
            
            if text.contains(CalculationData.russianWarehouseCity) {
                button.smallLabelView.moveUpSmallLabel()
                button.setTitle(CalculationData.russianWarehouseCity, for: .normal)
                completion(true)
            }
            button.setEnabled()
            completion(false)
        }
    }
}
