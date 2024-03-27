import Foundation

struct PersistenceManager {
    private static let ud = UserDefaults.sharedContainer
    
    static func update(tariffs: [Tariff], completed: @escaping (Result<[Tariff], FLCError>) -> Void) {
        retrieveTariffs { result in
            switch result {
            case .success(let storedTariffs):
                ud.removeObject(forKey: Keys.tariffs)
                
                if let savingError = save(tariffs: tariffs) {
                    let _ = save(tariffs: storedTariffs)
                    completed(.failure(savingError))
                } else {
                    completed(.success([]))
                }
            case .failure(_):
                if let savingError = save(tariffs: tariffs) {
                    completed(.failure(savingError))
                } else {
                    completed(.success([]))
                }
            }
        }
    }
    
    static func retrieveTariffs(completed: @escaping (Result<[Tariff], FLCError>) -> Void) {
        guard let tariffsData = ud.object(forKey: Keys.tariffs) as? Data else {
            completed(.failure(.unableToRetrieveFromUserDefaults))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let tariffs = try decoder.decode([Tariff].self, from: tariffsData)
            completed(.success(tariffs))
        } catch {
            completed(.failure(.unableToRetrieveFromUserDefaults))
        }
    }
    
    private static func save(tariffs: [Tariff]) -> FLCError? {
        do {
            let encoder = JSONEncoder()
            let encodedTariffs = try encoder.encode(tariffs)
            ud.setValue(encodedTariffs, forKey: Keys.tariffs)
            return nil
        } catch  {
            return .unableToSaveToUserDefaults
        }
    }
    
    static func update(currencyData: CurrencyData, completed: @escaping (Result<CurrencyData, FLCError>) -> Void) {
        let emptyCurrencyData = CurrencyData(Date: "", Valute: [:])
        
        retrieveCurrencyData { result in
            switch result {
            case .success(let storedCurrencyData):
                ud.removeObject(forKey: Keys.currencyData)
                
                if let savingError = save(currencyData: currencyData) {
                    let _ = save(currencyData: storedCurrencyData)
                    completed(.failure(savingError))
                } else {
                    completed(.success(emptyCurrencyData))
                }
            case .failure(_):
                if let savingError = save(currencyData: currencyData) {
                    completed(.failure(savingError))
                } else {
                    completed(.success(emptyCurrencyData))
                }
            }
        }
    }
    
    static func retrieveCurrencyData(completed: @escaping (Result<CurrencyData, FLCError>) -> Void) {
        guard let currencyData = ud.object(forKey: Keys.currencyData) as? Data else {
            completed(.failure(.unableToRetrieveFromUserDefaults))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedCurrencyData = try decoder.decode(CurrencyData.self, from: currencyData)
            completed(.success(decodedCurrencyData))
        } catch {
            completed(.failure(.unableToRetrieveFromUserDefaults))
        }
    }
    
    private static func save(currencyData: CurrencyData) -> FLCError? {
        do {
            let encoder = JSONEncoder()
            let encodedCurrencyData = try encoder.encode(currencyData)
            ud.setValue(encodedCurrencyData, forKey: Keys.currencyData)
            return nil
        } catch  {
            return .unableToSaveToUserDefaults
        }
    }
}
