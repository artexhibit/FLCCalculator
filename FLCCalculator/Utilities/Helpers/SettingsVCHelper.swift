import UIKit

struct SettingsVCHelper {
    static func configureDataSource() -> [SettingsSection] {
        let user = getUserData()
        let pickedThemeOption = UserDefaultsManager.appTheme
        let userMobilePhone = TextFieldManager.formatPhoneNumber(phone: user?.mobilePhone ?? "")
        
        let firstSectionItems = [
            SettingsCellContent(cellType: .profile, contentType: .profile, image: nil, title: user?.fio ?? "", subtitle: userMobilePhone, pickedOption: nil)
        ]
        let secondSectionItems = [
            SettingsCellContent(cellType: .switcher, contentType: .haptic, image: Icons.hapticPhone, title: "Тактильный отклик элементов интерфейса", subtitle: nil, pickedOption: nil),
            SettingsCellContent(cellType: .menu, contentType: .theme, image: Icons.circleHalfRight, title: "Тема", subtitle: nil, pickedOption: pickedThemeOption),
            SettingsCellContent(cellType: .label, contentType: .permissions, image: Icons.key, title: "Разрешения", subtitle: nil, pickedOption: nil)
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
    
    static func getIndexPath(for contentType: FLCSettingsContentType, in sections: [SettingsSection]) -> IndexPath {
        for (sectionIndex, section) in sections.enumerated() {
            for (rowIndex, item) in section.items.enumerated() {
                if item.contentType == contentType {
                    return IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
        }
        return IndexPath()
    }
    
    static func configureUIMenu(for contentType: FLCSettingsContentType, updateHandler: @escaping () -> Void) -> UIMenu {
        var menuChildren = [UIMenuElement]()
        
        if contentType == .theme {
            let themeOptions = FLCThemeOptions.allCases
            
            themeOptions.forEach { option in
                let state: UIMenuElement.State = option.rawValue == UserDefaultsManager.appTheme ? .on : .off
                let action = UIAction(title: option.rawValue, state: state) { _ in
                    UserDefaultsManager.appTheme = option.rawValue
                    updateHandler()
                }
                menuChildren.append(action)
            }
        }
        return UIMenu(children: menuChildren)
    }
    
    static func configureSwitchState(for contentType: FLCSettingsContentType) -> Bool {
        if contentType == .haptic { return UserDefaultsManager.isHapticTurnedOn }
        return true
    }
    
    static func updateAppTheme(in tableView: UITableView, sections: [SettingsSection], with contentType: FLCSettingsContentType) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let firstWindow = windowScene.windows.first else { return }
        guard let appTheme = FLCThemeOptions(rawValue: UserDefaultsManager.appTheme)?.userInterfaceStyle else { return }
        UIView.transition(with: firstWindow, duration: 0.3, options: .transitionCrossDissolve, animations: {
            firstWindow.overrideUserInterfaceStyle = appTheme
        })
        tableView.reloadRows(at: [SettingsVCHelper.getIndexPath(for: contentType, in: sections)], with: .none)
    }
}
