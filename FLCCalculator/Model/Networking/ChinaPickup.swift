import Foundation

struct ChinaPickup: Codable, Hashable {
    let density: Double
    let yuanRate: Double
    let warehouse: [Warehouse]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(density)
        hasher.combine(yuanRate)
        hasher.combine(warehouse)
    }
}

struct Warehouse: Codable, Hashable {
    let name: String
    let totalPart3CoefficientOne: Double
    let totalPart3CoefficientTwo: Double
    let totalPart3CoefficientThree: Double
    let cities: [City]
}

struct City: Codable, Hashable {
    let name: String
    let province: String
    let transitDays: Int
    let weight: [String: Weight]
}

struct Weight: Codable, Hashable {
    let totalPart1Coefficient: Double
    let totalPart2Coefficient: Double
}

extension ChinaPickup: UserDefaultsStorable {
    static var userDefaultsKey: String { Keys.chinaPickup }
}

extension ChinaPickup: FirebaseIdentifiable {
    static var collectionNameKey: String { Keys.chinaPickup }
}
