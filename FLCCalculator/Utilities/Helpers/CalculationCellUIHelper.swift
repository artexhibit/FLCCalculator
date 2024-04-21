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
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "Подольск - \(item.calculationData.toLocation)".makeAttributed(icon: Icons.truck, size: (0, -3, 24, 17), placeIcon: .beforeText)
        cell.priceLabel.text = item.price
        cell.daysTextView.text = "\(item.daysAmount ?? "?") дн."
    }
    
    static func configureInsurance(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString, pickedLogisticsType: FLCLogisticsType) {
        let data = CalculationResultHelper.getInsurancePrice(item: item, pickedLogisticsType: pickedLogisticsType)
        
        cell.titleTextView.attributedText = attributedText
        cell.priceLabel.text = item.price
        cell.subtitle.text = "\(PriceCalculationManager.getInsurancePersentage(for: pickedLogisticsType))% от стоимости инвойса \n\(item.calculationData.invoiceAmount.formatAsCurrency(symbol: data.code)), 1 \(item.currency.symbol) ~ \(data.ratio) \(data.code.symbol)"

        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureDeliveryFromWarehouse(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString, pickedLogisticsType: FLCLogisticsType) {
        let data = CalculationResultHelper.getDeliveryFromWarehousePrice(item: item, pickedLogisticsType: pickedLogisticsType)
        let subtitle = getDeliveryFromWarehouseSubtitle(from: pickedLogisticsType)
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = subtitle.makeAttributed(icon: Icons.map, size: (0, -2, 22, 16), placeIcon: .beforeText)
        cell.daysTextView.attributedText = data.days.makeAttributed(icon: Icons.questionMark, tint: .lightGray, size: (0, -4, 22, 21), placeIcon: .afterText)
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        resetDaysContent(in: cell)
    }
    
    static func configureCargoHandling(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString, pickedLogisticsType: FLCLogisticsType) {
        let handlingData = PriceCalculationManager.getCagoHandlingData(for: pickedLogisticsType)
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.text = "\(handlingData.pricePerKg.formatAsCurrency(symbol: item.currency)) за кг, минимум \(handlingData.minPrice.formatAsCurrency(symbol: item.currency))"
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
    
    static func configureGroupageDocs(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.text = "В составе сборного груза"
        cell.priceLabel.text = item.price
        
        item.hasError ? showFailedPriceFetchView(in: cell, with: item) : cell.failedPriceCalcContainer.hide()
        removeDaysContent(in: cell)
    }
    
    static func configureDeliveryToWarehouse(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        let data = CalculationResultHelper.getDeliveryToWarehousePrice(item: item)
        let addShaghaiWarehouse = data.isGuangzhou ? "- Склад Шанхай" : ""
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "\(item.calculationData.fromLocation) - Склад \(data.warehouseName) \(addShaghaiWarehouse)".makeAttributed(icon: Icons.map, size: (0, -2, 22, 16), placeIcon: .beforeText)
        cell.daysTextView.attributedText = data.days.makeAttributed(icon: Icons.questionMark, tint: .lightGray, size: (0, -4, 22, 21), placeIcon: .afterText)
        cell.priceLabel.text = item.price
        
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
    
    private static func getDeliveryFromWarehouseSubtitle(from pickedLogisticsType: FLCLogisticsType) -> String {
        switch pickedLogisticsType {
        case .chinaTruck, .chinaRailway:
            "Шанхай - Подольск"
        case .chinaAir:
            "Шанхай - Аэропорт Шереметьево"
        case .turkeyTruck:
            "Стамбул - Подольск"
        }
    }
    
    static func configurePopoverMessage(in cell: CalculationResultCell, iconType: String, pickedLogisticsType: FLCLogisticsType) -> String {
        
        switch cell.type {
        case .russianDelivery:
            return "Наш партнёр по доставке - ПЭК. Груз будет доставлен для Вас согласно высочайшим стандартам компании."
        case .insurance:
            return "Наш многолетний партнёр по страхованию - компания СК Пари. Страховка от полной стоимости инвойса."
        case .deliveryFromWarehouse:
            if iconType == "questionmark.circle.fill" {
                
                switch pickedLogisticsType {
                case .chinaTruck, .chinaRailway:
                    return "С момента выхода с нашего склада в Китае и до разгрузки на нашем складе в Подольске."
                case .chinaAir:
                    return "С момента вылета из аэропорта отправления и до разгрузки на нашем складе в Подольске."
                case .turkeyTruck:
                    return "С момента выхода с нашего склада в Стамбуле и до разгрузки на нашем складе в Подольске."
                }
            } else {
                return "Отправляемся из Шанхая каждые вторник и пятницу. Выезд из Гуанчжоу каждую пятницу под выход из Шанхая во вторник."
            }
        case .cargoHandling:
            return "Включены все операции по загрузке и выгрузке Вашего груза от склада отправления до склада назначения."
        case .customsClearancePrice:
            return "В стоимость входит подача Таможенной Декларации, услуги брокера и ЭЦП брокера."
        case .customsWarehouseServices:
            return "Услуги таможенного Склада Временного Хранения на время оформления груза. Дополнительные услуги по погрузке, разгрузке, хранению сверх норматива оплачиваются по тарифу с СВХ отдельно."
        case .deliveryToWarehouse:
            if iconType == "questionmark.circle.fill" {
                guard let item = cell.calculationResultItem else { return "" }
                let deliveryData = PriceCalculationManager.getDeliveryToWarehouse(forCountry: .china, city: item.calculationData.fromLocation, weight: item.calculationData.weight, volume: item.calculationData.volume)
                
                if deliveryData.warehouseName.flcWarehouseFromRusName == .guangzhou {
                    return "Поставщик - Склад Гуанчжоу: \(deliveryData.transitDays) дн. \nСклад Гуанчжоу - Склад Шанхай: 4 дн."
                } else {
                    return "Доставка с адреса поставщика до нашего склада в Шанхае."
                }
            } else {
                return  "Доставка с адреса поставщика до нашего Склада Консолидации для последующей отправки в Россию"
            }
        case .groupageDocs:
            return "В стоимость входит транспортный комплект документов (CMR, накладные и тд). Оформление экспортной декларации за поставщика - отдельная услуга!"
        }
    }
}
