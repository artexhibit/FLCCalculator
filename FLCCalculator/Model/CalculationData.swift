import Foundation

struct CalculationData: Hashable {
    let id: Int32
    let calculationDate: String = Date().formatted(date: .numeric, time: .omitted)
    let countryFrom: String
    let countryTo: String
    let deliveryType: String
    let deliveryTypeCode: String
    let departureAirport: String
    let fromLocation: String
    let toLocation: String
    let toLocationCode: String
    let goodsType: String
    let volume: Double
    let weight: Double
    let invoiceAmount: Double
    let invoiceCurrency: String
    let needCustomClearance: Bool
    let totalPrices: [TotalPriceData]?
    let isFromCoreData: Bool
    let isConfirmed: Bool
    let exchangeRate: Double
}
