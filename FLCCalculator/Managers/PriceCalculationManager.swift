import Foundation

class PriceCalculationManager {
    
    private static var tariffs = [Tariff]()
    
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
    
    static func getInsurancePersentage(for logisticsType: FLCLogisticsType) -> Double {
        self.loadTariffs()
        guard let tariff = tariffs.first(where: { $0.name == logisticsType.rawValue }) else { return 0 }
        return tariff.insurancePersentage
    }
    
   static func calculateInsurance(for logisticsType: FLCLogisticsType, invoiceAmount: Double) -> Double {
        let insurancePercentage = getInsurancePersentage(for: logisticsType)
        return (invoiceAmount * insurancePercentage) / 100
    }
}
