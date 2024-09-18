import UIKit

protocol FLCConfigurableCell {
    func configureSettingsCell(with content: SettingsCellContent)
}

protocol DelegateConfigurable {
    func setDelegate(with vc: UIViewController)
}

protocol FirebaseIdentifiable: Hashable, Codable {
    static var collectionNameKey: String { get }
    static var fieldNameKey: String { get }
}

protocol KeychainStorable: Codable {
    static var serviceKey: String { get }
    static var accountKey: String { get }
}

protocol UserDefaultsStorable: Codable, Hashable {
    static var userDefaultsKey: String { get }
}

protocol CoreDataStorable: Codable, Hashable {
    static var coreDataKey: String { get }
}

protocol PickupDataConvertible {
    var yuanRate: Double { get }
    var density: Double { get }
    var warehouses: [WarehouseConvertible] { get }
}

protocol WarehouseConvertible {
    var name: String { get }
    var totalPart3CoefficientOne: Double { get }
    var totalPart3CoefficientTwo: Double { get }
    var totalPart3CoefficientThree: Double { get }
    var cityList: [CityConvertible] { get }
}

protocol CityConvertible {
    var name: String { get }
    var province: String { get }
    var transitDays: String { get }
    var weightList: [String: WeightConvertible] { get }
}

protocol WeightConvertible {
    var totalPart1Coefficient: Double { get }
    var totalPart2Coefficient: Double { get }
}

protocol AnyTariffsConvertible {
    var volume: [String: Double] { get }
    var weight: [String: Double] { get }
}

protocol AnyTariffDataConvertible {
    var targetWeight: Double { get }
    var minLogisticsPrice: Double { get }
    var tariffsList: AnyTariffsConvertible { get }
}

protocol AirPickupIdentifiable {
    var airTargetWeight: Double { get }
    var airCities: [AirPickupCity] { get }
}

protocol AirPickupCity {
    var airName: String { get }
    var airTargetAirport: String { get }
    var airTargetCities: [String] { get }
    var airTransitDays: String { get }
    var airPrices: [String: AirPickupCityPrice] { get }
}

protocol AirPickupCityPrice {
    var airPrice: Double { get }
}

protocol AirTariffIdentifiable {
    var airLogisticsType: FLCLogisticsType { get }
    var airTargetWeight: Double { get }
    var airFormalitiesCompletion: Double { get }
    var airCargoArrivalNotification: Double { get }
    var airDocumentsCopiesMaking: Double { get }
    var airAirportWarehouseStorage: Double { get }
    var airInsuranceAgentVisit: Double { get }
    var airCargoHandling: Double { get }
    var airMinLogisticsProfit: Double { get }
    var airMinLogisticsPrice: Double { get }
    var airCities: [AirTariffCity] { get }
}

protocol AirTariffCity {
    var airName: String { get }
    var airTargetAirport: String { get }
    var airPrices: [String: AirTariffPrice] { get }
}

protocol AirTariffPrice {
    var airPricePerKg: Double { get }
    var airGroupageDocs: Double { get }
    var airGroupageDocsV2: Double { get }
}
