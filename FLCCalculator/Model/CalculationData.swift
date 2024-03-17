import Foundation

struct CalculationData: Hashable {
    let calculationDate: String = Date().formatted(date: .numeric, time: .omitted)
    let countryFrom: String
    let countryTo: String
    let deliveryType: String
    let deliveryTypeCode: String
    let fromLocation: String
    let toLocation: String
    let toLocationCode: String
    let goodsType: String
    let volume: Double
    let weight: Double
    let needCustomClearance: Bool
}
