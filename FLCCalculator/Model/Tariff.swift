import Foundation

struct Tariff: Codable, Hashable {
    let name: String
    let insuranceValue: Double
    let insuranceMinValue: Double?
}
