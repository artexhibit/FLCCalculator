import Foundation

struct UserDefaultsManager {
    private static let ud = UserDefaults.sharedContainer
    
    static var isUserLoggedIn: Bool {
        get { ud.bool(forKey: Keys.isUserLoggedIn) }
        set { ud.setValue(newValue, forKey: Keys.isUserLoggedIn) }
    }
    
    static var isHapticTurnedOn: Bool {
        get { ud.object(forKey: Keys.isHapticTurnedOn) == nil ? true : ud.bool(forKey: Keys.isHapticTurnedOn) }
        set { ud.setValue(newValue, forKey: Keys.isHapticTurnedOn) }
    }
    
    static var appTheme: String {
        get { ud.string(forKey: Keys.appTheme) ?? "Как на устройстве" }
        set { ud.setValue(newValue, forKey: Keys.appTheme) }
    }
    
    static var dateWhenDataWasUpdated: String {
        get { ud.string(forKey: Keys.dateWhenDataWasUpdated) ?? "" }
        set { ud.setValue(newValue, forKey: Keys.dateWhenDataWasUpdated) }
    }
    
    static var lastCurrencyDataUpdate: Date? {
        get { ud.object(forKey: Keys.lastCurrencyDataUpdate) as? Date }
        set { ud.setValue(newValue, forKey: Keys.lastCurrencyDataUpdate) }
    }
    
    static var lastCalculationDataUpdate: Date? {
        get { ud.object(forKey: Keys.lastCalculationDataUpdate) as? Date }
        set { ud.setValue(newValue, forKey: Keys.lastCalculationDataUpdate) }
    }
    
    static var lastManagerDataUpdate: Date? {
        get { ud.object(forKey: Keys.lastManagerDataUpdate) as? Date }
        set { ud.setValue(newValue, forKey: Keys.lastManagerDataUpdate) }
    }
    
    static var lastDocumentsDataUpdate: Date? {
        get { ud.object(forKey: Keys.lastDocumentsDataUpdate) as? Date }
        set { ud.setValue(newValue, forKey: Keys.lastDocumentsDataUpdate) }
    }
}

