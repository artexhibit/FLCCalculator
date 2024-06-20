import Foundation

struct FLCUserCredentials {
    let credentials: FLCUserCredentialsResponse
    let tokenIssuedTime: TimeInterval
    
    var isTokenValid: Bool {
        let currentTime = Date().timeIntervalSince1970
        let expirationTime = credentials.response.expires
        let oneDayInSeconds: TimeInterval = 86400
        return currentTime < (tokenIssuedTime + TimeInterval(expirationTime) - oneDayInSeconds)
    }
}

struct FLCUserCredentialsResponse: Codable {
    let response: FLCUserCredentialsResponseData
}

struct FLCUserCredentialsResponseData: Codable {
    let token: String
    let userId: String
    let expires: Int
}

extension FLCUserCredentials: KeychainStorable {
    static var serviceKey: String { "accountToken" }
    static var accountKey: String { "bubble" }
}
