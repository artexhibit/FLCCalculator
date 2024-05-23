import Foundation

struct ChinaAirPickup: Codable, Hashable {
    let targetWeight: Double
    let cities: [ChinaAirCity]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(targetWeight)
        hasher.combine(cities)
    }
}

struct ChinaAirCity: Codable, Hashable {
    let name: String
    let targetAirport: String
    let targetCities: [String]
    let transitDays: String
    let prices: [String: ChinaAirCityPrice]
}

struct ChinaAirCityPrice: Codable, Hashable {
    let price: Double
}

extension ChinaAirPickup: CoreDataStorable { static var coreDataKey: String { Keys.cdChinaAirPickup } }
extension ChinaAirPickup: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.chinaAirPickup }
    static var collectionNameKey: String { Keys.pickups }
}
