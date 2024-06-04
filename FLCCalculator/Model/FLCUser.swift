import Foundation

struct FLCUser {
    var name: String?
    var email: String
    var mobilePhone: String
    var birthDate: String?
    var companyName: String?
    var taxPayerID: String?
    var customsDeclarationsAmountPerYear: Int?
    var productRange: [String]?
}

extension FLCUser: UserDefaultsStorable { static var userDefaultsKey: String { Keys.flcUser } }
