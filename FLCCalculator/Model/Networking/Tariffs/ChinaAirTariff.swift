import Foundation

struct ChinaAirTariff: Codable, Hashable {
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
    let tariffs: ChinaAirTariffs
    
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

struct ChinaAirTariffs: Codable, Hashable {
    let volume: [String: Double]
    let weight: [String: Double]
}

extension ChinaAirTariff: UserDefaultsStorable { static var userDefaultsKey: String { Keys.chinaAirTariff } }
extension ChinaAirTariff: FirebaseIdentifiable {
    static var collectionNameKey: String { Keys.tariffs }
    static var fieldNameKey: String { Keys.chinaAirTariff }
}