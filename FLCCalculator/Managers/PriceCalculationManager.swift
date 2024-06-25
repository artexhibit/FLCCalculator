import Foundation

final class PriceCalculationManager {
    private static let chinaTruckTariff: [ChinaTruckTariff]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let chinaRailwayTariff: [ChinaRailwayTariff]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let chinaAirTariff: [ChinaAirTariff]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let turkeyTruckByFerryTariff: [TurkeyTruckByFerryTariff]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let chinaTruckPickup: [ChinaTruckPickup]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let chinaRailwayPickup: [ChinaRailwayPickup]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let chinaAirPickup: [ChinaAirPickup]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let turkeyTruckByFerryPickup: [TurkeyTruckByFerryPickup]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let currencyData: CurrencyData? = CoreDataManager.retrieveItemFromCoreData()
    
    static func getInsurancePercentage(for logisticsType: FLCLogisticsType, item: CalculationResultItem? = nil) -> Double {
        let results = CoreDataManager.getCalculationResults(forCalculationID: item?.calculationData.id ?? 1)
        let targetResult = results?.first(where: { $0.logisticsType == logisticsType.rawValue })
        var insurancePercentage: Double = 0
        
        switch logisticsType {
        case .chinaTruck:
            insurancePercentage = chinaTruckTariff?.first?.insurancePercentage ?? 0
        case .chinaRailway:
            insurancePercentage = chinaRailwayTariff?.first?.insurancePercentage ?? 0
        case .chinaAir:
            insurancePercentage = chinaAirTariff?.first?.insurancePercentage ?? 0
        case .turkeyTruckByFerry:
            insurancePercentage = turkeyTruckByFerryTariff?.first?.insurancePercentage ?? 0
        }
        return item?.calculationData.isFromCoreData ?? false ? targetResult?.insurancePercentage ?? 0 : insurancePercentage
    }
    
    static func getRatioBetween(_ cellPriceCurrency: FLCCurrency, and invoiceCurrency: FLCCurrency) -> Double {
        let sellCurrencyKey = currencyData?.Valute.keys.first(where: { $0 == cellPriceCurrency.rawValue }) ?? ""
        let invoiceCurrencyKey = currencyData?.Valute.keys.first(where: { $0 == invoiceCurrency.rawValue }) ?? ""
        
        let sellCurrencyValue = currencyData?.Valute[sellCurrencyKey]?.Value ?? 0
        let invoiceCurrencyValue = currencyData?.Valute[invoiceCurrencyKey]?.Value ?? 0
        
        let sellCurrencyNominal = currencyData?.Valute[sellCurrencyKey]?.Nominal ?? 0
        let invoiceCurrencyNominal = currencyData?.Valute[invoiceCurrencyKey]?.Nominal ?? 0
        
        let sellAbsoluteCurrencyValue = sellCurrencyValue / Double(sellCurrencyNominal)
        let invoiceAbsoluteCurrencyValue = invoiceCurrencyValue / Double(invoiceCurrencyNominal)
        
        if invoiceCurrency == .RUB { return sellAbsoluteCurrencyValue }
        
        return (sellAbsoluteCurrencyValue / invoiceAbsoluteCurrencyValue).formatDecimalsTo(amount: 2)
    }
    
    static func calculateInsurance(for logisticsType: FLCLogisticsType, invoiceAmount: Double, cellPriceCurrency: FLCCurrency, invoiceCurrency: FLCCurrency) -> Double {
        let ratio = getRatioBetween(cellPriceCurrency, and: invoiceCurrency)
        let insurancePercentage = getInsurancePercentage(for: logisticsType)
        let invoiceAmountInSellCurrency = invoiceAmount / ratio
        
        return (invoiceAmountInSellCurrency * insurancePercentage) / 100
    }
    
    static func getDeliveryFromWarehouse(for logisticsType: FLCLogisticsType, item: CalculationResultItem) -> Double {
        switch logisticsType {
        case .chinaTruck:
            return getGroundDeliveryFromWarehousePrice(tariff: chinaTruckTariff ?? [], weight: item.calculationData.weight, volume: item.calculationData.volume)
        case .chinaRailway:
            return getGroundDeliveryFromWarehousePrice(tariff: chinaRailwayTariff ?? [], weight: item.calculationData.weight, volume: item.calculationData.volume)
        case .chinaAir:
            return getAirDeliveryFromWarehousePrice(item: item)
        case .turkeyTruckByFerry:
            return getGroundDeliveryFromWarehousePrice(tariff: turkeyTruckByFerryTariff ?? [], weight: item.calculationData.weight, volume: item.calculationData.volume)
        }
    }
    
   private static func getGroundDeliveryFromWarehousePrice<T: AnyTariffDataConvertible>(tariff: [T], weight: Double, volume: Double) -> Double {
        guard let logisticsTypeData = tariff.first else { return 0 }
        let densityCoefficient = weight / volume
        
        let targetTariffs = densityCoefficient > logisticsTypeData.targetWeight ? logisticsTypeData.tariffsList.weight : logisticsTypeData.tariffsList.volume
        let targetParameter = densityCoefficient > logisticsTypeData.targetWeight ? weight : volume
        
        let range = targetTariffs.first(where: { $0.key.createRange()?.contains(targetParameter) == true })
        let value = range?.value ?? 0
        let price = densityCoefficient > logisticsTypeData.targetWeight ? weight * value : volume * value
       
        return price > logisticsTypeData.minLogisticsPrice ? price : logisticsTypeData.minLogisticsPrice
    }
    
    private static func getAirDeliveryFromWarehousePrice(item: CalculationResultItem) -> Double {
        let results = CoreDataManager.getCalculationResults(forCalculationID: item.calculationData.id)
        let targetResult = results?.first(where: { $0.logisticsType == FLCLogisticsType.chinaAir.rawValue })
        
        let targetWeight = chinaAirTariff?.first?.targetWeight ?? 0
        let minLogisticsProfit = item.calculationData.isFromCoreData ? targetResult?.minLogisticsProfit ?? 0 : chinaAirTariff?.first?.minLogisticsProfit ?? 0
        let chargeableWeight = max(item.calculationData.weight, targetWeight * item.calculationData.volume)
        
        let targetCity = chinaAirPickup?.first?.cities.first(where: { $0.targetCities.contains(where: { $0.contains(item.calculationData.departureAirport) }) })
        let targetTariffs = chinaAirTariff?.first?.cities.first(where: { $0.name.lowercased() == targetCity?.targetAirport.lowercased() })
        
        let airPriceNetto = (targetTariffs?.prices.first(where: { $0.key.createRange()?.contains(chargeableWeight) == true })?.value.pricePerKg ?? 0) * chargeableWeight
        let airPriceBrutto = airPriceNetto.add(markup: .fourteenPercents)
        let awbNetto = getAviaGroupageDocs(item: item).netto
        let awbBrutto = getAviaGroupageDocs(item: item).brutto
        
        let totalPriceNetto = airPriceNetto + awbNetto
        let totalPriceBrutto = airPriceBrutto + awbBrutto
        let profit = totalPriceBrutto - totalPriceNetto
        
        return profit < minLogisticsProfit ? (totalPriceNetto - awbBrutto) + minLogisticsProfit : airPriceBrutto
    }
    
    static func getDeliveryFromWarehouseTransitTime(for logisticsType: FLCLogisticsType) -> String {
        switch logisticsType {
        case .chinaTruck: return String(chinaTruckTariff?.first?.transitDays ?? 0)
        case .chinaRailway: return String(chinaRailwayTariff?.first?.transitDays ?? 0)
        case .chinaAir: return String(chinaAirTariff?.first?.transitDays ?? 0)
        case .turkeyTruckByFerry: return String(turkeyTruckByFerryTariff?.first?.transitDays ?? 0)
        }
    }
    
    static func getCargoHandlingData(for logisticsType: FLCLogisticsType, item: CalculationResultItem? = nil) -> (pricePerKg: Double, minPrice: Double?) {
        let results = CoreDataManager.getCalculationResults(forCalculationID: item?.calculationData.id ?? 0)
        let targetResult = results?.first(where: { $0.logisticsType == logisticsType.rawValue })
        var result: (pricePerKg: Double, minPrice: Double?)
        
        switch logisticsType {
        case .chinaTruck:
            result = (chinaTruckTariff?.first?.cargoHandling ?? 0, chinaTruckTariff?.first?.minCargoHandling ?? 0)
        case .chinaRailway:
            result = (chinaRailwayTariff?.first?.cargoHandling ?? 0, chinaRailwayTariff?.first?.minCargoHandling ?? 0)
        case .chinaAir:
            result = (getAirCargoHandlingData(logisticsType: logisticsType, item: item), nil)
        case .turkeyTruckByFerry:
            result = (turkeyTruckByFerryTariff?.first?.cargoHandling ?? 0, turkeyTruckByFerryTariff?.first?.minCargoHandling ?? 0)
        }
        return item?.calculationData.isFromCoreData ?? false ? (targetResult?.cargoHandlingPricePerKg ?? 0, targetResult?.cargoHandlingMinPrice ?? 0) : result
    }
    
    private static func getAirCargoHandlingData(logisticsType: FLCLogisticsType, item: CalculationResultItem?) -> Double {
        let results = CoreDataManager.getCalculationResults(forCalculationID: item?.calculationData.id ?? 1)
        let targetResult = results?.first(where: { $0.logisticsType == logisticsType.rawValue })
        
        let volume = item?.calculationData.volume ?? 0
        let weight = item?.calculationData.weight ?? 0
        let targetWeight = chinaAirTariff?.first?.targetWeight ?? 0
        let chargeableWeight = max(weight, targetWeight * volume)
        let formalitiesCompletionPrice = chinaAirTariff?.first?.formalitiesCompletion ?? 0
        let cargoArrivalNotificationPrice = (chinaAirTariff?.first?.cargoArrivalNotification ?? 0).add(markup: .tenPercents)
        let documentsCopiesMakingPrice = (chinaAirTariff?.first?.documentsCopiesMaking ?? 0).add(markup: .tenPercents)
        let airportWarehouseStoragePrice = (chargeableWeight * (chinaAirTariff?.first?.airportWarehouseStorage ?? 0)).add(markup: .twentyPercents)
        let insuranceAgentVisitPrice = item?.calculationData.isFromCoreData ?? false ? targetResult?.insuranceAgentVisit ?? 0 : chinaAirTariff?.first?.insuranceAgentVisit ?? 0
        
        return ((chargeableWeight * (chinaAirTariff?.first?.cargoHandling ?? 0).add(markup: .tenPercents)) + formalitiesCompletionPrice + cargoArrivalNotificationPrice + documentsCopiesMakingPrice + airportWarehouseStoragePrice + insuranceAgentVisitPrice) / weight
    }
    
    static func calculateCargoHandling(for logisticsType: FLCLogisticsType, item: CalculationResultItem, weight: Double) -> Double {
        let handlingData = getCargoHandlingData(for: logisticsType, item: item)
        return (handlingData.pricePerKg * weight > handlingData.minPrice ?? 0) ? handlingData.pricePerKg * weight : handlingData.minPrice ?? 0
    }
    
    static func getCustomsClearancePrice(for logisticsType: FLCLogisticsType) -> Double {
        switch logisticsType {
        case .chinaTruck: return chinaTruckTariff?.first?.customsClearance ?? 0
        case .chinaRailway: return chinaRailwayTariff?.first?.customsClearance ?? 0
        case .chinaAir: return chinaAirTariff?.first?.customsClearance ?? 0
        case .turkeyTruckByFerry: return turkeyTruckByFerryTariff?.first?.customsClearance ?? 0
        }
    }
    
    static func getCustomsWarehouseServices(for logisticsType: FLCLogisticsType) -> Double {
        switch logisticsType {
        case .chinaTruck: return chinaTruckTariff?.first?.customsWarehousePrice ?? 0
        case .chinaRailway: return chinaRailwayTariff?.first?.customsWarehousePrice ?? 0
        case .chinaAir: return 0
        case .turkeyTruckByFerry: return turkeyTruckByFerryTariff?.first?.customsWarehousePrice ?? 0
        }
    }
    
    static func getGroupageDocs(for logisticsType: FLCLogisticsType, item: CalculationResultItem) -> Double {
        switch logisticsType {
        case .chinaTruck: chinaTruckTariff?.first?.groupageDocs ?? 0
        case .chinaRailway: chinaRailwayTariff?.first?.groupageDocs ?? 0
        case .chinaAir: getAviaGroupageDocs(item: item).brutto
        case .turkeyTruckByFerry: turkeyTruckByFerryTariff?.first?.groupageDocs ?? 0
        }
    }
    
    private static func getAviaGroupageDocs(item: CalculationResultItem) -> (netto: Double, brutto: Double) {
        let targetCity = chinaAirPickup?.first?.cities.first(where: { $0.targetCities.contains(where: { $0.contains(item.calculationData.departureAirport) }) })
        let netto = (chinaAirTariff?.first?.cities.first(where: { $0.name.lowercased() == targetCity?.targetAirport.lowercased() })?.groupageDocs ?? 0)
        let brutto = netto.add(markup: .fourteenPercents)
        return (netto, brutto)
    }
    
    static func getDeliveryToWarehouse(item: CalculationResultItem, logisticsType: FLCLogisticsType) -> (warehouseName: String, transitDays: String, result: Double) {
        switch logisticsType {
        case .chinaTruck:
            return calculateChinaGroundDeliveryToWarehouse(pickup: chinaTruckPickup ?? [], city: item.calculationData.fromLocation, weight: item.calculationData.weight, volume: item.calculationData.volume)
        case .chinaRailway:
            return calculateChinaGroundDeliveryToWarehouse(pickup: chinaRailwayPickup ?? [], city: item.calculationData.fromLocation, weight: item.calculationData.weight, volume: item.calculationData.volume)
        case .chinaAir:
            return calculateChinaAirDeliveryToWarehouse(city: item.calculationData.departureAirport, weight: item.calculationData.weight, volume: item.calculationData.volume)
        case .turkeyTruckByFerry:
            return calculateTurkeyDeliveryToWarehouse(city: item.calculationData.fromLocation, weight: item.calculationData.weight, volume: item.calculationData.volume, logisticsType: logisticsType)
        }
    }
    
    static func getPrice(totalPrice: String? = "0+0", data: CalculationData?, type: FLCTotalType) -> (result: String, currency: FLCCurrency, secondCurrency: FLCCurrency, exchangeRate: Double, currencyValue: Double, rubleValue: Double) {
        let cdCalculation = CoreDataManager.getCalculation(withID: data?.id ?? 0)
        let totalPriceParts = totalPrice?.filter { $0 != "*" }.components(separatedBy: "+")
        let currency = totalPriceParts?.first?.extractCurrencySymbol() ?? .USD
        let secondCurrency = totalPriceParts?.last?.extractCurrencySymbol() ?? .RUB
        let currencyKey = currencyData?.Valute.keys.first(where: { $0 == currency.rawValue }) ?? ""
        let currencyExchangeRate = data?.isFromCoreData ?? false ? cdCalculation?.exchangeRate ?? 0 : currencyData?.Valute[currencyKey]?.Value ?? 0
        
        let currencyValue = totalPriceParts?.first?.createDouble(removeSymbols: true) ?? 0
        let secondValue = totalPriceParts?.last?.createDouble(removeSymbols: true) ?? 0
        
        let currencyTotal = currencyValue + (secondValue / currencyExchangeRate)
        
        switch type {
        case .perKG:
            let currencyPricePerKg = (currencyTotal / (data?.weight ?? 1)).formatDecimalsTo(amount: 2)
            let rublePricePerKg = ((currencyTotal * currencyExchangeRate) / (data?.weight ?? 1)).formatAsCurrency(symbol: secondCurrency)
            
            let result = "~" + currencyPricePerKg.formatAsCurrency(symbol: currency) + " (\(rublePricePerKg))" + " за 1 кг"
            
            return (result, currency, secondCurrency, currencyExchangeRate, currencyValue, secondValue)
        case .asOneCurrency:
            let secondCurrencyTotal = currencyTotal * currencyExchangeRate
            let result = "~" + currencyTotal.formatAsCurrency(symbol: currency) + " (\(secondCurrencyTotal.formatAsCurrency(symbol: secondCurrency)))"
            return (result, currency, secondCurrency, currencyExchangeRate, currencyValue, secondValue)
        }
    }
    
    private static func calculateTurkeyDeliveryToWarehouse(city: String, weight: Double, volume: Double, logisticsType: FLCLogisticsType) -> (warehouseName: String, transitDays: String, result: Double) {
        guard let pickedCityZipCode = city.getDataInsideCharacters() else { return ("", "", 0.0) }
        
        let vat = turkeyTruckByFerryPickup?.first?.vat ?? 1.2
        var result = 0.0
        var transitDays = "1"
        let crossRatio = getRatioBetween(.EUR, and: .USD)
        
        if city.contains(FLCCities.istanbul.rawValue) {
            let istanbul = turkeyTruckByFerryPickup?.first?.cities.first(where: { $0.name == FLCCities.istanbul.rawValue })
            let targetCity = istanbul?.zones.first(where: { $0.zipCode == pickedCityZipCode })
            transitDays = istanbul?.transitDays ?? "1"
            
            let weightRange = targetCity?.weight.first(where: { $0.key.createRange()?.contains(weight) == true })
            let volumeRange = targetCity?.volume.first(where: { $0.key.createRange()?.contains(volume) == true })
            let weightPrice = weightRange?.value.totalPriceInEuro ?? 0
            let volumePrice = volumeRange?.value.totalPriceInEuro ?? 0
            
            let targetPrice = weightPrice > volumePrice ? weightPrice : volumePrice
            result = (targetPrice * vat * crossRatio).add(markup: .seventeenPercents)
        } else {
            guard var targetCity = turkeyTruckByFerryPickup?.first?.cities.first(where: { $0.zipCode == pickedCityZipCode }) else { return ("", "", 0) }
            
            if !targetCity.targetCities.isEmpty {
                if let cityName = targetCity.targetCities.first, let newTargetCity = turkeyTruckByFerryPickup?.first?.cities.first(where: { $0.name == cityName }) {
                    targetCity = newTargetCity
                } else {
                    return ("", "", 0)
                }
            }
            transitDays = targetCity.transitDays
            
            let volumeRange = targetCity.volume.first(where: { $0.key.createRange()?.contains(volume) == true })
            let pricePerCbm = volumeRange?.value.pricePerCbmInEuro ?? 0
            let minimumPrice = (((volumeRange?.value.minTotalPriceInEuro ?? 0) * vat) * crossRatio).add(markup: .seventeenPercents)
            
            let price = ((pricePerCbm * volume) * vat * crossRatio).add(markup: .seventeenPercents)
            result = price < minimumPrice ? minimumPrice : price
        }
        return (FLCWarehouse.istanbul.rusName, transitDays, result)
    }
    
   private static func calculateChinaGroundDeliveryToWarehouse<T: PickupDataConvertible>(pickup: [T], city: String, weight: Double, volume: Double) -> (warehouseName: String, transitDays: String, result: Double) {
        guard let cityName = city.getDataOutsideCharacters() else { return ("", "", 0.0) }
        guard let pickupData = pickup.first else { return ("", "", 0) }
        
        let yuanRate = pickupData.yuanRate
        let density = pickupData.density
        let chargeableWeight = max(weight, volume * density)
        
        let warehouse = pickupData.warehouses.first(where: { $0.cityList.contains(where: { $0.name.lowercased() == cityName.lowercased() }) })
        let warehouseName = FLCWarehouse(rawValue: warehouse?.name ?? "")
        let transitDays = warehouse?.cityList.first(where: { $0.name.lowercased() == cityName.lowercased() })?.transitDays ?? "1"
        let weightData = warehouse?.cityList.first(where: { $0.name.lowercased() == cityName.lowercased() })?.weightList
        let weightRange = weightData?.first(where: { $0.key.createRange()?.contains(weight) == true })
        
        let totalPart3CoefficientOne = warehouse?.totalPart3CoefficientOne ?? 0
        let totalPart3CoefficientTwo = warehouse?.totalPart3CoefficientTwo ?? 0
        let totalPart3CoefficientThree = warehouse?.totalPart3CoefficientThree ?? 0
        
        let totalPart1 = weightRange?.value.totalPart1Coefficient ?? 0
        let totalPart2 = chargeableWeight * (weightRange?.value.totalPart2Coefficient ?? 0)
        var totalPart3: Double =  0
        
        switch warehouseName {
        case .guangzhou:
            totalPart3 = totalPart3CoefficientOne + (totalPart3CoefficientTwo * max(weight/1000, volume) + totalPart3CoefficientThree)
        case .shanghai:
            totalPart3 = max(volume * totalPart3CoefficientOne, (weight * totalPart3CoefficientOne)/1000) + max(volume * totalPart3CoefficientOne * 0.06, totalPart3CoefficientTwo) + max(volume, totalPart3CoefficientTwo) + totalPart3CoefficientThree
        case .istanbul, nil: break
        }
        let result = ((totalPart1 + totalPart2 + totalPart3) / yuanRate).rounded().add(markup: .seventeenPercents)
        return (warehouseName?.rusName ?? "", transitDays, result)
    }
    
    private static func calculateChinaAirDeliveryToWarehouse(city: String, weight: Double, volume: Double) -> (warehouseName: String, transitDays: String, result: Double) {
        let targetWeight = chinaAirPickup?.first?.targetWeight ?? 0
        let chargeableWeight = max(weight, targetWeight * volume)
        let targetCity = getClosestAirportForAirDelivery(to: city)
        
        let warehouse = targetCity?.targetAirport ?? ""
        let transitDays = targetCity?.transitDays ?? ""
        let price = targetCity?.prices.first(where: { $0.key.createRange()?.contains(chargeableWeight) == true })?.value.price.add(markup: .tenPercents) ?? 0
        return (warehouse, transitDays, price)
    }
    
    static func getClosestAirportForAirDelivery(to city: String) -> ChinaAirCity? {
        chinaAirPickup?.first?.cities.first(where: { $0.targetCities.contains(where: { $0.contains(city) }) })
    }
    static func getClosestPickupCityForTurkeyTruckByFerry(to city: String) -> TurkeyTruckByFerryCity? {
        let pickedCity = turkeyTruckByFerryPickup?.first?.cities.first(where: { $0.name == city })
        let targetCityName = pickedCity?.targetCities.first ?? ""
        return turkeyTruckByFerryPickup?.first?.cities.first(where: { $0.name == targetCityName })
    }
    static func getMaxWeightFor(type: FLCLogisticsType) -> Double {
        switch type {
        case .chinaTruck, .chinaRailway, .turkeyTruckByFerry: return 20000
        case .chinaAir: return chinaAirTariff?.first?.maxWeightKg ?? 3000
        }
    }
    static func getCurrencyData() -> CurrencyData? { currencyData }
    static func getChinaAirTariff() -> [ChinaAirTariff]? { chinaAirTariff }
}
