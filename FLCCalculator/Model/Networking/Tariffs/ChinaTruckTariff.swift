import Foundation

struct ChinaTruckTariff: Codable, Hashable {
    let name: String
    let insurancePercentage: Double
    let cargoHandling: Double
    let minCargoHandling: Double
    let groupageDocs: Double
    let minLogisticsPrice: Double
    let customsClearance: Double
    let customsWarehousePrice: Double
    let targetWeight: Double
    let transitDays: Int
    let tariffs: ChinaTruckTariffs
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(insurancePercentage)
        hasher.combine(cargoHandling)
        hasher.combine(minCargoHandling)
        hasher.combine(groupageDocs)
        hasher.combine(minLogisticsPrice)
        hasher.combine(customsClearance)
        hasher.combine(customsWarehousePrice)
        hasher.combine(targetWeight)
        hasher.combine(transitDays)
        hasher.combine(tariffs)
    }
}

struct ChinaTruckTariffs: Codable, Hashable {
    let volume: [String: Double]
    let weight: [String: Double]
}

extension ChinaTruckTariff: CoreDataStorable { static var coreDataKey: String { Keys.cdChinaTruckTariff } }
extension ChinaTruckTariff: FirebaseIdentifiable {
    static var collectionNameKey: String { Keys.tariffs }
    static var fieldNameKey: String { Keys.chinaTruckTariff }
}
extension ChinaTruckTariffs: AnyTariffsConvertible {}
extension ChinaTruckTariff: AnyTariffDataConvertible { var tariffsList: AnyTariffsConvertible { self.tariffs } }
