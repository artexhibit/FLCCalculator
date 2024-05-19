import Foundation

struct ChinaAirPickup: Codable, Hashable {
    let density: Double
    let yuanRate: Double
    let warehouse: [ChinaAirPickupWarehouse]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(density)
        hasher.combine(yuanRate)
        hasher.combine(warehouse)
    }
}

struct ChinaAirPickupWarehouse: Codable, Hashable {
    let name: String
    let totalPart3CoefficientOne: Double
    let totalPart3CoefficientTwo: Double
    let totalPart3CoefficientThree: Double
    let cities: [ChinaAirPickupCity]
}

struct ChinaAirPickupCity: Codable, Hashable {
    let name: String
    let province: String
    let transitDays: String
    let weight: [String: ChinaAirPickupWeight]
}

struct ChinaAirPickupWeight: Codable, Hashable {
    let totalPart1Coefficient: Double
    let totalPart2Coefficient: Double
}

extension ChinaAirPickup: CoreDataStorable { static var coreDataKey: String { Keys.cdChinaAirPickup } }
extension ChinaAirPickup: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.chinaAirPickup }
    static var collectionNameKey: String { Keys.pickups }
}

extension ChinaAirPickup: PickupDataConvertible {
    var warehouses: [WarehouseConvertible] { self.warehouse.map { $0 as WarehouseConvertible } }
}

extension ChinaAirPickupWarehouse: WarehouseConvertible {
    var cityList: [CityConvertible] { return self.cities.map { $0 as CityConvertible } }
}

extension ChinaAirPickupCity: CityConvertible {
    var weightList: [String: WeightConvertible] { self.weight.mapValues { $0 as WeightConvertible } }
}
extension ChinaAirPickupWeight: WeightConvertible {}
