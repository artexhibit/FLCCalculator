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
extension TurkeyAirSVOCity: AirPickupCity {
    var airName: String { name }
    var airTargetAirport: String { targetAirport }
    var airTargetCities: [String] { targetCities }
    var airTargetCitiesV2: [String] { [] }
    var airTransitDays: String { transitDays }
    var airPrices: [String : AirPickupCityPrice] { prices }
}
extension TurkeyAirSVOCityPrice: AirPickupCityPrice {
    var airPrice: Double { price }
}
extension TurkeyAirSVOPickup: AirPickupIdentifiable {
    var airTargetWeight: Double { targetWeight }
    var airCities: [AirPickupCity] { cities } }
