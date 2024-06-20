import Foundation

struct PhoneNumberExistResponse: Codable {
    let status: String
    let response: ResponseData
}

struct ResponseData: Codable {
    let result: Bool
}
