import Foundation

struct ChinaRailwayPickup: Codable, Hashable {
    let density: Double
    let yuanRate: Double
    let warehouse: [ChinaRailwayPickupWarehouse]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(density)
        hasher.combine(yuanRate)
        hasher.combine(warehouse)
    }
}

struct ChinaRailwayPickupWarehouse: Codable, Hashable {
    let name: String
    let totalPart3CoefficientOne: Double
    let totalPart3CoefficientTwo: Double
    let totalPart3CoefficientThree: Double
    let cities: [ChinaRailwayPickupCity]
}

struct ChinaRailwayPickupCity: Codable, Hashable {
    let name: String
    let province: String
    let transitDays: String
    let weight: [String: ChinaRailwayPickupWeight]
}

struct ChinaRailwayPickupWeight: Codable, Hashable {
    let totalPart1Coefficient: Double
    let totalPart2Coefficient: Double
}

extension ChinaRailwayPickup: CoreDataStorable { static var coreDataKey: String { Keys.cdChinaRailwayPickup } }
extension ChinaRailwayPickup: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.chinaRailwayPickup }
    static var collectionNameKey: String { Keys.pickups }
}

extension ChinaRailwayPickup: PickupDataConvertible {
    var warehouses: [WarehouseConvertible] { self.warehouse.map { $0 as WarehouseConvertible } }
}

extension ChinaRailwayPickupWarehouse: WarehouseConvertible {
    var cityList: [CityConvertible] { self.cities.map { $0 as CityConvertible } }
}

extension ChinaRailwayPickupCity: CityConvertible {
    var weightList: [String: WeightConvertible] { self.weight.mapValues { $0 as WeightConvertible } }
}
extension ChinaRailwayPickupWeight: WeightConvertible {}
