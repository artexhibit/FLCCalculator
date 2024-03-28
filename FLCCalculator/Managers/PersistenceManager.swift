import Foundation

struct PersistenceManager {
    private static let ud = UserDefaults.sharedContainer
    
    static func update(tariffs: [Tariff]) -> [Tariff]? {
        if let tariffs = retrieveTariffs() {
            let storedTariffs = tariffs
            
            ud.removeObject(forKey: Keys.tariffs)
            guard let _ = save(tariffs: tariffs) else { return tariffs }
            let savingError = save(tariffs: storedTariffs)
            print(savingError!)
            return nil
        } else {
            let savingError = save(tariffs: tariffs) ?? .unableToUpdateUserDefaults
            print(savingError)
            return nil
        }
    }
    
    static func retrieveTariffs() -> [Tariff]? {
        guard let tariffsData = ud.object(forKey: Keys.tariffs) as? Data else {
            print(FLCError.unableToRetrieveFromUserDefaults)
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Tariff].self, from: tariffsData)
        } catch {
            print(FLCError.unableToRetrieveFromUserDefaults)
            return nil
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
    
    static func update(currencyData: CurrencyData) -> CurrencyData? {
        if let currencyData = retrieveCurrencyData() {
            let storedCurrencyData = currencyData
            
            ud.removeObject(forKey: Keys.currencyData)
            guard let _ = save(currencyData: currencyData) else { return currencyData }
            let savingError = save(currencyData: storedCurrencyData) ?? .unableToUpdateUserDefaults
            print(savingError)
            return nil
        } else {
            let savingError = save(currencyData: currencyData) ?? .unableToUpdateUserDefaults
            print(savingError)
            return nil
        }
    }
    
    static func retrieveCurrencyData() -> CurrencyData? {
        guard let currencyData = ud.object(forKey: Keys.currencyData) as? Data else {
            print(FLCError.unableToRetrieveFromUserDefaults)
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(CurrencyData.self, from: currencyData)
        } catch {
            print(FLCError.unableToRetrieveFromUserDefaults)
            return nil
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
