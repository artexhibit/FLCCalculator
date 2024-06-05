import Foundation

protocol FLCConfigurableCell {
    func configureSettingsCell(with content: SettingsCellContent)
}

protocol FirebaseIdentifiable: Hashable, Codable {
    static var collectionNameKey: String { get }
    static var fieldNameKey: String { get }
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
