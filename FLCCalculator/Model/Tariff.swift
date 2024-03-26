import Foundation

struct Tariff: Codable {
    
    let name: String
    let insurancePersentage: Double
    let cargoHandling: Double
    let minCargoHandling: Double
    let groupageDocs: Double
    let minLogisticsPrice: Double
    let customsClearance: Double
    let customsWarehousePrice: Double
    let targetWeight: Double
    let tariffs: Tariffs
}

struct Tariffs: Codable {
    let volume: [String: Double]
    let weight: [String: Double]
}
