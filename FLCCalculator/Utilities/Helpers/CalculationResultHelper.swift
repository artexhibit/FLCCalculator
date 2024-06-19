import UIKit

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
        let price = PriceCalculationManager.getDeliveryFromWarehouse(for: pickedLogisticsType, item: item).formatAsCurrency(symbol: item.currency)
        let days = "от " + PriceCalculationManager.getDeliveryFromWarehouseTransitTime(for: pickedLogisticsType) + " дн."
        return (price, days)
    }
    
    static func getCargoHandlingPrice(item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> String {
        PriceCalculationManager.calculateCargoHandling(for: pickedLogisticsType, item: item, weight: item.calculationData.weight).formatAsCurrency(symbol: item.currency)
    }
    
    static func getCustomsClearancePrice(item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> String {
        PriceCalculationManager.getCustomsClearancePrice(for: pickedLogisticsType).formatAsCurrency(symbol: item.currency)
    }
    
    static func getCustomsWarehouseServicesPrice(item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> String {
        PriceCalculationManager.getCustomsWarehouseServices(for: pickedLogisticsType).formatAsCurrency(symbol: item.currency)
    }
    
    static func getGroupageDocs(item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> String {
        PriceCalculationManager.getGroupageDocs(for: pickedLogisticsType, item: item).formatAsCurrency(symbol: item.currency)
    }
    
    static func getDeliveryToWarehousePrice(logisticsType: FLCLogisticsType, item: CalculationResultItem) -> (price: String, days: String, isGuangzhou: Bool, warehouseName: String) {
        let deliveryData = PriceCalculationManager.getDeliveryToWarehouse(item: item, logisticsType: logisticsType)
        let isGuangzhou = deliveryData.warehouseName.flcWarehouseFromRusName == .guangzhou
        let days = isGuangzhou ? "\((Int(deliveryData.transitDays) ?? 1) + 4) дн." : "\(deliveryData.transitDays) дн."
        
        let price = PriceCalculationManager.getDeliveryToWarehouse(item: item, logisticsType: logisticsType).result.formatAsCurrency(symbol: item.currency)
        return (price, days, isGuangzhou, deliveryData.warehouseName)
    }
    
    static func configureInitialData(with data: CalculationData, pickedLogisticsType: FLCLogisticsType) -> [CalculationResultItem] {
        var baseItems: [CalculationResultItem]
        
        switch pickedLogisticsType {
        case .chinaTruck, .chinaRailway:
            baseItems = getBaseItems(with: data, rusWarehouse: WarehouseStrings.russianWarehouseCity, pickedLogisticsType: pickedLogisticsType)
            
        case .chinaAir:
            baseItems = getLogisticsItems(with: data, pickedLogisticsType: pickedLogisticsType).map { item in
                var newItem = item
                
                switch newItem.type {
                case .russianDelivery:
                    if data.toLocation == WarehouseStrings.russianWarehouseCity { newItem.canDisplay = false }
                    
                case .customsClearancePrice:
                    if !data.needCustomClearance { newItem.canDisplay = false }
                    
                case .customsWarehouseServices:
                    newItem.canDisplay = false
                    
                case .deliveryToWarehouse:
                    if data.deliveryTypeCode != FLCDeliveryTypeCodes.EXW.rawValue { newItem.canDisplay = false }
                    
                case .deliveryFromWarehouse:
                    newItem.title = "Авиаперевозка"
                    
                case .groupageDocs:
                    newItem.title = "Авианакладная"
                    
                case .insurance, .cargoHandling:
                    break
                }
                return newItem
            }
        case .turkeyTruckByFerry:
            baseItems = getBaseItems(with: data, rusWarehouse: WarehouseStrings.russianWarehouseCity, pickedLogisticsType: pickedLogisticsType)
        }
        return baseItems.filter { $0.canDisplay == true }
    }
    
    private static func getBaseItems(with data: CalculationData, rusWarehouse: String, pickedLogisticsType: FLCLogisticsType) -> [CalculationResultItem] {
        
        return getLogisticsItems(with: data, pickedLogisticsType: pickedLogisticsType).map { item in
            var newItem = item
            
            switch newItem.type {
            case .russianDelivery:
                if data.toLocation == rusWarehouse { newItem.canDisplay = false }
                
            case .customsClearancePrice:
                if !data.needCustomClearance { newItem.canDisplay = false }
                
            case .deliveryToWarehouse:
                if data.deliveryTypeCode != FLCDeliveryTypeCodes.EXW.rawValue { newItem.canDisplay = false }
                
            case .deliveryFromWarehouse, .cargoHandling, .customsWarehouseServices, .insurance, .groupageDocs:
                break
            }
            return newItem
        }
    }
    
    private static func getLogisticsItems(with data: CalculationData, pickedLogisticsType: FLCLogisticsType) -> [CalculationResultItem] {
        var items = [CalculationResultItem]()
        let cargoHandlingCurrency: FLCCurrency = pickedLogisticsType == .chinaAir ? .RUB : .USD
        
        let russianDeliveryItem = CalculationResultItem(type: .russianDelivery, calculationData: data, title: "Доставка по России", currency: .RUB)
        let insuranceItem = CalculationResultItem(type: .insurance, calculationData: data, title: "Страхование", currency: .USD)
        let deliveryFromWarehouseItem = CalculationResultItem(type: .deliveryFromWarehouse, calculationData: data, title: "Перевозка Сборного Груза", currency: .USD)
        let cargoHandling = CalculationResultItem(type: .cargoHandling, calculationData: data, title: "Погрузо-разгрузочные работы", currency: cargoHandlingCurrency)
        let customsClearancePriceItem = CalculationResultItem(type: .customsClearancePrice, calculationData: data, title: "Услуги по Таможенному Оформлению", currency: .RUB)
        let customsWarehouseServicesItem = CalculationResultItem(type: .customsWarehouseServices, calculationData: data, title: "Услуги СВХ", currency: .RUB)
        let deliveryToWarehouseItem = CalculationResultItem(type: .deliveryToWarehouse, calculationData: data, title: "Доставка до Склада Консолидации", currency: .USD)
        let groupageDocs = CalculationResultItem(type: .groupageDocs, calculationData: data, title: "Оформление пакета документов", currency: .USD)
        
        items.append(contentsOf: [russianDeliveryItem, insuranceItem, deliveryFromWarehouseItem, cargoHandling, customsClearancePriceItem, customsWarehouseServicesItem, deliveryToWarehouseItem, groupageDocs])
        return items
    }
    
    static func getOptions(basedOn availableLogisticsTypes: [FLCLogisticsType]) -> [FLCLogisticsOption] {
        let predefinedOptions: [FLCLogisticsType: FLCLogisticsOption] = [
            .chinaTruck: FLCLogisticsOption(image: Icons.truckFill, title: "Авто", type: .chinaTruck),
            .chinaRailway: FLCLogisticsOption(image: Icons.train, title: "ЖД", type: .chinaRailway),
            .chinaAir: FLCLogisticsOption(image: Icons.plane, title: "Авиа", type: .chinaAir),
            .turkeyTruckByFerry: FLCLogisticsOption(image: Icons.truckFill, title: "Авто+Паром", type: .turkeyTruckByFerry)
        ]
        return availableLogisticsTypes.compactMap { predefinedOptions[$0] }
    }
    
    static func getAvailableLogisticsTypes(for country: FLCCountryOption, and calcData: CalculationData) -> [FLCLogisticsType] {
        if calcData.isFromCoreData {
            guard let calculation = CoreDataManager.getCalculation(withID: calcData.id) else { return [.chinaTruck] }
            let items: [FLCLogisticsType] = CoreDataManager.decodeDataToItems(data: calculation.logisticsTypes ?? Data()) ?? [.chinaTruck]
          return items
        } else {
            let availableLogisticsTypes: [AvailableLogisticsType]? = CoreDataManager.retrieveItemsFromCoreData()
            return availableLogisticsTypes?
                .filter { $0.isAvailable && $0.country == country.engName }
                .compactMap { FLCLogisticsType(rawValue: $0.logisticsTypeName) } ?? [.chinaTruck]
        }
    }
    
    static func saveNetworkingData(oldItems: [CalculationResultItem], newItems: [CalculationResultItem]) -> [CalculationResultItem] {
        let russianDeliveryItem = oldItems.filter { $0.type == .russianDelivery }
        let filteredNewItems = newItems.filter { $0.type != .russianDelivery }
        return russianDeliveryItem + filteredNewItems
    }
    
    static func getAllCalculationsFor(allLogisticsTypes: [FLCLogisticsType], calculationData: CalculationData) async -> [TotalPriceData] {
        var totalPriceDataItems = [TotalPriceData]()
        
        for logisticsType in allLogisticsTypes {
            let data = await setupTotalPriceData(logisticsType: logisticsType, calculationData: calculationData)
            totalPriceDataItems.append(data)
        }
        return totalPriceDataItems
    }
    
    static func getPickedTotalPriceData(with calcData: CalculationData?, pickedLogisticsType: FLCLogisticsType) -> TotalPriceData? {
        guard let calcData = calcData else { return nil }
        if  calcData.isFromCoreData {
            return calcData.totalPrices?.first(where: { $0.logisticsType == pickedLogisticsType })
        }
        return nil
    }
    
    static func getResultForRussianDelivery(calcData: CalculationData, pickedTotalPriceData: TotalPriceData?, item: CalculationResultItem) async -> Result<(price: String, days: String), FLCError> {
        if calcData.isFromCoreData && pickedTotalPriceData?.russianDeliveryPrice != "0" {
            return .success((pickedTotalPriceData?.russianDeliveryPrice ?? "", pickedTotalPriceData?.russianDeliveryTime ?? ""))
        } else {
            return await getRussianDeliveryPrice(item: item)
        }
    }
    
    static func getResultForDeliveryToWarehouse(calcData: CalculationData, pickedTotalPriceData: TotalPriceData?, item: CalculationResultItem, logisticsType: FLCLogisticsType) -> (price: String, days: String, isGuangzhou: Bool, warehouseName: String) {
        if calcData.isFromCoreData {
            return (pickedTotalPriceData?.deliveryToWarehousePrice ?? "", pickedTotalPriceData?.deliveryToWarehouseTime ?? "", false, "")
        } else {
            return CalculationResultHelper.getDeliveryToWarehousePrice(logisticsType: logisticsType, item: item)
        }
    }
    
    static func getResultForDeliveryFromWarehouse(calcData: CalculationData, pickedTotalPriceData: TotalPriceData?, item: CalculationResultItem, pickedLogisticsType: FLCLogisticsType) -> (price: String, days: String) {
        if calcData.isFromCoreData {
            return (pickedTotalPriceData?.deliveryFromWarehousePrice ?? "", pickedTotalPriceData?.deliveryFromWarehouseTime ?? "")
        } else {
            return getDeliveryFromWarehousePrice(item: item, pickedLogisticsType: pickedLogisticsType)
        }
    }
    
    static func saveRefetchedRussianDelivery(calcData: CalculationData, pickedTotalPriceData: TotalPriceData?, items: ((price: String, days: String))) {
        if calcData.isFromCoreData && pickedTotalPriceData?.russianDeliveryPrice == "0" {
            let results = CoreDataManager.getCalculationResults(forCalculationID: calcData.id)
            results?.forEach({ result in
                result.russianDeliveryPrice = items.price
                result.russianDeliveryTime = items.days
            })
            Persistence.shared.saveContext()
        }
    }
    
    static func saveConfirmedStatusForRefetchedResult(calcData: CalculationData, pickedLogisticsType: FLCLogisticsType) {
        let calculation = CoreDataManager.getCalculation(withID: calcData.id)
        let results = calculation?.result as? Set<CalculationResult>
        let confirmedResult = results?.first(where: { $0.logisticsType == pickedLogisticsType.rawValue })
        
        calculation?.isConfirmed = true
        calculation?.totalPrice = confirmedResult?.totalPrice
        calculation?.calculationConfirmDate = Date()
        confirmedResult?.isConfirmed = true
        Persistence.shared.saveContext()
    }
    
    @MainActor
    static func setupTotalPriceData(logisticsType: FLCLogisticsType, calculationData: CalculationData) async -> TotalPriceData {
        var totalPriceData = TotalPriceData()
        var items = CalculationResultHelper.configureInitialData(with: calculationData, pickedLogisticsType: logisticsType)
        var russianDeliveryResult: Result<(price: String, days: String), FLCError>? = nil
        
        if items.contains(where: { $0.type == .russianDelivery }) {
            if let russianDeliveryItem = items.first(where: { $0.type == .russianDelivery }) {
                russianDeliveryResult = await getResultForRussianDelivery(calcData: calculationData, pickedTotalPriceData: getPickedTotalPriceData(with: calculationData, pickedLogisticsType: logisticsType), item: russianDeliveryItem)
            }
        }
        
        for (index, item) in items.enumerated() {
            totalPriceData.logisticsType = logisticsType
            
            switch item.type {
            case .russianDelivery:
                if let result = russianDeliveryResult {
                    switch result {
                    case .success(let resultItems):
                        totalPriceData.russianDeliveryPrice = resultItems.price
                        totalPriceData.russianDeliveryTime = resultItems.days
                        items[index].price = resultItems.price
                        items[index].daysAmount = resultItems.days
                        
                    case .failure(_):
                        totalPriceData.russianDeliveryPrice = "0"
                        totalPriceData.russianDeliveryTime = "0"
                        items[index].price = "0"
                        items[index].daysAmount = "0"
                    }
                }
            case .insurance:
                let result = CalculationResultHelper.getInsurancePrice(item: item, pickedLogisticsType: logisticsType)
                let currencyCode = FLCCurrency(currencyCode: item.calculationData.invoiceCurrency) ?? .USD
                
                totalPriceData.insurance = result.price
                totalPriceData.insurancePercentage = PriceCalculationManager.getInsurancePercentage(for: logisticsType)
                totalPriceData.insuranceRatio = PriceCalculationManager.getRatioBetween(item.currency, and: currencyCode)
                items[index].price = result.price
            case .deliveryFromWarehouse:
                let result = CalculationResultHelper.getDeliveryFromWarehousePrice(item: item, pickedLogisticsType: logisticsType)
                totalPriceData.deliveryFromWarehousePrice = result.price
                totalPriceData.deliveryFromWarehouseTime = result.days
                totalPriceData.minLogisticsProfit = PriceCalculationManager.getChinaAirTariff()?.first?.minLogisticsProfit
                
                items[index].price = result.price
                items[index].daysAmount = result.days
            case .cargoHandling:
                let result = CalculationResultHelper.getCargoHandlingPrice(item: item, pickedLogisticsType: logisticsType)
                let cargoHandlingData = PriceCalculationManager.getCargoHandlingData(for: logisticsType, item: item)
                
                totalPriceData.cargoHandling = result
                totalPriceData.cargoHandlingPricePerKg = cargoHandlingData.pricePerKg
                totalPriceData.cargoHandlingMinPrice = cargoHandlingData.minPrice
                totalPriceData.insuranceAgentVisit = PriceCalculationManager.getChinaAirTariff()?.first?.insuranceAgentVisit
                items[index].price = result
            case .customsClearancePrice:
                let result = CalculationResultHelper.getCustomsClearancePrice(item: item, pickedLogisticsType: logisticsType)
                totalPriceData.customsClearance = result
                items[index].price = result
            case .customsWarehouseServices:
                let result = CalculationResultHelper.getCustomsWarehouseServicesPrice(item: item, pickedLogisticsType: logisticsType)
                totalPriceData.customsWarehousePrice = result
                items[index].price = result
            case .deliveryToWarehouse:
                let result = CalculationResultHelper.getDeliveryToWarehousePrice(logisticsType: logisticsType, item: item)
                totalPriceData.deliveryToWarehousePrice = result.price
                totalPriceData.deliveryToWarehouseTime = result.days
                items[index].price = result.price
                items[index].daysAmount = result.days
            case .groupageDocs:
                let result = CalculationResultHelper.getGroupageDocs(item: item, pickedLogisticsType: logisticsType)
                totalPriceData.groupageDocs = result
                items[index].price = result
            }
        }
        totalPriceData.totalPrice = CalculationHelper.calculateTotalPrice(prices: items.compactMap { $0.price })
        totalPriceData.totalTime = CalculationHelper.calculateTotalDays(days: items.compactMap { $0.daysAmount })
        return totalPriceData
    }
    
    static func saveCalculationInCoreData(totalPriceDataItems: [TotalPriceData], pickedLogisticsType: FLCLogisticsType, calcData: CalculationData?, isConfirmed: Bool = false) {
        guard let calcData = calcData else { return }
        let newTotalPriceDataItems = setConfirmedLogisticsType(totalPriceDataItems: totalPriceDataItems, pickedLogisticsType: pickedLogisticsType)
        CoreDataManager.createCalculationRecord(with: calcData, totalPriceData: newTotalPriceDataItems, pickedLogisticsType: pickedLogisticsType, isConfirmed: isConfirmed)
    }
    
    static func createCalculationResultVC(data: CalculationData, from vc: UIViewController) {
        let calculationResultVC = CalculationResultVC()
        calculationResultVC.setCalculationData(data: data)
        vc.navigationController?.pushViewController(calculationResultVC, animated: true)
    }
    
    static func createConfirmOrderVC(data: CalculationData, in vc: UIViewController) {
        let confirmOrderVC = ConfirmOrderVC()
        let calculation = CoreDataManager.getCalculation(withID: data.id + 1)
        confirmOrderVC.getConfirmedCalculationData(calculation: calculation)
        vc.navigationController?.pushViewController(confirmOrderVC, animated: true)
    }
    
    static func getConfirmedLogisticsType(calcData: CalculationData) -> FLCLogisticsType {
        let results = CoreDataManager.getCalculationResults(forCalculationID: calcData.id)
        let confirmedLogisticsType = results?.first(where: { $0.isConfirmed })?.logisticsType ?? ""
        return FLCLogisticsType(rawValue: confirmedLogisticsType) ?? .chinaTruck
    }
    
    private static func setConfirmedLogisticsType(totalPriceDataItems: [TotalPriceData], pickedLogisticsType: FLCLogisticsType) -> [TotalPriceData] {
        return totalPriceDataItems.map { item in
            var modifiedItem = item
            if modifiedItem.logisticsType == pickedLogisticsType { modifiedItem.isConfirmed = true }
            return modifiedItem
        }
    }
    
    static func manageCalculationDocument(with data: CalculationData, and totalPriceData: [TotalPriceData]) async {
        let calcEntryData = FirebaseManager.createCalculationDataFirebaseRecord(with: data, and: totalPriceData)
        
        if NetworkStatusManager.shared.isDeviceOnline {
            await FirebaseManager.createCalculationDocument(with: calcEntryData)
        } else {
            var storedRecords: [CalculationDataFirebaseRecord] = UserDefaultsPercistenceManager.retrieveItemsFromUserDefaults() ?? [CalculationDataFirebaseRecord]()
            
            storedRecords.append(calcEntryData)
            _ = UserDefaultsPercistenceManager.saveItemsToUserDefaults(items: storedRecords)
        }
    }
}
