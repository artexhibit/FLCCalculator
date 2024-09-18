import Foundation

struct TurkeyAirVKOTariff: Codable, Hashable {
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
    let cities: [TurkeyAirVKOTariffCity]
    
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

struct TurkeyAirVKOTariffCity: Codable, Hashable {
    let name: String
    let targetAirport: String
    let prices: [String: TurkeyAirVKOTariffPrice]
}

struct TurkeyAirVKOTariffPrice: Codable, Hashable {
    let pricePerKg: Double
    let groupageDocs: Double
}

extension TurkeyAirVKOTariff: CoreDataStorable { static var coreDataKey: String { Keys.cdTurkeyAirVKOTariff } }
extension TurkeyAirVKOTariff: FirebaseIdentifiable {
    static var collectionNameKey: String { Keys.tariffs }
    static var fieldNameKey: String { Keys.turkeyAirVKOTariff }
}

extension TurkeyAirVKOTariff: AirTariffIdentifiable {
    var airLogisticsType: FLCLogisticsType { .turkeyAirVKO }
    var airMinLogisticsProfit: Double { minLogisticsProfit ?? 0 }
    var airMinLogisticsPrice: Double { minLogisticsPrice }
    var airTargetWeight: Double { targetWeight }
    var airFormalitiesCompletion: Double { formalitiesCompletion }
    var airCargoArrivalNotification: Double { cargoArrivalNotification }
    var airDocumentsCopiesMaking: Double { documentsCopiesMaking }
    var airAirportWarehouseStorage: Double { airportWarehouseStorage }
    var airInsuranceAgentVisit: Double { insuranceAgentVisit }
    var airCargoHandling: Double { cargoHandling }
    var airCities: [AirTariffCity] { cities }
}

extension TurkeyAirVKOTariffCity: AirTariffCity {
    var airName: String { name }
    var airTargetAirport: String { targetAirport }
    var airPrices: [String : any AirTariffPrice] { prices }
}

extension TurkeyAirVKOTariffPrice: AirTariffPrice {
    var airPricePerKg: Double { pricePerKg }
    var airGroupageDocs: Double { groupageDocs }
    var airGroupageDocsV2: Double { 0 }
}
