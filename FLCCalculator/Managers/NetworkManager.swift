import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let decoder = JSONDecoder()
    
    func getCurrencyData() async throws -> CurrencyData {
        let endpoint = "https://www.cbr-xml-daily.ru/daily_json.js"
        
        guard let url = URL(string: endpoint) else { throw FLCError.invalidEndpoint }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {  throw FLCError.invalidResponse }
        
        do {
            return try decoder.decode(CurrencyData.self, from: data)
        } catch {
            throw FLCError.invalidData
        }
    }
    
    func getRussianDelivery(for item: CalculationResultItem) async throws -> RussianDelivery {
        let endPoint = "https://calc.pecom.ru/bitrix/components/pecom/calc/ajax.php?places[0][0]=1&places[0][1]=1&places[0][2]=1&places[0][3]=\(item.calculationData.volume)&places[0][4]=\(item.calculationData.weight)&places[0][5]=0&places[0][6]=0&take[town]=249780&deliver[town]=\(item.calculationData.toLocationCode)"
        
        guard let url = URL(string: endPoint) else { throw FLCError.invalidEndpoint }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw FLCError.invalidResponse }
        
        do {
            return try decoder.decode(RussianDelivery.self, from: data)
        } catch  {
            throw FLCError.invalidData
        }
    }
    
    func getPecCities() async throws -> [FLCPickerItem] {
        let pecCitiesEndpoint = "https://pecom.ru/ru/calc/towns.php"
        
        guard let url = URL(string: pecCitiesEndpoint) else { throw FLCError.invalidEndpoint }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 25
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw FLCError.invalidResponse }
        
        let cities = try await parseCities(from: data)
        
        return cities
    }
    
    func parseCities(from data: Data) async throws -> [FLCPickerItem] {
        var cities = [FLCPickerItem]()
        
        guard let dataDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: [String: String]] else { throw FLCError.decodingError }
        
        for (parentCityName, city) in dataDictionary {
            for (code, name) in city {
                let city = FLCPickerItem(title: name, subtitle: parentCityName, image: nil, id: code)
                cities.append(city)
            }
        }
        return cities
    }
    
    func sendSMS(code: String, phoneNumber: String) async throws {
        guard let apiKey = Bundle.main.infoDictionary?[SecretsStrings.smsApiKey] as? String else { throw FLCError.invalidData }
        let message = "\(AuthorizationStrings.authCodeSMS): \(code)"
        guard let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw FLCError.invalidData
        }
        let smsEndpoint = "https://sms.ru/sms/send?api_id=\(apiKey)&to=\(phoneNumber)&msg=\(encodedMessage)"
        
        guard let url = URL(string: smsEndpoint) else { throw FLCError.invalidEndpoint }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 25
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw FLCError.invalidResponse }
        guard let responseString = String(data: data, encoding: .utf8) else { throw FLCError.invalidResponseString }
        
        if responseString.getFirstCharacters(3) != "100" { throw FLCError.invalidResponse }
    }
    
    func sendConfirmedOrderToAMOCRM(user: FLCUser) async throws -> AMOCRMResponse {
        guard let apiKey = Bundle.main.infoDictionary?[SecretsStrings.amoCRMToken] as? String else { throw FLCError.invalidData }
        
        let endpoint = "https://victoriaryzhova21.amocrm.ru/api/v4/leads/complex"
        guard let url = URL(string: endpoint) else { throw FLCError.invalidEndpoint }
        
        let jsonPayload = createAMOOrderCreationJSONPayload(user: user)
        let jsonData = try JSONSerialization.data(withJSONObject: jsonPayload, options: [])
        let request = createAMOCRMURLRequest(jsonData: jsonData, url: url, apiKey: apiKey)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw FLCError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            let responses = try decoder.decode([AMOCRMResponse].self, from: data)
            guard let firstResponse = responses.first else { throw FLCError.invalidData }
            return firstResponse
        } catch {
            throw FLCError.invalidData
        }
    }
    
    func addCalculationInfoNoteToCreatedAMOOrder(calcData: String, orderID: Int) async throws {
        guard let apiKey = Bundle.main.infoDictionary?[SecretsStrings.amoCRMToken] as? String else { throw FLCError.invalidData }
        
        let endpoint = "https://victoriaryzhova21.amocrm.ru/api/v4/leads/notes"
        guard let url = URL(string: endpoint) else { throw FLCError.invalidEndpoint }
        let jsonPayload = createAMONoteJSONPayload(calcData: calcData, orderID: orderID)
        let jsonData = try JSONSerialization.data(withJSONObject: jsonPayload, options: [])
        let request = createAMOCRMURLRequest(jsonData: jsonData, url: url, apiKey: apiKey)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw FLCError.invalidResponse }
    }
    
    private func createAMOCRMURLRequest(jsonData: Data, url: URL, apiKey: String) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = FLCHTTPMethod.POST.rawValue
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: FLCHTTPHeaderField.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: FLCHTTPHeaderField.contentType.rawValue)
        request.setValue("amoCRM-oAuth-client/1.0", forHTTPHeaderField: FLCHTTPHeaderField.userAgent.rawValue)
        request.httpBody = jsonData
        return request
    }
    
    private func createAMONoteJSONPayload(calcData: String, orderID: Int) -> [[String: Any]] {
        return [
            [
                "entity_id": orderID,
                "note_type": "common",
                "params": [
                    "text": calcData
                ]
            ]
        ]
    }
    
    private func createAMOOrderCreationJSONPayload(user: FLCUser) -> [[String: Any]] {
        return [
            [
                "name": "Подтверждена заявка из FLC Калькулятора на iOS",
                "_embedded": [
                    "contacts": [
                        [
                            "first_name": user.fio ?? "",
                            "custom_fields_values": [
                                [
                                    "field_code": "PHONE",
                                    "values": [
                                        [
                                            "value": user.mobilePhone,
                                            "enum_code": "WORK"
                                        ]
                                    ]
                                ],
                                [
                                    "field_id": 768137,
                                    "values": [
                                        [
                                            "enum_id": 573559,
                                            "value": user.email
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ],
                    "companies": [
                        [
                            "name": user.companyName ?? ""
                        ]
                    ],
                    "tags": [
                        ["name": "iOS"],
                        ["name": "Калькулятор"]
                    ]
                ]
            ]
        ]
    }
}
