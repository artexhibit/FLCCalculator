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
    let targetCities: [String]?
    let targetCitiesV2: [String]?
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
extension ChinaAirCity: AirPickupCity {
    var airName: String { name }
    var airTargetAirport: String { targetAirport }
    var airTargetCities: [String] { targetCities ?? [""] }
    var airTargetCitiesV2: [String] { targetCitiesV2 ?? [""] }
    var airTransitDays: String { transitDays }
    var airPrices: [String : AirPickupCityPrice] { prices }
}
extension ChinaAirCityPrice: AirPickupCityPrice {
    var airPrice: Double { price }
}
extension ChinaAirPickup: AirPickupIdentifiable {
    var airTargetWeight: Double { targetWeight }
    var airCities: [AirPickupCity] { cities } }
