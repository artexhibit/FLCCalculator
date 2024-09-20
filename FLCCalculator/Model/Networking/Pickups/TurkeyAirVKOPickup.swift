import Foundation

struct TurkeyAirVKOPickup: Codable, Hashable {
    let targetWeight: Double
    let cities: [TurkeyAirVKOCity]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(targetWeight)
        hasher.combine(cities)
    }
}

struct TurkeyAirVKOCity: Codable, Hashable {
    let name: String
    let targetAirport: String
    let targetCities: [String]
    let transitDays: String
    let prices: [String: TurkeyAirVKOCityPrice]
}

struct TurkeyAirVKOCityPrice: Codable, Hashable {
    let price: Double
}

extension TurkeyAirVKOPickup: CoreDataStorable { static var coreDataKey: String { Keys.cdTurkeyAirVKOPickup } }
extension TurkeyAirVKOPickup: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.turkeyAirVKOPickup }
    static var collectionNameKey: String { Keys.pickups }
}
extension TurkeyAirVKOCity: AirPickupCity {
    var airName: String { name }
    var airTargetAirport: String { targetAirport }
    var airTargetCities: [String] { targetCities }
    var airTargetCitiesV2: [String] { [] }
    var airTransitDays: String { transitDays }
    var airPrices: [String : AirPickupCityPrice] { prices }
}
extension TurkeyAirVKOCityPrice: AirPickupCityPrice {
    var airPrice: Double { price }
}
extension TurkeyAirVKOPickup: AirPickupIdentifiable {
    var airTargetWeight: Double { targetWeight }
    var airCities: [AirPickupCity] { cities } }
