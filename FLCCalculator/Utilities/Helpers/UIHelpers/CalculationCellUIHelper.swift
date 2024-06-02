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
        cell.subtitle.attributedText = "Подольск - \(item.calculationData.toLocation)".makeAttributed(icon: Icons.truck, size: (0, -3, 24, 17), placeIcon: .beforeText)
        cell.priceLabel.text = item.price
        cell.daysTextView.text = "\(item.daysAmount ?? "?") дн."
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
        cell.subtitle.text = "\(PriceCalculationManager.getInsurancePercentage(for: pickedLogisticsType, item: item))% от стоимости инвойса \(totalString)"

        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureDeliveryFromWarehouse(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString, pickedLogisticsType: FLCLogisticsType) {
        let data = CalculationResultHelper.getDeliveryFromWarehousePrice(item: item, pickedLogisticsType: pickedLogisticsType)
        let subtitle = getDeliveryFromWarehouseSubtitle(from: pickedLogisticsType, item: item)
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = subtitle.makeAttributed(icon: Icons.map, size: (0, -2, 22, 16), placeIcon: .beforeText)
        cell.daysTextView.attributedText = data.days.makeAttributed(icon: Icons.questionMark, tint: .flcCalculationResultCellSecondary, size: (0, -4, 22, 21), placeIcon: .afterText)
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        resetDaysContent(in: cell)
    }
    
    static func configureCargoHandling(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString, pickedLogisticsType: FLCLogisticsType) {
        let results = CoreDataManager.getCalculationResults(forCalculationID: item.calculationData.id)
        let targetResult = results?.first(where: { $0.logisticsType == pickedLogisticsType.rawValue })
        let handlingData = item.calculationData.isFromCoreData ? (pricePerKg: targetResult?.cargoHandlingPricePerKg ?? 0, minPrice: targetResult?.cargoHandlingMinPrice) : PriceCalculationManager.getCargoHandlingData(for: pickedLogisticsType, item: item)
        let perKgString = "\(handlingData.pricePerKg.formatAsCurrency(symbol: item.currency)) за кг "
        let minPriceString = ", минимум \(handlingData.minPrice?.formatAsCurrency(symbol: item.currency) ?? "")"
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.text = pickedLogisticsType == .chinaAir ? perKgString : perKgString + minPriceString
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureCustomsClearance(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "Свидетельство таможенного представителя № 0998/00".makeAttributed(icon: Icons.document, size: (0, -3, 18, 17), placeIcon: .beforeText)
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureCustomsWarehouseServices(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "Включено 2 дня ожидания".makeAttributed(icon: Icons.clock, size: (0, -2, 18, 17), placeIcon: .beforeText)
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureGroupageDocs(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString, pickedLogisticsType: FLCLogisticsType) {
        let text = pickedLogisticsType == .chinaAir ? "Оформление AWB (Air Way Bill)" : "В составе сборного груза"
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.text = text
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureDeliveryToWarehouse(logisticsType: FLCLogisticsType, cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        let data = CalculationResultHelper.getDeliveryToWarehousePrice(logisticsType: logisticsType, item: item)
        let calculation = CoreDataManager.getCalculation(withID: item.calculationData.id)
        let city = item.calculationData.isFromCoreData ? calculation?.departureAirport ?? "" : item.calculationData.departureAirport
        let addShaghaiWarehouse = data.isGuangzhou ? "- Склад Шанхай" : ""
        let deliveryPlace = logisticsType == .chinaAir ? " - Аэропорт" : " - Склад"
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "\(item.calculationData.fromLocation) \(deliveryPlace) \(data.warehouseName) \(addShaghaiWarehouse)".makeAttributed(icon: Icons.map, size: (0, -2, 22, 16), placeIcon: .beforeText)
        cell.daysTextView.attributedText = data.days.makeAttributed(icon: Icons.questionMark, tint: .flcCalculationResultCellSecondary, size: (0, -4, 22, 21), placeIcon: .afterText)
        cell.priceLabel.text = item.price
        
        if logisticsType == .chinaAir { cell.addPickupWarningMessage(warehouseName: PriceCalculationManager.getClosestBigCityForAirDelivery(to: city)?.name ?? "") }
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        resetDaysContent(in: cell)
    }
    
    private static func removeDaysContent(in cell: CalculationResultCell) {
        cell.daysTextView.text = ""
        cell.daysLabelHeightConstraint.constant = 0.1
        cell.subtitleBottomConstraint.constant = -cell.padding / 4
    }
    
    private static func resetDaysContent(in cell: CalculationResultCell) {
        cell.daysLabelHeightConstraint.constant = 21
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
        case .chinaTruck, .chinaRailway: return "Шанхай - Подольск"
        case .chinaAir:
            let calculation = CoreDataManager.getCalculation(withID: item.calculationData.id)
            let city = item.calculationData.isFromCoreData ? calculation?.departureAirport ?? "" : item.calculationData.departureAirport
            let departureAirport = PriceCalculationManager.getClosestBigCityForAirDelivery(to: city)?.targetAirport ?? ""
            return "Аэропорт \(departureAirport) - Аэропорт Шереметьево"
        case .turkeyTruckByFerry: return "Стамбул - Подольск"
        }
    }
    
    static func configurePopoverMessage(in cell: CalculationResultCell, iconType: String, pickedLogisticsType: FLCLogisticsType) -> String {
        
        switch cell.type {
        case .russianDelivery:
            return "Наш партнёр по доставке - ПЭК. Груз будет доставлен для Вас согласно высочайшим стандартам компании."
        case .insurance:
            return "Наш многолетний партнёр по страхованию - компания СК Пари. Страховка от полной стоимости инвойса."
        case .deliveryFromWarehouse:
            switch pickedLogisticsType {
            case .chinaTruck:
                return "Отправляемся из Шанхая каждые вторник и пятницу. Выезд из Гуанчжоу каждую пятницу под выход из Шанхая во вторник."
            case .chinaRailway:
                return "С момента выхода с нашего склада в Китае и до разгрузки на нашем складе в Подольске."
            case .chinaAir:
                return "С момента вылета из аэропорта отправления и до размещения на СВХ в аэропорту прибытия."
            case .turkeyTruckByFerry:
                return "С момента выхода с нашего склада в Стамбуле и до разгрузки на нашем складе в Подольске."
            }
        case .cargoHandling:
            switch pickedLogisticsType {
            case .chinaTruck, .chinaRailway, .turkeyTruckByFerry:
                return "Включены все операции по загрузке и выгрузке Вашего груза от склада отправления до склада назначения."
            case .chinaAir:
                return "Включены погрузо-разгрузочные работы в аэропорту прибытия, извещение о прибытии груза, изготовление копий документов, выполнение требований госорганов для авиаперевозок, хранение на СВХ в аэропорту (1 день)"
            }
        case .customsClearancePrice:
            return "В стоимость входит подача Таможенной Декларации, услуги брокера и ЭЦП брокера."
        case .customsWarehouseServices:
            return "Услуги таможенного Склада Временного Хранения на время оформления груза. Дополнительные услуги по погрузке, разгрузке, хранению сверх норматива оплачиваются по тарифу с СВХ отдельно."
        case .deliveryToWarehouse:
            if iconType == "questionmark.circle.fill" {
                guard let item = cell.calculationResultItem else { return "" }
                let deliveryData = PriceCalculationManager.getDeliveryToWarehouse(item: item, logisticsType: pickedLogisticsType)
                
                if deliveryData.warehouseName.flcWarehouseFromRusName == .guangzhou {
                    return "Поставщик - Склад Гуанчжоу: \(deliveryData.transitDays) дн. \nСклад Гуанчжоу - Склад Шанхай: 4 дн."
                } else if deliveryData.warehouseName.flcWarehouseFromRusName == .shanghai  {
                    return "Доставка с адреса поставщика до нашего склада в Шанхае."
                } else {
                    return "Доставка с адреса поставщика до нашего склада в Стамбуле"
                }
            } else {
                return  "Доставка с адреса поставщика до нашего Склада Консолидации для последующей отправки в Россию"
            }
        case .groupageDocs:
            if pickedLogisticsType == .chinaAir {
                return "AWB - обязательный документ при международной авиаперевозке. \n\nОформим по всем требованиям и вашим пожеланиям (например, добавим номера инвойсов)"
            } else {
                return "В стоимость входит транспортный комплект документов (CMR, накладные и тд). Оформление экспортной декларации за поставщика - отдельная услуга!"
            }
        }
    }
}
