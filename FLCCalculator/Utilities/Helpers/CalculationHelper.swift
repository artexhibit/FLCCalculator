import UIKit

struct CalculationHelper {
    private static var storedTitlesAmount: Float = 0
    private static let customSizeDetentHeight: CGFloat = DeviceTypes.isiPhoneSE3rdGen ? 0.85 : 0.65
    
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
    
    static func setTitle(for triggerButton: FLCListPickerButton, pickedItem: FLCPickerItem, addString: String = "", title: String? = nil) {
        let newTitle = title == nil ? "\(pickedItem.title)\(addString)" : title ?? ""
        
        triggerButton.set(title: newTitle)
        triggerButton.showingTitle = newTitle
        triggerButton.layoutIfNeeded()
    }
    
    static func showIstanbulZones(in view: FLCTransportParametersView, and vc: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            presentListPickerVC(from: view.departurePickerButton, listener: view, items: CalculationInfo.istanbulLocations, in: vc)
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
    
    static func presentSheetPickerVC(items: [FLCPickerItem], triggerButton: FLCListPickerButton, listener: FLCCalculationView, in viewController: UIViewController, size: CGFloat = 0.5, title: String? = nil, cantCloseBySwipe: Bool = false) {
        let sheetPickerVC = FLCSheetPickerVC(items: items, triggerButton: triggerButton, title: title)
        sheetPickerVC.delegate = listener as? FLCPickerDelegate
        let navController = UINavigationController(rootViewController: sheetPickerVC)
        navController.sheetPresentationController?.getFLCSheetPresentationController(in: viewController.view, size: size)
        navController.isModalInPresentation = cantCloseBySwipe
        viewController.present(navController, animated: true)
    }
    
    static func showTotalPrice(vc: UIViewController, from parentVC: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let totalPriceVC = vc as? TotalPriceVC, let parentVC = parentVC as? CalculationResultVC else { return }
            totalPriceVC.isModalInPresentation = true
            totalPriceVC.sheetPresentationController?.getFLCSheetPresentationController(in: parentVC.view, size: customSizeDetentHeight, dimmed: false, cornerRadius: 35, addSmallDetent: true)
            parentVC.present(totalPriceVC, animated: true)
        }
    }
    
    static func updateTotalPriceSmallDetentHeight(to size: CGFloat, in vc: UIViewController, from parentVC: UIViewController) {
        guard let totalPriceVC = vc as? TotalPriceVC, let sheetController = totalPriceVC.sheetPresentationController, let parentVC = parentVC as? CalculationResultVC else { return }
        
        sheetController.updateDetentsHeight(to: (size, customSizeDetentHeight), dimmed: false, view: parentVC.view, addSmallDetent: true)
    }
    
    static func confirmDataIsValid(in view: FLCCalculationView) -> Bool {
        if checkIfFilledAll(textFields: view.flcTextFields) && checkIfFilledAll(buttons: view.flcListPickerButtons)  {
            return checkIfDataCompliesWithRules(in: view)
        } else {
            makeRedAll(textFields: view.flcTextFields)
            makeRedAll(buttons: view.flcListPickerButtons)
            HapticManager.addErrorHaptic()
            FLCPopupView.showOnMainThread(systemImage: "text.insert", title: "Сперва заполните все поля")
            return false
        }
    }
    
    private static func checkIfDataCompliesWithRules(in view: FLCCalculationView) -> Bool {
        var isWithZero = false
        
        view.flcTextFields.forEach {
            if $0.text == TextFieldManager.placeholderValue {
                $0.switchToRedColors()
                FLCPopupView.showOnMainThread(systemImage: "text.insert", title: "Значение не должно быть нулевым")
                isWithZero = true
            }
        }
        view.flcListPickerButtons.forEach {
            if $0.showingTitle == FLCCities.istanbul.rawValue {
                FLCPopupView.showOnMainThread(systemImage: "text.insert", title: "Выберите область Стамбула в Пункте Отправления")
                $0.switchToRedColors()
                isWithZero = true
            } else if $0.showingTitle == WarehouseStrings.chinaWarehouse {
                FLCPopupView.showOnMainThread(systemImage: "text.insert", title: "Выберите аэропорт отправления для расчёта авиа")
                $0.switchToRedColors()
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
    
    static func adjustProgressView(for buttons: [FLCListPickerButton], in progressView: FLCProgressView) {
        var titlesAmount: Float = 0
        
        buttons.forEach { if !$0.showingTitle.isEmpty { titlesAmount += 1 } }
        let times = abs(titlesAmount - storedTitlesAmount)
        if titlesAmount > storedTitlesAmount {
            progressView.setProgress(.increase, times: times)
        } else if titlesAmount < storedTitlesAmount {
            progressView.setProgress(.decrease, times: times)
        }
        storedTitlesAmount = titlesAmount
    }
    
    static func configureShineEffect(for button: FLCButton, basedOn buttons: [FLCListPickerButton]) {
        let allButtonsHaveTitles = buttons.allSatisfy { !$0.titleIsEmpty }
        
        if allButtonsHaveTitles {
            button.addShineEffect()
            HapticManager.addSuccessHaptic()
        } else {
            button.removeShineEffect()
        }
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
    
    private static func createAvailableLogisticsTypes(with transportView: FLCTransportParametersView) -> [FLCLogisticsType] {
        let country = FLCCountryOption(rawValue: transportView.countryPickerButton.showingTitle)
        let availableLogisticsTypes: [AvailableLogisticsType]? = CoreDataManager.retrieveItemsFromCoreData()
        
        return availableLogisticsTypes?
            .filter { $0.isAvailable && $0.country == country?.engName }
            .compactMap { FLCLogisticsType(rawValue: $0.logisticsTypeName) } ?? [.chinaTruck]
    }
    
    static func getCalculationData(transportView: FLCTransportParametersView, cargoView: FLCCargoParametersView, pickedDestinationCode: String, departureAirport: String) -> CalculationData {
        let calcData = CalculationData(
            id: Int32(CoreDataManager.loadCalculations()?.count ?? 0),
            countryFrom: transportView.countryPickerButton.showingTitle,
            countryTo: "Россия",
            deliveryType: transportView.deliveryTypePickerButton.showingTitle.removeFirstCharacters(5),
            deliveryTypeCode: transportView.deliveryTypePickerButton.showingTitle.getFirstCharacters(3), 
            departureAirport: PriceCalculationManager.getClosestAirportForAirDelivery(to: departureAirport)?.targetAirport ?? "",
            fromLocation: transportView.departurePickerButton.showingTitle.removeStringPart("+1"),
            toLocation: transportView.destinationPickerButton.showingTitle,
            toLocationCode: pickedDestinationCode,
            goodsType: cargoView.cargoTypePickerButton.showingTitle,
            volume: cargoView.volumeTextField.text?.createDouble() ?? 0.0,
            weight: cargoView.weightTextField.text?.createDouble() ?? 0.0,
            invoiceAmount: cargoView.invoiceAmountTextField.text?.createDouble() ?? 0.0,
            invoiceCurrency: cargoView.invoiceCurrencyPickerButton.showingTitle,
            needCustomClearance: cargoView.customsClearanceSwitch.isOn,
            totalPrices: nil, 
            availableLogisticsTypes: createAvailableLogisticsTypes(with: transportView),
            isFromCoreData: false,
            isConfirmed: false,
            exchangeRate: PriceCalculationManager.getCurrencyData()?.Valute[FLCCurrency.USD.rawValue]?.Value ?? 0)
        return calcData
    }
}
