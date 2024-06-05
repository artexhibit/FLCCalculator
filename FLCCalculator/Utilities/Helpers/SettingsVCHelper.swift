import UIKit

struct SettingsVCHelper {
    static func configureDataSource() -> [SettingsSection] {
        let user = getUserData()
        let pickedThemeOption = UserDefaultsManager.appTheme
        
        let firstSectionItems = [
            SettingsCellContent(cellType: .profile, contentType: .profile, image: nil, title: user?.name ?? "", subtitle: user?.mobilePhone ?? "", pickedOption: nil)
        ]
        let secondSectionItems = [
            SettingsCellContent(cellType: .switcher, contentType: .haptic, image: Icons.hapticPhone, title: "Виброотклик интерфейса", subtitle: nil, pickedOption: nil),
            SettingsCellContent(cellType: .menu, contentType: .theme, image: Icons.circleHalfRight, title: "Тема", subtitle: nil, pickedOption: pickedThemeOption)
        ]
        
        return [
            SettingsSection(title: "", items: firstSectionItems),
            SettingsSection(title: "Общее", items: secondSectionItems)
        ]
    }
    
    private static func getUserData() -> FLCUser? {
        let user: FLCUser? = UserDefaultsPercistenceManager.retrieveItemFromUserDefaults()
        return user
    }
    
    static func configureUIMenu(for contentType: FLCSettingsContentType) -> UIMenu {
        var menuChildren = [UIMenuElement]()
        
        if contentType == .theme {
            let themeOptions = FLCThemeOptions.allCases
            
            themeOptions.forEach { option in
                let state: UIMenuElement.State = option.rawValue == UserDefaultsManager.appTheme ? .on : .off
                let action = UIAction(title: option.rawValue, state: state) { _ in
                    UserDefaultsManager.appTheme = option.rawValue
                }
                menuChildren.append(action)
            }
        }
        return UIMenu(children: menuChildren)
    }
}
