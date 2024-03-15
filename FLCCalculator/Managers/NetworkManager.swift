import Foundation
import CoreData

class NetworkManager {
    static let shared = NetworkManager()
    
    let delivery = "http://calc.pecom.ru/bitrix/components/pecom/calc/ajax.php?places[0][0]=1&places[0][1]=1&places[0][2]=1&places[0][3]=2&places[0][4]=900&places[0][5]=0&places[0][6]=0&take[town]=249780&deliver[town]=-477"
    
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
}
