import Foundation

struct TurkeyAirSVOPickup: Codable, Hashable {
    let targetWeight: Double
    let cities: [TurkeyAirSVOCity]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(targetWeight)
        hasher.combine(cities)
    }
}

struct TurkeyAirSVOCity: Codable, Hashable {
    let name: String
    let targetAirport: String
    let targetCities: [String]
    let transitDays: String
    let prices: [String: TurkeyAirSVOCityPrice]
}

struct TurkeyAirSVOCityPrice: Codable, Hashable {
    let price: Double
}

extension TurkeyAirSVOPickup: CoreDataStorable { static var coreDataKey: String { Keys.cdTurkeyAirSVOPickup } }
extension TurkeyAirSVOPickup: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.turkeyAirSVOPickup }
    static var collectionNameKey: String { Keys.pickups }
}
