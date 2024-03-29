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
        buttons.allSatisfy { !($0.showingTitle.isEmpty) }
    }
    
    static func makeRedAll(buttons: [FLCListPickerButton]) {
        buttons.forEach { if $0.showingTitle.isEmpty && !$0.inDisabledState { $0.switchToRedColors() } }
    }
    
    static func enableAll(buttons: [FLCListPickerButton]) {
        buttons.forEach {
            $0.setEnabled()
            $0.resetState()
        }
        previousTitle = ""
    }
    
    static func getItems(basedOn pickedCountry: FLCCountryOption, for button: FLCListPickerButton) -> [FLCPickerItem] {
        
        switch pickedCountry {
        case .china:
            if button.smallLabelView.smallLabel.text == "Условия Поставки" {
                return CalculationInfo.chinaDeliveryTypes
            } else {
                return CalculationInfo.chinaLocations
            }
        case .turkey:
            if button.smallLabelView.smallLabel.text == "Условия Поставки" {
                return CalculationInfo.turkeyDeliveryTypes
            } else {
                return CalculationInfo.turkeyLocations
            }
        }
    }
    
    static func presentListPickerVC(from button: FLCListPickerButton, listener: FLCCalculationView, items: [FLCPickerItem], sort: FLCListPickerSortType = .byTitle, searchType: FLCListPickerSearchType = .both, in viewController: UIViewController) {
        let listPickerVC = FLCListPickerVC(from: button, items: items, sort: sort, searchType: searchType)
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
    
    static func confirmDataIsValid(in view: FLCCalculationView) -> Bool {
        if checkIfFilledAll(textFields: view.flcTextFields) && checkIfFilledAll(buttons: view.flcListPickerButtons)  {
            return checkIfTextFieldsValueNotZero(in: view)
        } else {
            makeRedAll(textFields: view.flcTextFields)
            makeRedAll(buttons: view.flcListPickerButtons)
            HapticManager.addErrorHaptic()
            FLCPopupView.showOnMainThread(systemImage: "text.insert", title: "Сперва заполните все поля")
            return false
        }
    }
    
    private static func checkIfTextFieldsValueNotZero(in view: FLCCalculationView) -> Bool {
        var isWithZero = false
        
        view.flcTextFields.forEach {
            if $0.text == FLCNumberTextField.placeholderValue {
                $0.switchToRedColors()
                FLCPopupView.showOnMainThread(systemImage: "text.insert", title: "Значение не должно быть нулевым")
                isWithZero = true
            }
        }
        return isWithZero ? false : true
    }
    
    static func setupDestinationButtonTitle(_ button: FLCListPickerButton, basedOn deliveryTypeButton: FLCListPickerButton) {
        guard let text = deliveryTypeButton.titleLabel?.text else { return }
      
        if text.contains(CalculationInfo.russianWarehouseCity) {
            button.smallLabelView.moveUpSmallLabel()
            button.setTitle(CalculationInfo.russianWarehouseCity, for: .normal)
            button.showingTitle = CalculationInfo.russianWarehouseCity
        } else {
            button.resetState()
        }
        button.setEnabled()
    }
    
    static func adjustProgressView(basedOn destButton: FLCListPickerButton, and deliveryButton: FLCListPickerButton) -> FLCProgressViewOption? {
        let destinationTitle = destButton.showingTitle
        let deliveryTitle = deliveryButton.showingTitle
        
        if previousTitle.contains(CalculationInfo.russianWarehouseCity) && deliveryTitle.contains(CalculationInfo.russianWarehouseCity) { return nil }
        
        if deliveryTitle.contains(CalculationInfo.russianWarehouseCity) {
            previousTitle = deliveryTitle
            return destinationTitle.contains(CalculationInfo.russianWarehouseCity) ? .increase : .decrease
        } else {
            if previousTitle.contains(CalculationInfo.russianWarehouseCity) && destinationTitle == "" {
                previousTitle = deliveryTitle
                return .decrease
            }
        }
        return nil
    }
    
    static func adjustProgressView(in view: FLCTransportParametersView) -> Float {
        var times: Float = 0
        
        view.listPickerButtonsWithTitle.forEach { if $0.value == true { times += 1 } }
        view.flcListPickerButtons.forEach { view.listPickerButtonsWithTitle[$0] = false }
        return times
    }
}
