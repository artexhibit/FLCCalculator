import UIKit

struct CalculationCellUIHelper {
    static func configureRussianDelivery(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "Подольск - \(item.calculationData.toLocation)".makeAttributed(icon: Icons.truck, size: (0, -3, 24, 17), placeIcon: .beforeText)
        
        Task {
            do {
                let data = try await NetworkManager.shared.getRussianDelivery(for: item)
                let price = data.getPrice().add(markup: .seventeenPercents).formatAsCurrency(symbol: item.itemCellPriceCurrency)
                
                DispatchQueue.main.async {
                    cell.priceLabel.text = price
                    cell.daysTextView.text = "\(data.getDays() ?? "?") дн."
                    cell.removeShimmerAnimation()
                }
            }
        }
    }
    
    static func configureInsurance(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        let currencyCode = FLCCurrency(currencyCode: item.calculationData.invoiceCurrency) ?? .USD
        let ratio = PriceCalculationManager.getRatioBetween(item.itemCellPriceCurrency, and: currencyCode)
        
        cell.titleTextView.attributedText = attributedText
        cell.priceLabel.text = PriceCalculationManager.calculateInsurance(for: .chinaTruck, invoiceAmount: item.calculationData.invoiceAmount, cellPriceCurrency: item.itemCellPriceCurrency, invoiceCurrency: currencyCode).formatAsCurrency(symbol: item.itemCellPriceCurrency)
        cell.subtitle.text = "\(PriceCalculationManager.getInsurancePersentage(for: .chinaTruck))% от стоимости инвойса \n\(item.calculationData.invoiceAmount.formatAsCurrency(symbol: currencyCode)), 1 \(item.itemCellPriceCurrency.symbol) ~ \(ratio) \(currencyCode.symbol)"
        
        removeDaysContent(in: cell)
        cell.removeShimmerAnimation()
    }
    
    static func configureDeliveryFromWarehouse(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "Шанхай - Подольск".makeAttributed(icon: Icons.map, size: (0, -2, 22, 16), placeIcon: .beforeText)
        cell.priceLabel.text = "\(PriceCalculationManager.getDeliveryFromWarehouse(for: .chinaTruck, weight: item.calculationData.weight, volume: item.calculationData.volume).formatAsCurrency(symbol: item.itemCellPriceCurrency))"
        
        removeDaysContent(in: cell)
        cell.removeShimmerAnimation()
    }
    
    static func configureCargoHandling(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        let handlingData = PriceCalculationManager.getCagoHandlingData(for: .chinaTruck)
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.text = "\(handlingData.pricePerKg.formatAsCurrency(symbol: item.itemCellPriceCurrency)) за кг, минимум \(handlingData.minPrice.formatAsCurrency(symbol: item.itemCellPriceCurrency))"
        cell.priceLabel.text = "\(PriceCalculationManager.calculateCargoHandling(for: .chinaTruck, weight: item.calculationData.weight).formatAsCurrency(symbol: item.itemCellPriceCurrency))"
        
        removeDaysContent(in: cell)
        cell.removeShimmerAnimation()
    }
    
    static func configureCustomsClearancePrice(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "Свидетельство таможенного представителя № 0998/00".makeAttributed(icon: Icons.document, size: (0, -3, 18, 17), placeIcon: .beforeText)
        cell.priceLabel.text = "\(PriceCalculationManager.getCustomsClearancePrice(for: .chinaTruck).formatAsCurrency(symbol: item.itemCellPriceCurrency))"
        
        removeDaysContent(in: cell)
        cell.removeShimmerAnimation()
    }
    
    static func configureCustomsWarehouseServices(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "Включено 2 дня ожидания".makeAttributed(icon: Icons.clock, size: (0, -2, 18, 17), placeIcon: .beforeText)
        cell.priceLabel.text = "\(PriceCalculationManager.getCustomsWarehouseServices(for: .chinaTruck).formatAsCurrency(symbol: item.itemCellPriceCurrency))"
        
        removeDaysContent(in: cell)
        cell.removeShimmerAnimation()
    }
    
    static func configureDeliveryToWarehouse(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        let deliveryData = PriceCalculationManager.getDeliveryToWarehouseData(forCountry: .china, city: item.calculationData.fromLocation)
        let days = deliveryData.warehouseName.flcWarehouseFromRusName == .guangzhou ? "\(deliveryData.transitDays + 4) дн." : "\(deliveryData.transitDays) дн."
        let addShaghaiWarehouse = deliveryData.warehouseName.flcWarehouseFromRusName == .guangzhou ? "- Склад Шанхай" : ""
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "\(item.calculationData.fromLocation) - Склад \(deliveryData.warehouseName) \(addShaghaiWarehouse)".makeAttributed(icon: Icons.map, size: (0, -2, 22, 16), placeIcon: .beforeText)
        cell.daysTextView.attributedText = days.makeAttributed(icon: Icons.questionMark, tint: .lightGray, size: (0, -4, 22, 21), placeIcon: .afterText)
        cell.priceLabel.text = "\(PriceCalculationManager.getDeliveryToWarehouse(forCountry: .china, city: item.calculationData.fromLocation, weight: item.calculationData.weight, volume: item.calculationData.volume).formatAsCurrency(symbol: item.itemCellPriceCurrency))"
        
        cell.removeShimmerAnimation()
    }
    
    private static func removeDaysContent(in cell: CalculationResultCell) {
        cell.daysLabelHeightConstraint.constant = 0.1
        cell.subtitleBottomConstraint.constant = -cell.padding
    }
    
    static func configureTipMessage(in cell: CalculationResultCell, iconType: String) -> String {
        if iconType == "questionmark.circle.fill" {
            guard let item = cell.calculationResultItem else { return "" }
            let deliveryData = PriceCalculationManager.getDeliveryToWarehouseData(forCountry: .china, city: item.calculationData.fromLocation)
            
            if deliveryData.warehouseName.flcWarehouseFromRusName == .guangzhou {
                return "Поставщик - Склад Гуанчжоу: \(deliveryData.transitDays) дн. \nСклад Гуанчжоу - Склад Шанхай: 4 дн."
            } else {
                return "Доставка с адреса поставщика до нашего склада в Шанхае."
            }
        } else {
            switch cell.type {
            case .russianDelivery:
                return "Наш партнёр по доставке - ПЭК. Груз будет доставлен для Вас согласно высочайшим стандартам компании."
            case .insurance:
                return "Наш многолетний партнёр по страхованию - компания СК Пари. Страховка от полной стоимости инвойса."
            case .deliveryFromWarehouse:
                return "Отправляемся из Шанхая каждые вторник и пятницу. Выезд из Гуанчжоу каждую пятницу под выход из Шанхая во вторник."
            case .cargoHandling:
                return "Включены все операции по загрузке и выгрузке Вашего груза от склада отправления до склада назначения."
            case .customsClearancePrice:
                return "В стоимость входит подача Таможенной Декларации, услуги брокера и ЭЦП брокера."
            case .customsWarehouseServices:
                return "Услуги таможенного Склада Временного Хранения на время оформления груза. Дополнительные услуги по погрузке, разгрузке, хранению сверх норматива оплачиваются по тарифу с СВХ отдельно."
            case .deliveryToWarehouse:
                return  "Доставка с адреса поставщика до нашего Склада Консолидации для последующей отправки в Россию"
            }
        }
    }
}
