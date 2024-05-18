import Foundation

struct TurkeyTruckByFerryTariff: Codable, Hashable {
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
    let tariffs: TurkeyTruckByFerryTariffs
    
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

struct TurkeyTruckByFerryTariffs: Codable, Hashable {
    let volume: [String: Double]
    let weight: [String: Double]
}

extension TurkeyTruckByFerryTariff: UserDefaultsStorable { static var userDefaultsKey: String { Keys.turkeyTruckByFerryTariff } }
extension TurkeyTruckByFerryTariff: FirebaseIdentifiable {
    static var collectionNameKey: String { Keys.tariffs }
    static var fieldNameKey: String { Keys.turkeyTruckByFerryTariff }
}
