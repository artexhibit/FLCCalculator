import UIKit

struct CalculationCellUIHelper {
    static func configureRussianDelivery(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        
        guard !item.hasError else {
            showFailedPriceFetchView(in: cell, with: item)
            resetDaysContent(in: cell)
            cell.subtitle.text = ""
            return
        }
        guard item.price != nil else { return }
        
        resetDaysContent(in: cell)
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "\(CalculationResultVCStrings.russianDeliveryPodolskLabel) \(item.calculationData.toLocation)".makeAttributed(icon: FLCIcon.truck.icon, size: (0, -3, 24, 17), placeIcon: .beforeText)
        cell.priceLabel.text = item.price
        cell.daysTextView.text = "\(item.daysAmount ?? "?") \(CalculationResultVCStrings.daysLabel)"
    }
    
    static func configureInsurance(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString, pickedLogisticsType: FLCLogisticsType) {
        let data = CalculationResultHelper.getInsurancePrice(item: item, pickedLogisticsType: pickedLogisticsType)
        let results = CoreDataManager.getCalculationResults(forCalculationID: item.calculationData.id)
        let targetResult = results?.first(where: { $0.logisticsType == pickedLogisticsType.rawValue })
        let ratio = item.calculationData.isFromCoreData ? targetResult?.insuranceRatio ?? 0 : data.ratio
        let invoiceAmountString = item.calculationData.invoiceAmount.formatAsCurrency(symbol: data.code)
        let ratioString = ", 1 \(item.currency.symbol) ~ \(ratio) \(data.code.symbol)"
        let totalString = item.currency == data.code ? "(\(invoiceAmountString))" : "\n\(invoiceAmountString + ratioString)"
        
        cell.titleTextView.attributedText = attributedText
        cell.priceLabel.text = item.price
        cell.subtitle.text = "\(PriceCalculationManager.getInsurancePercentage(for: pickedLogisticsType, item: item)) \(CalculationResultVCStrings.insurancePercentageLabel) \(totalString)"

        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureDeliveryFromWarehouse(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString, pickedLogisticsType: FLCLogisticsType) {
        let data = CalculationResultHelper.getDeliveryFromWarehousePrice(item: item, pickedLogisticsType: pickedLogisticsType)
        let subtitle = getDeliveryFromWarehouseSubtitle(from: pickedLogisticsType, item: item)
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = subtitle.makeAttributed(icon: FLCIcon.map.icon, size: (0, -2, 22, 16), placeIcon: .beforeText)
        cell.daysTextView.attributedText = data.days.makeAttributed(icon: FLCIcon.questionMark.icon, tint: .flcCalculationResultCellSecondary, size: (0, -4, 22, 21), placeIcon: .afterText)
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        resetDaysContent(in: cell)
    }
    
    static func configureCargoHandling(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString, pickedLogisticsType: FLCLogisticsType) {
        let results = CoreDataManager.getCalculationResults(forCalculationID: item.calculationData.id)
        let targetResult = results?.first(where: { $0.logisticsType == pickedLogisticsType.rawValue })
        let handlingData = item.calculationData.isFromCoreData ? (pricePerKg: targetResult?.cargoHandlingPricePerKg ?? 0, minPrice: targetResult?.cargoHandlingMinPrice) : PriceCalculationManager.getCargoHandlingData(for: pickedLogisticsType, item: item)
        let perKgString = "\(handlingData.pricePerKg.formatAsCurrency(symbol: item.currency)) \(CalculationResultVCStrings.cargoHandlingPerKgLabel)"
        let minPriceString = "\(CalculationResultVCStrings.cargoHandlingMinPriceLabel) \(handlingData.minPrice?.formatAsCurrency(symbol: item.currency) ?? "")"
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.text = FLCLogisticsType.airLogisticsTypes.contains(pickedLogisticsType) ? perKgString : perKgString + minPriceString
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureCustomsClearance(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = CalculationResultVCStrings.customsClearanceLabel.makeAttributed(icon: FLCIcon.document.icon, size: (0, -3, 18, 17), placeIcon: .beforeText)
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureCustomsWarehouseServices(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = CalculationResultVCStrings.customsWarehouseServices.makeAttributed(icon: FLCIcon.clock.icon, size: (0, -2, 18, 17), placeIcon: .beforeText)
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureGroupageDocs(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString, pickedLogisticsType: FLCLogisticsType) {
        let text = FLCLogisticsType.airLogisticsTypes.contains(pickedLogisticsType) ? CalculationResultVCStrings.groupageDocsAirLabel : CalculationResultVCStrings.groupageDocsLabel
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.text = text
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureDeliveryToWarehouse(logisticsType: FLCLogisticsType, cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        let data = CalculationResultHelper.getDeliveryToWarehousePrice(logisticsType: logisticsType, item: item)
        let calculation = CoreDataManager.getCalculation(withID: item.calculationData.id)
        let addShaghaiWarehouse = data.isGuangzhou && logisticsType != .chinaAir ? CalculationResultVCStrings.deliveryToWarehouseShaghaiLabel : ""
        let deliveryPlace = logisticsType == .chinaAir ? CalculationResultVCStrings.deliveryToWarehouseAirportLabel : CalculationResultVCStrings.deliveryToWarehouseLabel
                
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "\(item.calculationData.fromLocation) \(deliveryPlace) \(data.warehouseName) \(addShaghaiWarehouse)".makeAttributed(icon: FLCIcon.map.icon, size: (0, -2, 22, 16), placeIcon: .beforeText)
        cell.daysTextView.attributedText = data.days.makeAttributed(icon: FLCIcon.questionMark.icon, tint: .flcCalculationResultCellSecondary, size: (0, -4, 22, 21), placeIcon: .afterText)
        cell.priceLabel.text = item.price
        
        switch logisticsType {
        case .chinaTruck, .chinaRailway: break
        case .chinaAir, .turkeyAirVKO, .turkeyAirSVO: configurePickupWarningMessageForAir(item: item, calculation: calculation, cell: cell, logisticsType: logisticsType)
        case .turkeyTruckByFerry: configurePickupWarningMessageForTurkeyTruckByFerry(item: item, calculation: calculation, cell: cell)
        case .turkeyNovorossiyskBySea: configurePickupWarningMessageForTurkeyNovorossiyskBySea(item: item, calculation: calculation, cell: cell)
        }
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        resetDaysContent(in: cell)
    }
    
    private static func configurePickupWarningMessageForTurkeyNovorossiyskBySea(item: CalculationResultItem, calculation: Calculation?, cell: CalculationResultCell) {
        let cityZipCode = (item.calculationData.isFromCoreData ? calculation?.fromLocationCode : item.calculationData.fromLocationCode) ?? ""
        let closestCity = PriceCalculationManager.getClosestPickupCityForTurkeyNovorossiyskBySea(by: cityZipCode)
        if !closestCity.isEmpty { cell.addPickupWarningMessage(warehouseName: closestCity) }
    }
    
    private static func configurePickupWarningMessageForTurkeyTruckByFerry(item: CalculationResultItem, calculation: Calculation?, cell: CalculationResultCell) {
        let city = item.calculationData.isFromCoreData ? calculation?.fromLocation?.getDataOutsideCharacters() ?? "" : item.calculationData.fromLocation.getDataOutsideCharacters() ?? ""
        let closestCity = PriceCalculationManager.getClosestPickupCityForTurkeyTruckByFerry(to: city)?.name ?? ""
        if !closestCity.isEmpty { cell.addPickupWarningMessage(warehouseName: closestCity) }
    }
    
    private static func configurePickupWarningMessageForAir(item: CalculationResultItem, calculation: Calculation?, cell: CalculationResultCell, logisticsType: FLCLogisticsType) {
        var closestAirport: String {
            if logisticsType == .chinaAir {
               return item.calculationData.isFromCoreData ? calculation?.departureAirport ?? "" : item.calculationData.departureAirport
            } else {
                let storedFromLocation = calculation?.fromLocation?.isContains(FLCWarehouse.istanbul.rawValue) ?? false ? FLCWarehouse.istanbul.rawValue : calculation?.fromLocation?.extractCharacters()
                let calculationFromLocation = item.calculationData.fromLocation.isContains(FLCWarehouse.istanbul.rawValue) ? FLCWarehouse.istanbul.rawValue : item.calculationData.fromLocation.extractCharacters()
                return item.calculationData.isFromCoreData ? storedFromLocation ?? "" : calculationFromLocation
            }
        }
       
        switch logisticsType {
        case .chinaTruck, .chinaRailway, .turkeyTruckByFerry, .turkeyNovorossiyskBySea: break
        case .chinaAir:
            cell.addPickupWarningMessage(warehouseName: PriceCalculationManager.getClosestAirport(to: closestAirport, with: PriceCalculationManager.getChinaAirPickup())?.airName ?? "")
        case .turkeyAirVKO:
            let airportName = PriceCalculationManager.getClosestAirport(to: closestAirport, with: PriceCalculationManager.getTurkeyAirVKOPickup())?.airName ?? ""
            if !airportName.isContains(closestAirport) { cell.addPickupWarningMessage(warehouseName: airportName) }
        case .turkeyAirSVO:
            let airportName = PriceCalculationManager.getClosestAirport(to: closestAirport, with: PriceCalculationManager.getTurkeyAirSVOPickup())?.airName ?? ""
            if !airportName.isContains(closestAirport) { cell.addPickupWarningMessage(warehouseName: airportName) }
        }
    }
    
    private static func removeDaysContent(in cell: CalculationResultCell) {
        cell.daysTextView.text = ""
        cell.daysLabelHeightConstraint.constant = 0.1
        cell.subtitleBottomConstraint.constant = -cell.padding / 4
    }
    
    private static func resetDaysContent(in cell: CalculationResultCell) {
        cell.daysLabelHeightConstraint.constant = 24
        cell.subtitleBottomConstraint.constant = -cell.padding * 2
    }
    
    private static func showFailedPriceFetchView(in cell: CalculationResultCell, with item: CalculationResultItem) {
        cell.configureFailedPriceCalcContainer()
        cell.failedPriceCalcErrorSubtitleLabel.text = item.title
        cell.failedPriceCalcContainer.show()
        cell.removeShimmerAnimation()
    }
    
    private static func getDeliveryFromWarehouseSubtitle(from pickedLogisticsType: FLCLogisticsType, item: CalculationResultItem) -> String {
        switch pickedLogisticsType {
        case .chinaTruck, .chinaRailway: return CalculationResultVCStrings.deliveryFromWarehouseShanghaiPodolskLabel
        case .chinaAir:
            let calculation = CoreDataManager.getCalculation(withID: item.calculationData.id)
            let city = item.calculationData.isFromCoreData ? calculation?.departureAirport ?? "" : item.calculationData.departureAirport
            let departureAirport = PriceCalculationManager.getClosestAirport(to: city, with: PriceCalculationManager.getChinaAirPickup())?.airTargetAirport ?? ""
            return "\(CalculationResultVCStrings.deliveryFromWarehouseAirportLabel) \(departureAirport) \(CalculationResultVCStrings.deliveryFromWarehouseAirportSVOLabel)"
        case .turkeyTruckByFerry, .turkeyNovorossiyskBySea: return CalculationResultVCStrings.deliveryFromWarehouseIstanbulPodolskLabel
        case .turkeyAirVKO: return CalculationResultVCStrings.deliveryFromWarehouseTurkeyVKOLabel
        case .turkeyAirSVO: return CalculationResultVCStrings.deliveryFromWarehouseTurkeySVOLabel
        }
    }
    
    static func configurePopoverMessage(in cell: CalculationResultCell, iconType: UIImage, pickedLogisticsType: FLCLogisticsType) -> String {
        
        switch cell.type {
        case .russianDelivery: return PopoverMessages.russianDelivery
        case .insurance: return PopoverMessages.insurance
        case .deliveryFromWarehouse:
            switch pickedLogisticsType {
            case .chinaTruck: return PopoverMessages.deliveryFromWarehouseChinaTruck
            case .chinaRailway: return PopoverMessages.deliveryFromWarehouseChinaRailway
            case .chinaAir, .turkeyAirSVO, .turkeyAirVKO: return PopoverMessages.deliveryFromWarehouseAir
            case .turkeyTruckByFerry, .turkeyNovorossiyskBySea: return PopoverMessages.deliveryFromWarehouseTurkey
            }
        case .cargoHandling:
            switch pickedLogisticsType {
            case .chinaTruck, .chinaRailway, .turkeyTruckByFerry, .turkeyNovorossiyskBySea: return PopoverMessages.cargoHandling
            case .chinaAir, .turkeyAirSVO, .turkeyAirVKO: return PopoverMessages.cargoHandlingAir
            }
        case .customsClearancePrice: return PopoverMessages.customsClearancePrice
        case .customsWarehouseServices: return PopoverMessages.customsWarehouseServices
        case .deliveryToWarehouse:
            if iconType == FLCIcon.questionMark.icon {
                guard let item = cell.calculationResultItem else { return "" }
                let deliveryData = PriceCalculationManager.getDeliveryToWarehouse(item: item, logisticsType: pickedLogisticsType)
                
                if FLCWarehouse(localizedString: deliveryData.warehouseName) == .guangzhou {
                    return "\(PopoverMessages.deliveryToWarehouseShipperGuangzhou): \(deliveryData.transitDays) \(CalculationResultVCStrings.daysLabel) \n\(PopoverMessages.deliveryToWarehouseGuangzhouShanghai)"
                } else if FLCWarehouse(localizedString: deliveryData.warehouseName) == .shanghai  {
                    return PopoverMessages.deliveryToWarehouseShanghai
                } else {
                    return PopoverMessages.deliveryToWarehouseInstanbul
                }
            } else {
                return PopoverMessages.deliveryToWarehouse
            }
        case .groupageDocs:
            switch pickedLogisticsType {
            case .chinaTruck, .chinaRailway, .turkeyTruckByFerry, .turkeyNovorossiyskBySea: return PopoverMessages.groupageDocs
            case .chinaAir, .turkeyAirVKO, .turkeyAirSVO: return PopoverMessages.groupageDocsAir
            }
        }
    }
}
