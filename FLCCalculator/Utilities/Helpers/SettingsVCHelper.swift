import UIKit

struct SettingsVCHelper {
    static func configureDataSource() -> [SettingsSection] {
        let user = getUserData()
        let countryData = CalculationInfo.countryPhonesData.first(where: { $0.country == user?.userCountry })
        let phoneCode = countryData?.phoneCode ?? ""
        let phoneNumber = user?.mobilePhone.removeStringPart(phoneCode.removeFirstCharacters(1)) ?? ""
        let pickedThemeOption = FLCThemeOptions(rawValue: UserDefaultsManager.appTheme)?.localizedDescription
        let userMobilePhone = phoneCode + " " + TextFieldManager.formatPhoneNumber(with: countryData?.phoneMask ?? "", phone: phoneNumber)
        
        let firstSectionItems = [
            SettingsCellContent(cellType: .profile, contentType: .profile, image: nil, title: user?.fio ?? "", subtitle: userMobilePhone, pickedOption: nil)
        ]
        let secondSectionItems = [
            SettingsCellContent(cellType: .switcher, contentType: .haptic, image: Icons.hapticPhone, title: SettingsStrings.haptic, subtitle: nil, pickedOption: nil),
            SettingsCellContent(cellType: .menu, contentType: .theme, image: Icons.circleHalfRight, title: SettingsStrings.theme, subtitle: nil, pickedOption: pickedThemeOption),
            SettingsCellContent(cellType: .label, contentType: .permissions, image: Icons.key, title: SettingsStrings.permissions, subtitle: nil, pickedOption: nil)
        ]
        let thirdSectionItems = [
            SettingsCellContent(cellType: .label, contentType: .shareApp, image: Icons.shareIcon, title: SettingsStrings.shareApp, subtitle: nil, pickedOption: nil),
            SettingsCellContent(cellType: .label, contentType: .rateApp, image: Icons.star, title: SettingsStrings.rateApp, subtitle: nil, pickedOption: nil)
        ]
        let fourthSectionItems = [
            SettingsCellContent(cellType: .label, contentType: .support, image: Icons.message, title: SettingsStrings.support, subtitle: nil, pickedOption: nil)
        ]
        
        return [
            SettingsSection(title: "", sectionFooter: "", items: firstSectionItems),
            SettingsSection(title: SettingsStrings.commonSection, sectionFooter: "", items: secondSectionItems),
            SettingsSection(title: SettingsStrings.aboutAppSection, sectionFooter: "", items: thirdSectionItems),
            SettingsSection(title: "", sectionFooter: SettingsStrings.findErrorFooter, items: fourthSectionItems)
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
                let action = UIAction(title: option.localizedDescription, state: state) { _ in
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
    
    static func presentShareAppSheet(in vc: UIViewController, sourceView: UITableView, at indexPath: IndexPath) {
        guard let appStoreAppPageURL = URL(string: "https://apps.apple.com/app/flc-calculator-%D0%B8%D0%BC%D0%BF%D0%BE%D1%80%D1%82-%D0%B2-%D1%80%D1%84/id6547868937") else { return }
        
        let shareSheetVC = UIActivityViewController(activityItems: [appStoreAppPageURL], applicationActivities: nil)
        shareSheetVC.popoverPresentationController?.sourceView = sourceView
        shareSheetVC.popoverPresentationController?.sourceRect = sourceView.rectForRow(at: indexPath)
        
        vc.present(shareSheetVC, animated: true)
    }
    
    static func goToAppStoreReviewPage() {
        guard let appStoreReviewURL = URL(string: "https://apps.apple.com/app/id6547868937?action=write-review") else { return }
        
        if UIApplication.shared.canOpenURL(appStoreReviewURL) {
            UIApplication.shared.open(appStoreReviewURL, options: [:], completionHandler: nil)
        } else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantOpenAppStore, style: .error)
        }
    }
}
