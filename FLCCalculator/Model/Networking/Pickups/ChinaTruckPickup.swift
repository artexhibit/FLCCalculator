import Foundation

struct ChinaTruckPickup: Codable, Hashable {
    let density: Double
    let yuanRate: Double
    let warehouse: [ChinaTruckPickupWarehouse]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(density)
        hasher.combine(yuanRate)
        hasher.combine(warehouse)
    }
}

struct ChinaTruckPickupWarehouse: Codable, Hashable {
    let name: String
    let totalPart3CoefficientOne: Double
    let totalPart3CoefficientTwo: Double
    let totalPart3CoefficientThree: Double
    let cities: [ChinaTruckPickupCity]
}

struct ChinaTruckPickupCity: Codable, Hashable {
    let name: String
    let province: String
    let transitDays: String
    let weight: [String: ChinaTruckPickupWeight]
}

struct ChinaTruckPickupWeight: Codable, Hashable {
    let totalPart1Coefficient: Double
    let totalPart2Coefficient: Double
}

extension ChinaTruckPickup: CoreDataStorable { static var coreDataKey: String { Keys.cdChinaTruckPickup } }

extension ChinaTruckPickup: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.chinaTruckPickup }
    static var collectionNameKey: String { Keys.pickups }
}

extension ChinaTruckPickup: PickupDataConvertible {
    var warehouses: [WarehouseConvertible] { self.warehouse.map { $0 as WarehouseConvertible } }
}

extension ChinaTruckPickupWarehouse: WarehouseConvertible {
    var cityList: [CityConvertible] { self.cities.map { $0 as CityConvertible } }
}

extension ChinaTruckPickupCity: CityConvertible {
    var weightList: [String: WeightConvertible] { self.weight.mapValues { $0 as WeightConvertible } }
}
extension ChinaTruckPickupWeight: WeightConvertible {}
