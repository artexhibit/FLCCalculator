import Foundation

struct LanguageManager {
    static let shared = LanguageManager()
    
    var currentDeviceLanguage: FLCAppLanguage {
        guard let deviceCurrentLanguage = Locale.preferredLanguages.first else { return .en }
        return FLCAppLanguage(rawValue: deviceCurrentLanguage.getFirstCharacters(2)) ?? .en
    }
}
