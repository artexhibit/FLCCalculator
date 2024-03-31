import Foundation

struct UserDefaultsManager {
    private static let ud = UserDefaults.sharedContainer
    
    static var dateWhenDataWasUpdated: String {
        get { ud.string(forKey: Keys.dateWhenDataWasUpdated) ?? "" }
        set { ud.setValue(newValue, forKey: Keys.dateWhenDataWasUpdated) }
    }
}

