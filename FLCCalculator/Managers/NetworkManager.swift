import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let decoder = JSONDecoder()
    
    func getCurrencyData() async throws -> CurrencyData {
        let endpoint = "https://www.cbr-xml-daily.ru/daily_json.js"
        
        guard let url = URL(string: endpoint) else { throw FLCError.invalidEndpoint }
        
        let (data, responce) = try await URLSession.shared.data(from: url)
        
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else {  throw FLCError.invalidResponce }
        
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
        
        let (data, responce) = try await URLSession.shared.data(for: request)
  
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else { throw FLCError.invalidResponce }
   
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
        
        let (data, responce) = try await URLSession.shared.data(for: request)
        
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else { throw FLCError.invalidResponce }
        
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
        guard let apiKey = Bundle.main.infoDictionary?["SMS API Key"] as? String else { throw FLCError.invalidData }
        let message = "Ваш код для авторизации в приложении FLC: "
        let smsEndpoint = "https://sms.ru/sms/send?api_id=\(apiKey)&to=\(phoneNumber)&msg=\(message)\(code)"
        
        guard let url = URL(string: smsEndpoint) else { throw FLCError.invalidEndpoint }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 25
        
        let (data, responce) = try await URLSession.shared.data(for: request)
        
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else { throw FLCError.invalidResponce }
        guard let responseString = String(data: data, encoding: .utf8) else { throw FLCError.invalidResponceString }
        
        if responseString.getFirstCharacters(3) != "100" { throw FLCError.invalidResponce }
    }
}
