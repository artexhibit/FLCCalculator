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
    
    static func getInsurancePrice(item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> (code: FLCCurrency, ratio: Double, price: String) {
        let currencyCode = FLCCurrency(currencyCode: item.calculationData.invoiceCurrency) ?? .USD
        let ratio = PriceCalculationManager.getRatioBetween(item.currency, and: currencyCode)
        
        let price = PriceCalculationManager.calculateInsurance(for: pickedLogisticsType, invoiceAmount: item.calculationData.invoiceAmount, cellPriceCurrency: item.currency, invoiceCurrency: currencyCode).formatAsCurrency(symbol: item.currency)
        return (currencyCode, ratio, price)
    }
    
    static func getDeliveryFromWarehousePrice(item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> (price: String, days: String) {
       let price = PriceCalculationManager.getDeliveryFromWarehouse(for: pickedLogisticsType, weight: item.calculationData.weight, volume: item.calculationData.volume).formatAsCurrency(symbol: item.currency)
        let days = "от " + PriceCalculationManager.getDeliveryFromWarehouseTransitTime(for: pickedLogisticsType) + " дн."
        return (price, days)
    }
    
    static func getCargoHandlingPrice(item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> String {
        PriceCalculationManager.calculateCargoHandling(for: pickedLogisticsType, weight: item.calculationData.weight).formatAsCurrency(symbol: item.currency)
    }
    
    static func getCustomsClearancePrice(item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> String {
        PriceCalculationManager.getCustomsClearancePrice(for: pickedLogisticsType).formatAsCurrency(symbol: item.currency)
    }
    
    static func getCustomsWarehouseServicesPrice(item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> String {
        PriceCalculationManager.getCustomsWarehouseServices(for: pickedLogisticsType).formatAsCurrency(symbol: item.currency)
    }
    
    static func getGroupageDocs(item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> String {
        PriceCalculationManager.getGroupageDocs(for: pickedLogisticsType).formatAsCurrency(symbol: item.currency)
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
            baseItems = getBaseItems(with: data, rusWarehouse: WarehouseStrings.russianWarehouseCity, abroadWarehouse: WarehouseStrings.chinaWarehouse)
            
        case .chinaAir:
            baseItems = getLogisticsItems(with: data).map { item in
                var newItem = item
                
                switch newItem.type {
                case .russianDelivery:
                    if data.toLocation == WarehouseStrings.russianWarehouseCity { newItem.canDisplay = false }
                    
                case .customsClearancePrice:
                    if !data.needCustomClearance { newItem.canDisplay = false }
                    
                case .deliveryToWarehouse, .cargoHandling, .customsWarehouseServices:
                    newItem.canDisplay = false
                    
                case .deliveryFromWarehouse:
                    newItem.title = "Авиаперевозка"
                    
                case .insurance, .groupageDocs:
                    break
                }
                return newItem
            }
        case .turkeyTruck:
            baseItems = getBaseItems(with: data, rusWarehouse: WarehouseStrings.russianWarehouseCity, abroadWarehouse: WarehouseStrings.turkeyWarehouse)
        }
        return baseItems.filter { $0.canDisplay == true }
    }
    
    private static func getBaseItems(with data: CalculationData, rusWarehouse: String, abroadWarehouse: String) -> [CalculationResultItem] {
        
        return getLogisticsItems(with: data).map { item in
            var newItem = item
            
            switch newItem.type {
            case .russianDelivery:
                if data.toLocation == rusWarehouse { newItem.canDisplay = false }
                
            case .customsClearancePrice:
                if !data.needCustomClearance { newItem.canDisplay = false }
                
            case .deliveryToWarehouse:
                if data.fromLocation == abroadWarehouse { newItem.canDisplay = false }
                
            case .deliveryFromWarehouse, .cargoHandling, .customsWarehouseServices, .insurance, .groupageDocs:
                break
            }
            return newItem
        }
    }
    
    private static func getLogisticsItems(with data: CalculationData) -> [CalculationResultItem] {
        var items = [CalculationResultItem]()
        
        let russianDeliveryItem = CalculationResultItem(type: .russianDelivery, calculationData: data, title: "Доставка по России", currency: .RUB)
        let insuranceItem = CalculationResultItem(type: .insurance, calculationData: data, title: "Страхование", currency: .USD)
        let deliveryFromWarehouseItem = CalculationResultItem(type: .deliveryFromWarehouse, calculationData: data, title: "Перевозка Сборного Груза", currency: .USD)
        let cargoHandling = CalculationResultItem(type: .cargoHandling, calculationData: data, title: "Погрузо-разгрузочные работы", currency: .USD)
        let customsClearancePriceItem = CalculationResultItem(type: .customsClearancePrice, calculationData: data, title: "Услуги по Таможенному Оформлению", currency: .RUB)
        let customsWarehouseServicesItem = CalculationResultItem(type: .customsWarehouseServices, calculationData: data, title: "Услуги СВХ", currency: .RUB)
        let deliveryToWarehouseItem = CalculationResultItem(type: .deliveryToWarehouse, calculationData: data, title: "Доставка до Склада Консолидации", currency: .USD)
        let groupageDocs = CalculationResultItem(type: .groupageDocs, calculationData: data, title: "Оформление пакета документов", currency: .USD)
        
        items.append(contentsOf: [russianDeliveryItem, insuranceItem, deliveryFromWarehouseItem, cargoHandling, customsClearancePriceItem, customsWarehouseServicesItem, deliveryToWarehouseItem, groupageDocs])
        return items
    }
    
    static func getOptions(basedOn calculationData: CalculationData) -> [FLCLogisticsOption] {
        var options = [FLCLogisticsOption]()
        let pickedCountry = FLCCountryOption(rawValue: calculationData.countryFrom)
        
        let truckOption = FLCLogisticsOption(image: Icons.truckFill, title: "Авто")
        let trainOption = FLCLogisticsOption(image: Icons.train, title: "ЖД")
        let airOption = FLCLogisticsOption(image: Icons.plane, title: "Авиа")
        let truckPlusFerryOption = FLCLogisticsOption(image: Icons.truckFill, title: "Авто+Паром")
        
        switch pickedCountry {
        case .china:
            options.append(contentsOf: [truckOption, trainOption, airOption])
        case .turkey:
            options.append(contentsOf: [truckPlusFerryOption])
        case nil: break
        }
        return options
    }
    
    static func saveNetworkingData(oldItems: [CalculationResultItem], newItems: [CalculationResultItem]) -> [CalculationResultItem] {
        let russianDeliveryItem = oldItems.filter { $0.type == .russianDelivery }
        let filteredNewItems = newItems.filter { $0.type != .russianDelivery }
        return russianDeliveryItem + filteredNewItems
    }
}
