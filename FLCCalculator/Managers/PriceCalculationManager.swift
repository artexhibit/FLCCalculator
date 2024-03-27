import Foundation

class PriceCalculationManager {
    
    private static var tariffs = [Tariff]()
    private static var currencyData: CurrencyData?
    
    private static func loadTariffs() {
        PersistenceManager.retrieveTariffs { result in
            
            switch result {
            case .success(let loadedTariffs):
                tariffs = loadedTariffs
            case .failure(_):
                tariffs = []
            }
        }
    }
    
    private static func loadCurrencyData() {
        PersistenceManager.retrieveCurrencyData { result in
            
            switch result {
            case .success(let loadedCurrencyData):
                currencyData = loadedCurrencyData
            case .failure(_):
                currencyData = nil
            }
        }
    }
    
    static func getInsurancePersentage(for logisticsType: FLCLogisticsType) -> Double {
        self.loadTariffs()
        guard let tariff = tariffs.first(where: { $0.name == logisticsType.rawValue }) else { return 0 }
        return tariff.insurancePersentage
    }
    
    static func getRatioBetween(_ cellPriceCurrency: FLCCurrency, and invoiceCurrency: FLCCurrency) -> Double {
        self.loadCurrencyData()
        
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
}
