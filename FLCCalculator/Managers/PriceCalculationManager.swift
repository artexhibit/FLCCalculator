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
        return densityCoefficient > logisticsTypeData.targetWeight ? weight * value : volume * value
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
    
    static func getDeliveryToWarehouse(forCountry: FLCCountryOption, city: String, weight: Double, volume: Double) -> Double {
        switch forCountry {
        case .china:
            guard let cityName = city.getCityName() else { return 0 }
            
            let pickupsCountry = pickups?.first(where: { $0.country == forCountry.engName })
            let yuanRate = pickupsCountry?.yuanRate ?? 6.9
            let density = pickupsCountry?.density ?? 0
            let chargeableWeight = max(weight, volume * density)
            
            let warehouse = pickupsCountry?.warehouse.first(where: { $0.cities.contains(where: { $0.name.lowercased() == cityName.lowercased() }) })
            let weightData = warehouse?.cities.first(where: { $0.name.lowercased() == cityName.lowercased() })?.weight
            let weightRange = weightData?.first(where: { $0.key.createRange()?.contains(weight) == true })
            
            let totalPart3CoefficientOne = warehouse?.totalPart3CoefficientOne ?? 0
            let totalPart3CoefficientTwo = warehouse?.totalPart3CoefficientTwo ?? 0
            let totalPart3CoefficientThree = warehouse?.totalPart3CoefficientThree ?? 0
            
            let totalPart1 = weightRange?.value.totalPart1Coefficient ?? 0
            let totalPart2 = chargeableWeight * (weightRange?.value.totalPart2Coefficient ?? 0)
            let totalPart3 = totalPart3CoefficientOne + (totalPart3CoefficientTwo * max(weight/1000, volume) + totalPart3CoefficientThree)
            
            return ((totalPart1 + totalPart2 + totalPart3) / yuanRate).rounded().add(markup: .deliveryToWarehouse)
        case .turkey:
            break
        }
        return 0
    }
    
    static func getDeliveryToWarehouseData(forCountry: FLCCountryOption, city: String) -> (warehouseName: String, transitDays: Int) {
        guard let cityName = city.getCityName() else { return ("", 0) }
        
        let pickupsCountry = pickups?.first(where: { $0.country == forCountry.engName })
        let warehouse = pickupsCountry?.warehouse.first(where: { $0.cities.contains(where: { $0.name.lowercased() == cityName.lowercased() }) })
        
        let warehouseName = FLCWarehouse(rawValue: warehouse?.name ?? "")?.rusName ?? ""
        let transitDays = warehouse?.cities.first(where: { $0.name.lowercased() == cityName.lowercased() })?.transitDays ?? 0

        return (warehouseName, transitDays)
    }
}
