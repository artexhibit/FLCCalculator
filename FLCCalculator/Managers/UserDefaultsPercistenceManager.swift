import Foundation

struct UserDefaultsPercistenceManager {
    private static let ud = UserDefaults.sharedContainer
    
    static func updateItemsInUserDefaults<T: UserDefaultsStorable>(items: [T]) {
        if let storedItems: [T] = retrieveItemsFromUserDefaults() {
            ud.removeObject(forKey: T.userDefaultsKey)
            _ = saveItemsToUserDefaults(items: items)
            
            let savingError = saveItemsToUserDefaults(items: storedItems)
            print(savingError ?? .unableToSaveToUserDefaults)
        } else {
            let savingError = saveItemsToUserDefaults(items: items) ?? .unableToUpdateUserDefaults
            print(savingError)
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
    
    static func saveItemsToUserDefaults<T: UserDefaultsStorable>(items: [T]) -> FLCError? {
        do {
            let encoder = JSONEncoder()
            let encodedItems = try encoder.encode(items)
            ud.setValue(encodedItems, forKey: T.userDefaultsKey)
            return nil
        } catch  {
            return .unableToSaveToUserDefaults
        }
    }
    
    static func updateItemInUserDefaults<T: UserDefaultsStorable>(item: T) {
        if let storedItem: T = retrieveItemFromUserDefaults() {
            ud.removeObject(forKey: T.userDefaultsKey)
            
            if let _ = saveItemToUserDefaults(item: item) {
                let savingError = saveItemToUserDefaults(item: storedItem)
                print(savingError ?? .unableToSaveToUserDefaults)
            }
        } else {
            let savingError = saveItemToUserDefaults(item: item) ?? .unableToUpdateUserDefaults
            print(savingError)
        }
    }
    
    static func retrieveItemFromUserDefaults<T: UserDefaultsStorable>() -> T? {
        guard let itemData = ud.object(forKey: T.userDefaultsKey) as? Data else {
            print(FLCError.unableToRetrieveFromUserDefaults)
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: itemData)
        } catch {
            print(FLCError.unableToRetrieveFromUserDefaults)
            return nil
        }
    }
    
    static func saveItemToUserDefaults<T: UserDefaultsStorable>(item: T) -> FLCError? {
        do {
            let encoder = JSONEncoder()
            let encodedItem = try encoder.encode(item)
            ud.setValue(encodedItem, forKey: T.userDefaultsKey)
            return nil
        } catch  {
            return .unableToSaveToUserDefaults
        }
    }
    
    static func deleteItemFromUserDefaults<T: UserDefaultsStorable>(itemType: T.Type) {
        ud.removeObject(forKey: T.userDefaultsKey)
    }
}
