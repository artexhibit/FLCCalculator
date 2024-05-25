import Foundation

struct ChinaAirTariff: Codable, Hashable {
    let name: String
    let insurancePercentage: Double
    let insuranceAgentVisit: Double
    let cargoHandling: Double
    let minCargoHandling: Double
    let customsClearance: Double
    let formalitiesCompletion: Double
    let cargoArrivalNotification: Double
    let documentsCopiesMaking: Double
    let airportWarehouseStorage: Double
    let transitDays: Int
    let targetWeight: Double
    let maxLengthMeters: Double
    let maxWidthMeters: Double
    let maxHeightMeters: Double
    let cities: [ChinaAirTariffCity]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(insurancePercentage)
        hasher.combine(insuranceAgentVisit)
        hasher.combine(cargoHandling)
        hasher.combine(minCargoHandling)
        hasher.combine(customsClearance)
        hasher.combine(formalitiesCompletion)
        hasher.combine(cargoArrivalNotification)
        hasher.combine(documentsCopiesMaking)
        hasher.combine(airportWarehouseStorage)
        hasher.combine(transitDays)
        hasher.combine(targetWeight)
        hasher.combine(maxLengthMeters)
        hasher.combine(maxWidthMeters)
        hasher.combine(maxHeightMeters)
        hasher.combine(cities)
    }
}

struct ChinaAirTariffCity: Codable, Hashable {
    let name: String
    let targetAirport: String
    let groupageDocs: Double
    let prices: [String: ChinaAirTariffPrice]
}

struct ChinaAirTariffPrice: Codable, Hashable {
    let pricePerKg: Double
}

extension ChinaAirTariff: CoreDataStorable { static var coreDataKey: String { Keys.cdChinaAirTariff } }
extension ChinaAirTariff: FirebaseIdentifiable {
    static var collectionNameKey: String { Keys.tariffs }
    static var fieldNameKey: String { Keys.chinaAirTariff }
}
