import Foundation

struct TurkeyNovorossiyskBySeaPickup: Codable, Hashable {
    let vat: Double
    let maxWeightInKg: Int
    let cities: [TurkeyNovorossiyskBySeaCity]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(vat)
        hasher.combine(maxWeightInKg)
        hasher.combine(cities)
    }
}

struct TurkeyNovorossiyskBySeaCity: Codable, Hashable {
    let name: String
    let zones: [TurkeyNovorossiyskBySeaCityZone]
    let targetCities: [String]
    let zipCode: String
    let transitDays: String
    let volume: [String: TurkeyNovorossiyskBySeaCityWeight]
}

struct TurkeyNovorossiyskBySeaCityZone: Codable, Hashable {
    let name: String
    let zipCode: String
    let targetRegions: [String]
    let weight: [String: TurkeyNovorossiyskBySeaCityZoneWeight]
}

struct TurkeyNovorossiyskBySeaCityWeight: Codable, Hashable {
    let pricePerCbmInEuro: Double
    let minTotalPriceInEuro: Double
}

struct TurkeyNovorossiyskBySeaCityZoneWeight: Codable, Hashable {
    let totalPriceInEuro: Double
}

extension TurkeyNovorossiyskBySeaPickup: CoreDataStorable { static var coreDataKey: String { Keys.cdTurkeyNovorossiyskBySeaPickup } }
extension TurkeyNovorossiyskBySeaPickup: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.turkeyNovorossiyskBySeaPickup }
    static var collectionNameKey: String { Keys.pickups } }
