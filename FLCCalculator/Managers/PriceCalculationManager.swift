import Foundation

class PriceCalculationManager {
    
    private static let tariffs: [Tariff]? = PersistenceManager.retrieveItemsFromUserDefaults()
    private static let pickups: [Pickup]? = PersistenceManager.retrieveItemsFromUserDefaults()
    private static let currencyData = PersistenceManager.retrieveCurrencyData()
    
    static func getInsurancePersentage(for logisticsType: FLCLogisticsType) -> Double {
        guard let tariff = tariffs?.first(where: { $0.name == logisticsType.rawValue }) else { return 0 }
        return tariff.insurancePercentage
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
        let insurancePercentage = getInsurancePersentage(for: logisticsType)
        let invoiceAmountInSellCurrency = invoiceAmount / ratio
        
        return (invoiceAmountInSellCurrency * insurancePercentage) / 100
    }
    
    static func getDeliveryFromWarehouse(for logisticsType: FLCLogisticsType, weight: Double, volume: Double) -> Double {
        guard let logisticsTypeData = tariffs?.first(where: { $0.name == logisticsType.rawValue }) else { return 0 }
        let densityCoefficient = weight / volume
        
        let tariffs = densityCoefficient > logisticsTypeData.targetWeight ? logisticsTypeData.tariffs.weight : logisticsTypeData.tariffs.volume
        let targetParameter = densityCoefficient > logisticsTypeData.targetWeight ? weight : volume
        
        let range = tariffs.first(where: { $0.key.createRange()?.contains(targetParameter) == true })

        let value = range?.value ?? 0
        let price = densityCoefficient > logisticsTypeData.targetWeight ? weight * value : volume * value
        return price > logisticsTypeData.minLogisticsPrice ? price : logisticsTypeData.minLogisticsPrice
    }
    
    static func getDeliveryFromWarehouseTransitTime(for logisticsType: FLCLogisticsType) -> String {
        guard let logisticsTypeData = tariffs?.first(where: { $0.name == logisticsType.rawValue }) else { return "" }
        return String(logisticsTypeData.transitDays)
    }
    
    static func getCagoHandlingData(for logisticsType: FLCLogisticsType) -> (pricePerKg: Double, minPrice: Double) {
        guard let logisticsTypeData = tariffs?.first(where: { $0.name == logisticsType.rawValue }) else { return (0,0) }
        return (logisticsTypeData.cargoHandling, logisticsTypeData.minCargoHandling)
    }
    
    static func calculateCargoHandling(for logisticsType: FLCLogisticsType, weight: Double) -> Double {
        let handlingData = getCagoHandlingData(for: logisticsType)
        
        return handlingData.pricePerKg * weight > handlingData.minPrice ? handlingData.pricePerKg * weight : handlingData.minPrice
    }
    
    static func getCustomsClearancePrice(for logisticsType: FLCLogisticsType) -> Double {
        guard let logisticsTypeData = tariffs?.first(where: { $0.name == logisticsType.rawValue }) else { return 0 }
        return logisticsTypeData.customsClearance
    }
    
    static func getCustomsWarehouseServices(for logisticsType: FLCLogisticsType) -> Double {
        guard let logisticsTypeData = tariffs?.first(where: { $0.name == logisticsType.rawValue }) else { return 0 }
        return logisticsTypeData.customsWarehousePrice
    }
    
    static func getGroupageDocs(for logisticsType: FLCLogisticsType) -> Double {
        guard let logisticsTypeData = tariffs?.first(where: { $0.name == logisticsType.rawValue }) else { return 0 }
        return logisticsTypeData.groupageDocs
    }
    
    static func getDeliveryToWarehouse(forCountry: FLCCountryOption, city: String, weight: Double, volume: Double) -> (warehouseName: String, transitDays: Int, result: Double) {
        switch forCountry {
        case .china:
            guard let cityName = city.getCityName() else { return ("", 0, 0.0) }
            
            let pickupsCountry = pickups?.first(where: { $0.country == forCountry.engName })
            let yuanRate = pickupsCountry?.yuanRate ?? 6.9
            let density = pickupsCountry?.density ?? 0
            let chargeableWeight = max(weight, volume * density)
            
            let warehouse = pickupsCountry?.warehouse.first(where: { $0.cities.contains(where: { $0.name.lowercased() == cityName.lowercased() }) })
            let warehouseName = FLCWarehouse(rawValue: warehouse?.name ?? "")
            let transitDays = warehouse?.cities.first(where: { $0.name.lowercased() == cityName.lowercased() })?.transitDays ?? 0
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
        case .turkey:
            break
        }
        return ("", 0, 0.0)
    }
    
    static func getPrice(totalPrice: String? = "0+0", weight: Double? = 1, type: FLCTotalType) -> (result: String, currency: FLCCurrency, secondCurrency: FLCCurrency, exchangeRate: Double, currencyValue: Double, rubleValue: Double) {
        let totalPriceParts = totalPrice?.components(separatedBy: "+")
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
            
            let result = "~" + currencyPricePerKg.formatAsCurrency(symbol: currency) + " / " + rublePricePerKg + " за кг"
            
            return (result, currency, secondCurrency, currencyExchangeRate, currencyValue, secondValue)
        case .asOneCurrency:
            let secondCurrencyTotal = currencyTotal * currencyExchangeRate
            let result = "~" + currencyTotal.formatAsCurrency(symbol: currency) + " или ~" + secondCurrencyTotal.formatAsCurrency(symbol: secondCurrency)
            return (result, currency, secondCurrency, currencyExchangeRate, currencyValue, secondValue)
        }
    }
}
