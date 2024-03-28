import Foundation

class PriceCalculationManager {
    
    private static let tariffs = PersistenceManager.retrieveTariffs()
    private static let currencyData = PersistenceManager.retrieveCurrencyData()
    
    static func getInsurancePersentage(for logisticsType: FLCLogisticsType) -> Double {
        guard let tariff = tariffs?.first(where: { $0.name == logisticsType.rawValue }) else { return 0 }
        return tariff.insurancePersentage
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
    
    static func calculateDeliveryFromWarehouse(for logisticsType: FLCLogisticsType, weight: Double, volume: Double) -> Double {
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
}
