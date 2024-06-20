import Foundation

struct FLCUser {
    var name: String?
    var email: String
    var mobilePhone: String
    var birthDate: String?
    var companyName: String?
    var companyTaxPayerID: Int?
    var customsDeclarationsAmountPerYear: Int?
    var productRange: [String]?
    
    mutating func setBirthDate(from stringDate: String) {
        guard let date = ISO8601DateFormatter().date(from: stringDate) else { return }
        birthDate = date.makeString(format: .dotDMY)
    }
}

struct FLCUserResponse: Codable {
    let response: FLCUserResponseData
}

struct FLCUserResponseData: Codable {
    let bday: String?
    let company: String?
    let dtCount: Int?
    let fio: String?
    let inn: Int?
    let phone: String
    let emailUser: String
}

extension FLCUser: UserDefaultsStorable { static var userDefaultsKey: String { Keys.flcUser } }
