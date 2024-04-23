import Foundation

struct TurkeyPickup: Codable, Hashable {
    let vat: Double
    let cities: [TurkeyCity]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(vat)
        hasher.combine(cities)
    }
}

struct TurkeyCity: Codable, Hashable {
    let name: String
    let zones: [TurkeyCityZone]
    let zipCode: String
    let weight: [String: TurkeyCityWeight]
}

struct TurkeyCityZone: Codable, Hashable {
    let name: String
    let zipCode: String
    let volume: [String: TurkeyCityZoneWeight]
    let weight: [String: TurkeyCityZoneWeight]
}

struct TurkeyCityWeight: Codable, Hashable {
    let pricePerCbmInEuro: Double
    let minTotalPriceInEuro: Double
}

struct TurkeyCityZoneWeight: Codable, Hashable {
    let totalPriceInEuro: Double
}

extension TurkeyPickup: UserDefaultsStorable {
    static var userDefaultsKey: String { Keys.turkeyPickup }
}

extension TurkeyPickup: FirebaseIdentifiable {
    static var collectionNameKey: String { Keys.turkeyPickup }
}
