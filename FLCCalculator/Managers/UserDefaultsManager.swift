import Foundation

struct UserDefaultsManager {
    private static let ud = UserDefaults.sharedContainer
    
    static var permissionsScreenWasShown: Bool {
        get { ud.object(forKey: Keys.permissionsScreenWasShown) == nil ? false : ud.bool(forKey: Keys.permissionsScreenWasShown) }
        set { ud.setValue(newValue, forKey: Keys.permissionsScreenWasShown) }
    }
    
    static var isHapticTurnedOn: Bool {
        get { ud.object(forKey: Keys.isHapticTurnedOn) == nil ? true : ud.bool(forKey: Keys.isHapticTurnedOn) }
        set { ud.setValue(newValue, forKey: Keys.isHapticTurnedOn) }
    }
    
    static var isFirstLaunch: Bool {
        get { ud.object(forKey: Keys.isFirstLaunch) == nil ? true : ud.bool(forKey: Keys.isFirstLaunch) }
        set { ud.setValue(newValue, forKey: Keys.isFirstLaunch) }
    }
    
    static var appTheme: String {
        get { ud.string(forKey: Keys.appTheme) ?? FLCThemeOptionsStrings.onDevice }
        set { ud.setValue(newValue, forKey: Keys.appTheme) }
    }
    
    static var onboardingPopovers: [String: Bool] {
        get { ud.dictionary(forKey: Keys.onboardingPopoversDict) as? [String: Bool] ?? [:] }
        set { ud.setValue(newValue, forKey: Keys.onboardingPopoversDict) }
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
    
    static var lastFacilitiesDataUpdate: Date? {
        get { ud.object(forKey: Keys.lastFacilitiesDataUpdate) as? Date }
        set { ud.setValue(newValue, forKey: Keys.lastFacilitiesDataUpdate) }
    }
    
    static var lastAvailableLogisticsTypesDataUpdate: Date? {
        get { ud.object(forKey: Keys.lastAvailableLogisticsTypesDataUpdate) as? Date }
        set { ud.setValue(newValue, forKey: Keys.lastAvailableLogisticsTypesDataUpdate) }
    }
}

