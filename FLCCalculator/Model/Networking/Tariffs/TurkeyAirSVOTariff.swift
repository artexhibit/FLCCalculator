import Foundation

struct TurkeyAirSVOTariff: Codable, Hashable {
    let name: String
    let insurancePercentage: Double
    let insuranceAgentVisit: Double
    let minLogisticsProfit: Double?
    let minLogisticsPrice: Double
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
    let maxWeightKg: Double
    let cities: [TurkeyAirSVOTariffCity]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(insurancePercentage)
        hasher.combine(insuranceAgentVisit)
        hasher.combine(minLogisticsProfit)
        hasher.combine(minLogisticsPrice)
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
        hasher.combine(maxWeightKg)
        hasher.combine(cities)
    }
}

struct TurkeyAirSVOTariffCity: Codable, Hashable {
    let name: String
    let targetAirport: String
    let prices: [String: TurkeyAirSVOTariffPrice]
}

struct TurkeyAirSVOTariffPrice: Codable, Hashable {
    let pricePerKg: Double
    let groupageDocs: Double
}

extension TurkeyAirSVOTariff: CoreDataStorable { static var coreDataKey: String { Keys.cdTurkeyAirSVOTariff } }
extension TurkeyAirSVOTariff: FirebaseIdentifiable {
    static var collectionNameKey: String { Keys.tariffs }
    static var fieldNameKey: String { Keys.turkeyAirSVOTariff }
}
