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
        let deliveryData = PriceCalculationManager.getDeliveryToWarehouseData(forCountry: .china, city: item.calculationData.fromLocation)
        let isGuangzhou = deliveryData.warehouseName.flcWarehouseFromRusName == .guangzhou
        let days = isGuangzhou ? "\(deliveryData.transitDays + 4) дн." : "\(deliveryData.transitDays) дн."
        
        let price = PriceCalculationManager.getDeliveryToWarehouse(forCountry: .china, city: item.calculationData.fromLocation, weight: item.calculationData.weight, volume: item.calculationData.volume).formatAsCurrency(symbol: item.currency)
        return (price, days, isGuangzhou, deliveryData.warehouseName)
    }
}
