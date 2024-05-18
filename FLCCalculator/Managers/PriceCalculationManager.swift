import Foundation

class PriceCalculationManager {
    private static let chinaTruckTariff: [ChinaTruckTariff]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let chinaRailwayTariff: [ChinaRailwayTariff]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let chinaAirTariff: [ChinaAirTariff]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let turkeyTruckByFerryTariff: [TurkeyTruckByFerryTariff]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let chinaPickup: [ChinaPickup]? = CoreDataManager.retrieveItemsFromCoreData()
    private static let turkeyPickup: [TurkeyPickup]? = CoreDataManager.retrieveItemsFromCoreData()
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
    
    static func getDeliveryFromWarehouse(for logisticsType: FLCLogisticsType, weight: Double, volume: Double) -> Double {
        switch logisticsType {
        case .chinaTruck:
            return getDeliveryFromWarehousePrice(tariff: chinaTruckTariff ?? [], weight: weight, volume: volume) { AnyTariffData(targetWeight: $0.targetWeight, minLogisticsPrice: $0.minLogisticsPrice, tariffs: AnyTariffs(volume: $0.tariffs.volume, weight: $0.tariffs.weight)) }
        case .chinaRailway:
            return getDeliveryFromWarehousePrice(tariff: chinaRailwayTariff ?? [], weight: weight, volume: volume) { AnyTariffData(targetWeight: $0.targetWeight, minLogisticsPrice: $0.minLogisticsPrice, tariffs: AnyTariffs(volume: $0.tariffs.volume, weight: $0.tariffs.weight)) }
        case .chinaAir:
            return getDeliveryFromWarehousePrice(tariff: chinaAirTariff ?? [], weight: weight, volume: volume) { AnyTariffData(targetWeight: $0.targetWeight, minLogisticsPrice: $0.minLogisticsPrice, tariffs: AnyTariffs(volume: $0.tariffs.volume, weight: $0.tariffs.weight)) }
        case .turkeyTruckByFerry:
            return getDeliveryFromWarehousePrice(tariff: turkeyTruckByFerryTariff ?? [], weight: weight, volume: volume) { AnyTariffData(targetWeight: $0.targetWeight, minLogisticsPrice: $0.minLogisticsPrice, tariffs: AnyTariffs(volume: $0.tariffs.volume, weight: $0.tariffs.weight)) }
        }
    }
    
    static func getDeliveryFromWarehousePrice<T>(tariff: [T], weight: Double, volume: Double, extractor: (T) -> AnyTariffData) -> Double {
        guard let logisticsTypeData = tariff.first else { return 0 }
        let densityCoefficient = weight / volume
        let extractedData = extractor(logisticsTypeData)
        
        let targetTariffs = densityCoefficient > extractedData.targetWeight ? extractedData.tariffs.weight : extractedData.tariffs.volume
        let targetParameter = densityCoefficient > extractedData.targetWeight ? weight : volume
        
        let range = targetTariffs.first(where: { $0.key.createRange()?.contains(targetParameter) == true })
        let value = range?.value ?? 0
        let price = densityCoefficient > extractedData.targetWeight ? weight * value : volume * value
        return price > extractedData.minLogisticsPrice ? price : extractedData.minLogisticsPrice
    }
    
    static func getDeliveryFromWarehouseTransitTime(for logisticsType: FLCLogisticsType) -> String {
        switch logisticsType {
        case .chinaTruck: return String(chinaTruckTariff?.first?.transitDays ?? 0)
        case .chinaRailway: return String(chinaRailwayTariff?.first?.transitDays ?? 0)
        case .chinaAir: return String(chinaAirTariff?.first?.transitDays ?? 0)
        case .turkeyTruckByFerry: return String(turkeyTruckByFerryTariff?.first?.transitDays ?? 0)
        }
    }
    
    static func getCagoHandlingData(for logisticsType: FLCLogisticsType, item: CalculationResultItem? = nil) -> (pricePerKg: Double, minPrice: Double) {
        let results = CoreDataManager.getCalculationResults(forCalculationID: item?.calculationData.id ?? 0)
        let targetResult = results?.first(where: { $0.logisticsType == logisticsType.rawValue })
        var result: (pricePerKg: Double, minPrice: Double)
        
        switch logisticsType {
        case .chinaTruck:
            result = (chinaTruckTariff?.first?.cargoHandling ?? 0, chinaTruckTariff?.first?.minCargoHandling ?? 0)
        case .chinaRailway:
            result = (chinaRailwayTariff?.first?.cargoHandling ?? 0, chinaRailwayTariff?.first?.minCargoHandling ?? 0)
        case .chinaAir:
            result = (chinaAirTariff?.first?.cargoHandling ?? 0, chinaAirTariff?.first?.minCargoHandling ?? 0)
        case .turkeyTruckByFerry:
            result = (turkeyTruckByFerryTariff?.first?.cargoHandling ?? 0, turkeyTruckByFerryTariff?.first?.minCargoHandling ?? 0)
        }
        return item?.calculationData.isFromCoreData ?? false ? (targetResult?.cargoHandlingPricePerKg ?? 0, targetResult?.cargoHandlingMinPrice ?? 0) : result
    }
    
    static func calculateCargoHandling(for logisticsType: FLCLogisticsType, weight: Double) -> Double {
        let handlingData = getCagoHandlingData(for: logisticsType)
        
        return handlingData.pricePerKg * weight > handlingData.minPrice ? handlingData.pricePerKg * weight : handlingData.minPrice
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
        case .chinaAir: return chinaAirTariff?.first?.customsWarehousePrice ?? 0
        case .turkeyTruckByFerry: return turkeyTruckByFerryTariff?.first?.customsWarehousePrice ?? 0
        }
    }
    
    static func getGroupageDocs(for logisticsType: FLCLogisticsType) -> Double {
        switch logisticsType {
        case .chinaTruck: return chinaTruckTariff?.first?.groupageDocs ?? 0
        case .chinaRailway: return chinaRailwayTariff?.first?.groupageDocs ?? 0
        case .chinaAir: return chinaAirTariff?.first?.groupageDocs ?? 0
        case .turkeyTruckByFerry: return turkeyTruckByFerryTariff?.first?.groupageDocs ?? 0
        }
    }
    
    static func getDeliveryToWarehouse(city: String, weight: Double, volume: Double, logisticsType: FLCLogisticsType) -> (warehouseName: String, transitDays: String, result: Double) {
        switch logisticsType {
        case .chinaTruck, .chinaRailway:
            return calculateChinaDeliveryToWarehouse(city: city, weight: weight, volume: volume, logisticsType: logisticsType)
        case .chinaAir:
            return calculateChinaDeliveryToWarehouse(city: city, weight: weight, volume: volume, logisticsType: logisticsType)
        case .turkeyTruckByFerry:
            return calculateTurkeyDeliveryToWarehouse(city: city, weight: weight, volume: volume, logisticsType: logisticsType)
        }
    }
    
    static func getPrice(totalPrice: String? = "0+0", weight: Double? = 1, type: FLCTotalType) -> (result: String, currency: FLCCurrency, secondCurrency: FLCCurrency, exchangeRate: Double, currencyValue: Double, rubleValue: Double) {
        let totalPriceParts = totalPrice?.filter { $0 != "*" }.components(separatedBy: "+")
        let currency = totalPriceParts?.first?.extractCurrencySymbol() ?? .USD
        let secondCurrency = totalPriceParts?.last?.extractCurrencySymbol() ?? .RUB
        let currencyKey = currencyData?.Valute.keys.first(where: { $0 == currency.rawValue }) ?? ""
        let currencyExchangeRate = currencyData?.Valute[currencyKey]?.Value ?? 0
        
        let currencyValue = totalPriceParts?.first?.createDouble(removeSymbols: true) ?? 0
        let secondValue = totalPriceParts?.last?.createDouble(removeSymbols: true) ?? 0
        
        let currencyTotal = currencyValue + (secondValue / currencyExchangeRate)
        
        switch type {
        case .perKG:
            let currencyPricePerKg = (currencyTotal / (weight ?? 1)).formatDecimalsTo(amount: 2)
            let rublePricePerKg = ((currencyTotal * currencyExchangeRate) / (weight ?? 1)).formatAsCurrency(symbol: secondCurrency)
            
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
        
        let vat = turkeyPickup?.first?.vat ?? 1.2
        var result = 0.0
        var transitDays = "1"
        let crossRatio = getRatioBetween(.EUR, and: .USD)
        
        if city.contains(Cities.istanbul) {
            let istanbul = turkeyPickup?.first?.cities.first(where: { $0.name == Cities.istanbul })
            let targetCity = istanbul?.zones.first(where: { $0.zipCode == pickedCityZipCode })
            transitDays = istanbul?.transitDays ?? "1"
            
            let weightRange = targetCity?.weight.first(where: { $0.key.createRange()?.contains(weight) == true })
            let volumeRange = targetCity?.volume.first(where: { $0.key.createRange()?.contains(volume) == true })
            let weightPrice = weightRange?.value.totalPriceInEuro ?? 0
            let volumePrice = volumeRange?.value.totalPriceInEuro ?? 0
            
            let targetPrice = weightPrice > volumePrice ? weightPrice : volumePrice
            result = (targetPrice * vat * crossRatio).add(markup: .seventeenPercents)
        } else {
            let targetCity = turkeyPickup?.first?.cities.first(where: { $0.zipCode == pickedCityZipCode })
            transitDays = targetCity?.transitDays ?? "1"
            
            let volumeRange = targetCity?.volume.first(where: { $0.key.createRange()?.contains(volume) == true })
            let pricePerCbm = volumeRange?.value.pricePerCbmInEuro ?? 0
            let minimumPrice = (((volumeRange?.value.minTotalPriceInEuro ?? 0) * vat) * crossRatio).add(markup: .seventeenPercents)
            
            let price = ((pricePerCbm * volume) * vat * crossRatio).add(markup: .seventeenPercents)
            result = price < minimumPrice ? minimumPrice : price
        }
        return (FLCWarehouse.istanbul.rusName, transitDays, result)
    }
    
    private static func calculateChinaDeliveryToWarehouse(city: String, weight: Double, volume: Double, logisticsType: FLCLogisticsType) -> (warehouseName: String, transitDays: String, result: Double) {
        guard let cityName = city.getDataOutsideCharacters() else { return ("", "", 0.0) }
        
        let yuanRate = chinaPickup?.first?.yuanRate ?? 6.9
        let density = chinaPickup?.first?.density ?? 0
        let chargeableWeight = max(weight, volume * density)
        
        let warehouse = chinaPickup?.first?.warehouse.first(where: { $0.cities.contains(where: { $0.name.lowercased() == cityName.lowercased() }) })
        let warehouseName = FLCWarehouse(rawValue: warehouse?.name ?? "")
        let transitDays = warehouse?.cities.first(where: { $0.name.lowercased() == cityName.lowercased() })?.transitDays ?? "1"
        let weightData = warehouse?.cities.first(where: { $0.name.lowercased() == cityName.lowercased() })?.weight
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
}

extension PriceCalculationManager {
    struct AnyTariffs {
        let volume: [String: Double]
        let weight: [String: Double]
    }
    
    struct AnyTariffData {
        var targetWeight: Double
        var minLogisticsPrice: Double
        var tariffs: AnyTariffs
    }
}
