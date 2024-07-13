import Foundation

struct PhoneNumberResponse: Codable {
    let status: String
    let response: ResponseData
}

struct ResponseData: Codable {
    let result: Bool
}
