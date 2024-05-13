import Foundation

struct CurrencyData: Codable, Hashable {
    let Date: String
    let Valute: [String: Details]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Date)
        hasher.combine(Valute)
    }
}

struct Details: Codable, Hashable {
    let CharCode: String
    let Value: Double
    let Nominal: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(CharCode)
        hasher.combine(Value)
        hasher.combine(Nominal)
    }
}

extension CurrencyData: UserDefaultsStorable { static var userDefaultsKey: String { Keys.currencyData } }
