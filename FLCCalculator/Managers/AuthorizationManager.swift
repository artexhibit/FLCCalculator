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
        let request = createPhoneNumberRequest(url: url, number: number, apikey: apiKey)
        
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
        let request = createPhoneNumberRequest(url: url, number: number, apikey: apiKey)
        
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
        let request = createAuthorizationRequest(url: url, token: token, httpMethod: .GET)
        
        let (data, responce) = try await URLSession.shared.data(for: request)
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else { throw FLCError.invalidResponce }
        
        do {
            let userData = try decoder.decode(FLCUserResponse.self, from: data)
            return getUser(data: userData)
        } catch {
            throw FLCError.invalidData
        }
    }
    
    private func createPhoneNumberRequest(url: URL, number: String, apikey: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = FLCHTTPMethod.POST.rawValue
        request.setValue(number, forHTTPHeaderField: FLCHTTPHeaderField.phone.rawValue)
        request.setValue(apiKey, forHTTPHeaderField: FLCHTTPHeaderField.authorization.rawValue)
        return request
    }
    
    private func createAuthorizationRequest(url: URL, token: String, httpMethod: FLCHTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("Bearer " + token, forHTTPHeaderField: FLCHTTPHeaderField.authorization.rawValue)
        return request
    }
    
    private func getUser(data: FLCUserResponse) -> FLCUser {
        var user = FLCUser(name: data.response.fio,
                           email: data.response.emailUser,
                           mobilePhone: data.response.phone,
                           companyName: data.response.company,
                           companyTaxPayerID: data.response.inn,
                           customsDeclarationsAmountPerYear: data.response.dtCount,
                           productRange: nil)
        user.setBirthDate(from: data.response.bday ?? "")
        return user
    }
}
