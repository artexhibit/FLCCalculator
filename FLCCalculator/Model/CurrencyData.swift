import Foundation

struct CurrencyData: Codable {
    let Date: String
    let Valute: [String: Details]
}

struct Details: Codable {
    let CharCode: String
    let Value: Double
    let Nominal: Int
}
