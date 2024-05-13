import Foundation

struct Tariff: Codable, Hashable {
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
    let tariffs: Tariffs
    
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

struct Tariffs: Codable, Hashable {
    let volume: [String: Double]
    let weight: [String: Double]
}

extension Tariff: UserDefaultsStorable { static var userDefaultsKey: String { Keys.tariffs } }
extension Tariff: FirebaseIdentifiable { static var collectionNameKey: String { Keys.tariffs } }
