import Foundation

struct FLCUser {
    var fio: String?
    var email: String
    var mobilePhone: String
    var birthDate: String?
    var companyName: String?
    var inn: Int?
    var dtCount: Int?
    var productRange: [String]?
    
    mutating func setBirthDateFromISO8601(from stringDate: String) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: stringDate) else { return }
        birthDate = date.makeString(format: .dotDMY)
    }
    
    mutating func setBirthDateToISO8601(from stringDate: String) {
        guard let date = stringDate.createDate(format: .dotDMY) else { return }
        birthDate = ISO8601DateFormatter().string(from: date)
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
