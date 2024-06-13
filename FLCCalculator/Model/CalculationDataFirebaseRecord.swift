import Foundation

struct CalculationDataFirebaseRecord: Codable {
    var calculationDate: String
    var name: String
    var email: String
    var mobilePhone: String
    var userCalculationID: Int32
    var countryFrom: String
    var countryTo: String
    var deliveryType: String
    var deliveryTypeCode: String
    var departureAirport: String
    var fromLocation: String
    var toLocation: String
    var toLocationCode: String
    var goodsType: String
    var volume: Double
    var weight: Double
    var invoiceAmount: Double
    var invoiceCurrency: String
    var needCustomClearance: Bool
    var isConfirmed: Bool
    var exchangeRate: Double
    var totalPriceData: [TotalPriceData]
}

extension CalculationDataFirebaseRecord {
    func toDictionary() -> [String: Any] {
        return [
            "calculationDate": calculationDate,
            "name": name,
            "email": email,
            "mobilePhone": mobilePhone,
            "userCalculationID": userCalculationID,
            "countryFrom": countryFrom,
            "countryTo": countryTo,
            "deliveryType": deliveryType,
            "deliveryTypeCode": deliveryTypeCode,
            "departureAirport": departureAirport,
            "fromLocation": fromLocation,
            "toLocation": toLocation,
            "toLocationCode": toLocationCode,
            "goodsType": goodsType,
            "volume": volume,
            "weight": weight,
            "invoiceAmount": invoiceAmount,
            "invoiceCurrency": invoiceCurrency,
            "needCustomClearance": needCustomClearance,
            "isConfirmed": isConfirmed,
            "exchangeRate": exchangeRate,
            "totalPriceData": totalPriceData.map { $0.toDictionary() }
        ]
    }
}

extension CalculationDataFirebaseRecord: UserDefaultsStorable { static var userDefaultsKey: String { Keys.calculationDataFirebaseRecord }}
