import Foundation

struct TurkeyTruckByFerryPickup: Codable, Hashable {
    let vat: Double
    let cities: [TurkeyTruckByFerryCity]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(vat)
        hasher.combine(cities)
    }
}

struct TurkeyTruckByFerryCity: Codable, Hashable {
    let name: String
    let zones: [TurkeyTruckByFerryCityZone]
    let targetCities: [String]
    let zipCode: String
    let transitDays: String
    let volume: [String: TurkeyTruckByFerryCityWeight]
}

struct TurkeyTruckByFerryCityZone: Codable, Hashable {
    let name: String
    let zipCode: String
    let volume: [String: TurkeyTruckByFerryCityZoneWeight]
    let weight: [String: TurkeyTruckByFerryCityZoneWeight]
}

struct TurkeyTruckByFerryCityWeight: Codable, Hashable {
    let pricePerCbmInEuro: Double
    let minTotalPriceInEuro: Double
}

struct TurkeyTruckByFerryCityZoneWeight: Codable, Hashable {
    let totalPriceInEuro: Double
}

extension TurkeyTruckByFerryPickup: CoreDataStorable { static var coreDataKey: String { Keys.cdTurkeyTruckByFerryPickup } }
extension TurkeyTruckByFerryPickup: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.turkeyTruckByFerryPickup }
    static var collectionNameKey: String { Keys.pickups } }
