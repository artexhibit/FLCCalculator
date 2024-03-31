import Foundation

struct Pickup: Codable, Hashable {
    let country: String
    let density: Double
    let yuanRate: Double
    let warehouse: [Warehouse]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(country)
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

extension Pickup: UserDefaultsStorable {
    static var userDefaultsKey: String { Keys.pickups }
}

extension Pickup: FirebaseIdentifiable {
    static var collectionNameKey: String { Keys.pickups }
}
