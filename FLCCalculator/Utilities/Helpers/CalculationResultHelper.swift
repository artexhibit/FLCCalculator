import Foundation

struct CalculationResultHelper {
    static func getRussianDeliveryPrice(item: CalculationResultItem) async -> Result<(price: String, days: String), FLCError> {
        do {
            let data = try await NetworkManager.shared.getRussianDelivery(for: item)
            let price = data.getPrice().add(markup: .seventeenPercents).formatAsCurrency(symbol: item.currency)
            let days = data.getDays() ?? ""
            return .success((price, days))
        } catch {
            return .failure(.invalidResponce)
        }
    }
    
    static func getInsurancePrice(item: CalculationResultItem) -> (code: FLCCurrency, ratio: Double, price: String) {
        let currencyCode = FLCCurrency(currencyCode: item.calculationData.invoiceCurrency) ?? .USD
        let ratio = PriceCalculationManager.getRatioBetween(item.currency, and: currencyCode)
        
        let price = PriceCalculationManager.calculateInsurance(for: .chinaTruck, invoiceAmount: item.calculationData.invoiceAmount, cellPriceCurrency: item.currency, invoiceCurrency: currencyCode).formatAsCurrency(symbol: item.currency)
        return (currencyCode, ratio, price)
    }
    
    static func getDeliveryFromWarehousePrice(item: CalculationResultItem) -> (price: String, days: String) {
       let price = PriceCalculationManager.getDeliveryFromWarehouse(for: .chinaTruck, weight: item.calculationData.weight, volume: item.calculationData.volume).formatAsCurrency(symbol: item.currency)
        let days = "от " + PriceCalculationManager.getDeliveryFromWarehouseTransitTime(for: .chinaTruck) + " дн."
        return (price, days)
    }
    
    static func getCargoHandlingPrice(item: CalculationResultItem) -> String {
        PriceCalculationManager.calculateCargoHandling(for: .chinaTruck, weight: item.calculationData.weight).formatAsCurrency(symbol: item.currency)
    }
    
    static func getCustomsClearancePrice(item: CalculationResultItem) -> String {
        PriceCalculationManager.getCustomsClearancePrice(for: .chinaTruck).formatAsCurrency(symbol: item.currency)
    }
    
    static func getCustomsWarehouseServicesPrice(item: CalculationResultItem) -> String {
        PriceCalculationManager.getCustomsWarehouseServices(for: .chinaTruck).formatAsCurrency(symbol: item.currency)
    }
    
    static func getDeliveryToWarehousePrice(item: CalculationResultItem) -> (price: String, days: String, isGuangzhou: Bool, warehouseName: String) {
        let deliveryData = PriceCalculationManager.getDeliveryToWarehouse(forCountry: .china, city: item.calculationData.fromLocation, weight: item.calculationData.weight, volume: item.calculationData.volume)
        let isGuangzhou = deliveryData.warehouseName.flcWarehouseFromRusName == .guangzhou
        let days = isGuangzhou ? "\(deliveryData.transitDays + 4) дн." : "\(deliveryData.transitDays) дн."
        
        let price = PriceCalculationManager.getDeliveryToWarehouse(forCountry: .china, city: item.calculationData.fromLocation, weight: item.calculationData.weight, volume: item.calculationData.volume).result.formatAsCurrency(symbol: item.currency)
        return (price, days, isGuangzhou, deliveryData.warehouseName)
    }
    
    static func configureInitialData(with data: CalculationData, pickedLogisticsType: FLCLogisticsType) -> [CalculationResultItem] {
        var baseItems: [CalculationResultItem]
        
        switch pickedLogisticsType {
        case .chinaTruck, .chinaRailway:
            baseItems = getGroundLogisticsItems(with: data).map { item in
                var modifiedItem = item
                
                switch modifiedItem.type {
                case .russianDelivery:
                    if data.toLocation == WarehouseStrings.russianWarehouseCity { modifiedItem.canDisplay = false }
                    
                case .customsClearancePrice:
                    if !data.needCustomClearance { modifiedItem.canDisplay = false }
                    
                case .deliveryToWarehouse:
                    if data.fromLocation == WarehouseStrings.chinaWarehouse { modifiedItem.canDisplay = false }
                    
                case .deliveryFromWarehouse, .cargoHandling, .customsWarehouseServices, .insurance:
                    break
                }
                return modifiedItem
            }
            
        case .chinaAir:
            baseItems = getGroundLogisticsItems(with: data)
        case .turkeyTruck:
            baseItems = getGroundLogisticsItems(with: data)
        }
        return baseItems.filter { $0.canDisplay == true }
    }
    
    private static func getGroundLogisticsItems(with data: CalculationData) -> [CalculationResultItem] {
        var items = [CalculationResultItem]()
        
        let russianDeliveryItem = CalculationResultItem(type: .russianDelivery, calculationData: data, title: "Доставка по России", currency: .RUB)
        let insuranceItem = CalculationResultItem(type: .insurance, calculationData: data, title: "Страхование", currency: .USD)
        let deliveryFromWarehouseItem = CalculationResultItem(type: .deliveryFromWarehouse, calculationData: data, title: "Перевозка Сборного Груза", currency: .USD)
        let cargoHandling = CalculationResultItem(type: .cargoHandling, calculationData: data, title: "Погрузо-разгрузочные работы", currency: .USD)
        let customsClearancePriceItem = CalculationResultItem(type: .customsClearancePrice, calculationData: data, title: "Услуги по Таможенному Оформлению", currency: .RUB)
        let customsWarehouseServicesItem = CalculationResultItem(type: .customsWarehouseServices, calculationData: data, title: "Услуги СВХ", currency: .RUB)
        let deliveryToWarehouseItem = CalculationResultItem(type: .deliveryToWarehouse, calculationData: data, title: "Доставка до Склада Консолидации", currency: .USD)
        
        items.append(contentsOf: [russianDeliveryItem, insuranceItem, deliveryFromWarehouseItem, cargoHandling, customsClearancePriceItem, customsWarehouseServicesItem, deliveryToWarehouseItem])
        return items
    }
}
