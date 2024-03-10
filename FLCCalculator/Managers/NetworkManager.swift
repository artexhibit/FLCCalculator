import Foundation
import CoreData

class NetworkManager {
    static let shared = NetworkManager()
    
    func getPecCities() async throws -> [PecCity] {
        let pecCitiesEndpoint = "https://pecom.ru/ru/calc/towns.php"
        
        guard let url = URL(string: pecCitiesEndpoint) else { throw FLCError.invalidEndpoint }
        
        let (data, responce) = try await URLSession.shared.data(from: url)
        
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else { throw FLCError.invalidResponce }
        
        let cities = try await parseCities(from: data)
        
        return cities
    }
    
    func parseCities(from data: Data) async throws -> [PecCity] {
        var cities = [PecCity]()
        
        guard let dataDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: [String: String]] else { throw FLCError.decodingError }
        
        for (parentCityName, city) in dataDictionary {
            for (code, name) in city {
                let city = PecCity(name: name, parentCityName: parentCityName, code: code)
                cities.append(city)
            }
        }
        return cities
    }
}
