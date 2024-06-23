import Foundation

class AuthorizationManager {
    static let shared = AuthorizationManager()
    private let decoder = JSONDecoder()
    private let lkBaseEndpoint = "https://lk-flc.bubbleapps.io/version-test/api/1.1/"
    private let calcBaseEndpoint = "https://calc.free-lines.ru/version-test/api/1.1/obj/user/"
    private let apiKey = Bundle.main.infoDictionary?["Bubble Token"] as? String
    
    private init() { decoder.keyDecodingStrategy = .convertFromSnakeCase }
    
    func isPhoneNumberExist(_ number: String) async throws -> Bool {
        guard let apiKey = apiKey else { throw FLCError.invalidBubbleToken }
        let finalEndpoint = lkBaseEndpoint + "wf/check_phone"
        guard let url = URL(string: finalEndpoint) else { throw FLCError.invalidEndpoint }
        let request = createAccountURLRequest(url: url, number: number, apikey: apiKey)
        
        let (data, responce) = try await URLSession.shared.data(for: request)
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else { throw FLCError.invalidResponce }
        
        do {
            let decodedData = try decoder.decode(PhoneNumberExistResponse.self, from: data)
            return decodedData.response.result
        } catch {
            throw FLCError.invalidData
        }
    }
    
    func loginWithPhoneNumber(_ number: String) async throws -> FLCUserCredentials {
        guard let apiKey = apiKey else { throw FLCError.invalidBubbleToken }
        let finalEndpoint = lkBaseEndpoint + "wf/log_in"
        guard let url = URL(string: finalEndpoint) else { throw FLCError.invalidEndpoint }
        let request = createAccountURLRequest(url: url, number: number, apikey: apiKey)
        
        let (data, responce) = try await URLSession.shared.data(for: request)
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else { throw FLCError.invalidResponce }
        
        do {
            let credentials = try decoder.decode(FLCUserCredentialsResponse.self, from: data)
            return FLCUserCredentials(credentials: credentials, tokenIssuedTime: Date().timeIntervalSince1970)
        } catch {
            throw FLCError.invalidData
        }
    }
    
    func registerUserWith(number: String, email: String) async throws -> FLCUserCredentials {
        guard let apiKey = apiKey else { throw FLCError.invalidBubbleToken }
        let finalEndpoint = lkBaseEndpoint + "wf/sign_up"
        guard let url = URL(string: finalEndpoint) else { throw FLCError.invalidEndpoint }
        let request = createAccountURLRequest(url: url, number: number, email: email, apikey: apiKey)
        
        let (data, responce) = try await URLSession.shared.data(for: request)
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else { throw FLCError.invalidResponce }
        
        do {
            let credentials = try decoder.decode(FLCUserCredentialsResponse.self, from: data)
            return FLCUserCredentials(credentials: credentials, tokenIssuedTime: Date().timeIntervalSince1970)
        } catch {
            throw FLCError.invalidData
        }
    }
    
    func getUserInfo(token: String, userId: String) async throws -> FLCUser {
        let finalEndpoint = calcBaseEndpoint + userId
        guard let url = URL(string: finalEndpoint) else { throw FLCError.invalidEndpoint }
        let request = createAuthorizationURLRequest(url: url, token: token, httpMethod: .GET)
        
        let (data, responce) = try await URLSession.shared.data(for: request)
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else { throw FLCError.invalidResponce }
        
        do {
            let userData = try decoder.decode(FLCUserResponse.self, from: data)
            return getUser(data: userData)
        } catch {
            throw FLCError.invalidData
        }
    }
    
    func saveAccountDataToBubbleDatabase(for user: FLCUser, token: String, userId: String) async throws {
        let finalEndpoint = calcBaseEndpoint + userId
        guard let url = URL(string: finalEndpoint) else { throw FLCError.invalidEndpoint }
        var request = createAuthorizationURLRequest(url: url, token: token, httpMethod: .PATCH)
        request.setValue("application/json", forHTTPHeaderField: FLCHTTPHeaderField.contentType.rawValue)
        let jsonData = try JSONSerialization.data(withJSONObject: getBubbleDictionary(for: user))
        request.httpBody = jsonData
        
        let (_, responce) = try await URLSession.shared.data(for: request)
        
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 204 else { throw FLCError.invalidResponce }
    }
    
    private func createAccountURLRequest(url: URL, number: String, email: String? = nil, apikey: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = FLCHTTPMethod.POST.rawValue
        
        if let email { request.setValue(email, forHTTPHeaderField: FLCHTTPHeaderField.email.rawValue)  }
        
        request.setValue(number, forHTTPHeaderField: FLCHTTPHeaderField.phone.rawValue)
        request.setValue(apiKey, forHTTPHeaderField: FLCHTTPHeaderField.authorization.rawValue)
        return request
    }
    
    private func createAuthorizationURLRequest(url: URL, token: String, httpMethod: FLCHTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("Bearer " + token, forHTTPHeaderField: FLCHTTPHeaderField.authorization.rawValue)
        return request
    }
    
    private func getUser(data: FLCUserResponse) -> FLCUser {
        var user = FLCUser(
            fio: data.response.fio,
            email: data.response.emailUser,
            mobilePhone: data.response.phone,
            companyName: data.response.company,
            inn: data.response.inn,
            dtCount: data.response.dtCount,
            productRange: nil
        )
        user.setBirthDateFromISO8601(from: data.response.bday ?? "")
        return user
    }
    
    private func getBubbleDictionary(for user: FLCUser) -> [String: Any] {
        var dictionary: [String: Any] = [:]

        if let birthDate = user.birthDate, !birthDate.isEmpty { dictionary[FLCBubbleUserDataKeys.bday] = birthDate }
        if let companyName = user.companyName, !companyName.isEmpty { dictionary[FLCBubbleUserDataKeys.company] = companyName }
        if let dtCount = user.dtCount { dictionary[FLCBubbleUserDataKeys.dtCount] = dtCount }
        if let fio = user.fio, !fio.isEmpty { dictionary[FLCBubbleUserDataKeys.fio] = fio }
        if let inn = user.inn { dictionary[FLCBubbleUserDataKeys.inn] = inn }
        
        dictionary[FLCBubbleUserDataKeys.phone] = user.mobilePhone
        dictionary[FLCBubbleUserDataKeys.email] = user.email
        return dictionary
    }
    
    func createVerificationCode(digits: Int = 4) -> String {
        var number = ""
        for _ in 1...digits { number += "\(Int.random(in: 1...9))" }
        return number
    }
}
