import UIKit

struct CalculationUIHelper {
    private static var destinationButtonTitles: (old: String?, new: String?)
    private static var departureButtonTitles: (old: String?, new: String?)
    
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
    
    static func showTotalPrice(vc: UIViewController, from parentVC: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let totalPriceVC = vc as? TotalPriceVC, let parentVC = parentVC as? CalculationResultVC else { return }
            totalPriceVC.isModalInPresentation = true
            totalPriceVC.sheetPresentationController?.getFLCSheetPresentationController(in: parentVC.view, size: 0.65, dimmed: false, cornerRadius: 35, addSmallDetent: true)
            parentVC.present(totalPriceVC, animated: true)
        }
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
    
    static func setupTitleFor(buttons: [(button: FLCListPickerButton, text: String)], basedOn deliveryTypeButton: FLCListPickerButton) {
        buttons.forEach { entry in
            guard let text = deliveryTypeButton.titleLabel?.text else { return }
            
            if text.contains(entry.text) {
                entry.button.smallLabelView.moveUpSmallLabel()
                entry.button.setTitle(entry.text, for: .normal)
                entry.button.showingTitle = entry.text
            } else {
                entry.button.resetState()
            }
            entry.button.setEnabled()
        }
    }
    
    static func adjustProgressView(basedOn button: FLCListPickerButton) -> FLCProgressViewOption? {
        var tempData = retrieveTempData(button: button)
        tempData.new = button.titleLabel?.text
        
        if tempData.old == nil && tempData.new != nil {
            tempData.old = tempData.new
            saveTempData(data: tempData, button: button)
            return .increase
        } else if tempData.old != nil && tempData.new == nil {
            tempData.old = tempData.new
            saveTempData(data: tempData, button: button)
            return .decrease
        }
        return nil
    }
    
    private static func retrieveTempData(button: FLCListPickerButton) -> (old: String?, new: String?) {
        var tempData: (old: String?, new: String?)
        
        switch button.smallLabelView.smallLabel.text {
        case "Пункт отправления":
            tempData = departureButtonTitles
        case "Пункт назначения":
            tempData = destinationButtonTitles
        case .none, .some(_): break
        }
        return tempData
    }
    
    private static func saveTempData(data: (old: String?, new: String?), button: FLCListPickerButton) {
        switch button.smallLabelView.smallLabel.text {
        case "Пункт отправления":
            departureButtonTitles = data
        case "Пункт назначения":
            destinationButtonTitles = data
        case .none, .some(_): break
        }
    }
    
    static func adjustProgressView(in view: FLCTransportParametersView) -> Float {
        var times: Float = 0
        
        view.listPickerButtonsWithTitle.forEach { if $0.value == true { times += 1 } }
        view.flcListPickerButtons.forEach { view.listPickerButtonsWithTitle[$0] = false }
        return times
    }
    
    static func detectCloseButtonPressed(with gesture: UITapGestureRecognizer, in navController: UINavigationController) -> Bool {
        let navigationBar = navController.navigationBar
        let tapLocation = gesture.location(in: navigationBar)
        
        let potentialRightItemViews = navigationBar.subviews.filter { subview in
            return subview.frame.maxX >= navigationBar.frame.width - subview.frame.width
        }
        
        for rightItemView in potentialRightItemViews {
            let buttonLocation = navigationBar.convert(tapLocation, to: rightItemView)
            if rightItemView.bounds.contains(buttonLocation) {
                return true
            }
        }
        return false
    }
    
    static func calculateTotalPrice(prices: [String]) -> String {
        var rubleTotal = 0.0
        var currencyTotal = 0.0
        
        prices.forEach {
            if $0.contains(FLCCurrency.RUB.symbol) {
                rubleTotal += $0.createDouble(removeSymbols: true)
            } else {
                currencyTotal += $0.createDouble(removeSymbols: true)
            }
        }
        return "\(currencyTotal.formatAsCurrency(symbol: .USD)) + \(rubleTotal.formatAsCurrency(symbol: .RUB))"
    }
    
    static func calculateTotalDays(days: [String]) -> String {
        var totalDays = 0
        var fromDay = 0
        
        days.forEach { day in
            if day.contains("-") {
                fromDay = Int(day.components(separatedBy: "-").first?.filter { $0.isNumber } ?? "") ?? 0
                totalDays += fromDay
                fromDay = 0
            } else {
                totalDays += Int(day.filter { $0.isNumber }) ?? 0
            }
        }
        return "от \(totalDays) дн."
    }
}
