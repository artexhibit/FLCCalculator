import Foundation

struct PersistenceManager {
    private static let ud = UserDefaults.sharedContainer
    
    static func updateItemsInUserDefaults<T: UserDefaultsStorable>(items: [T]) -> [T]? {
        if let storedItems: [T] = retrieveItemsFromUserDefaults() {
            ud.removeObject(forKey: T.userDefaultsKey)
            guard let _ = saveItemsToUserDefaults(items: items) else { return items }
            let savingError = saveItemsToUserDefaults(items: storedItems)
            print(savingError!)
            return nil
        } else {
            let savingError = saveItemsToUserDefaults(items: items) ?? .unableToUpdateUserDefaults
            print(savingError)
            return items
        }
    }
    
    static func retrieveItemsFromUserDefaults<T: UserDefaultsStorable>() -> [T]? {
        guard let itemsData = ud.object(forKey: T.userDefaultsKey) as? Data else {
            print(FLCError.unableToRetrieveFromUserDefaults)
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([T].self, from: itemsData)
        } catch {
            print(FLCError.unableToRetrieveFromUserDefaults)
            return nil
        }
    }
    
    private static func saveItemsToUserDefaults<T: UserDefaultsStorable>(items: [T]) -> FLCError? {
        do {
            let encoder = JSONEncoder()
            let encodedItems = try encoder.encode(items)
            ud.setValue(encodedItems, forKey: T.userDefaultsKey)
            return nil
        } catch  {
            return .unableToSaveToUserDefaults
        }
    }
    
    static func update(newCurrencyData: CurrencyData) -> CurrencyData? {
        if let currencyData = retrieveCurrencyData() {
            ud.removeObject(forKey: Keys.currencyData)
            guard let _ = save(currencyData: newCurrencyData) else { return newCurrencyData }
            let savingError = save(currencyData: currencyData) ?? .unableToUpdateUserDefaults
            print(savingError)
            return nil
        } else {
            let savingError = save(currencyData: newCurrencyData) ?? .unableToUpdateUserDefaults
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
            let data = try decoder.decode(CurrencyData.self, from: currencyData)
            return data
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
