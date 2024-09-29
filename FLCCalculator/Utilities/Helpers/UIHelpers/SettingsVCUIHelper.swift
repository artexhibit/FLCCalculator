import UIKit

struct SettingsVCUIHelper {
    static func configureDataSource() -> [SettingsSection] {
        let user = getUserData()
        let countryData = CalculationInfo.countryPhonesData.first(where: { $0.country == user?.userCountry })
        let phoneCode = countryData?.phoneCode ?? ""
        let phoneNumber = user?.mobilePhone.removeStringPart(phoneCode.removeFirstCharacters(1)) ?? ""
        let pickedThemeOption = FLCAppTheme(rawValue: UserDefaultsManager.appTheme)?.localizedDescription ?? FLCThemeOptionsStrings.onDevice
        let userMobilePhone = phoneCode + " " + TextFieldManager.formatPhoneNumber(with: countryData?.phoneMask ?? "", phone: phoneNumber)
        
        let firstSectionItems = [
            SettingsCellContent(cellType: .profile, contentType: .profile, title: user?.fio ?? "", subtitle: userMobilePhone)
        ]
        let secondSectionItems = [
            SettingsCellContent(cellType: .switcher, contentType: .haptic, image: FLCIcon.hapticPhone.icon, title: SettingsVCStrings.haptic, switchState: UserDefaultsManager.isHapticTurnedOn),
            SettingsCellContent(cellType: .menu, contentType: .theme, image: FLCIcon.circleHalfRight.icon, title: SettingsVCStrings.theme, pickedOption: pickedThemeOption),
            SettingsCellContent(cellType: .label, contentType: .language, image: FLCIcon.globe.icon, title: SettingsVCStrings.language),
            SettingsCellContent(cellType: .label, contentType: .permissions, image: FLCIcon.key.icon, title: SettingsVCStrings.permissions)
        ]
        let thirdSectionItems = [
            SettingsCellContent(cellType: .label, contentType: .iCloud, image: FLCIcon.iCloudFill.icon, title: SettingsVCStrings.iCloud)
        ]
        let fourthSectionItems = [
            SettingsCellContent(cellType: .label, contentType: .shareApp, image: FLCIcon.shareIcon.icon, title: SettingsVCStrings.shareApp),
            SettingsCellContent(cellType: .label, contentType: .rateApp, image: FLCIcon.star.icon, title: SettingsVCStrings.rateApp)
        ]
        let fifthSectionItems = [
            SettingsCellContent(cellType: .label, contentType: .support, image: FLCIcon.message.icon, title: SettingsVCStrings.support)
        ]
        
        return [
            SettingsSection(items: firstSectionItems),
            SettingsSection(title: SettingsVCStrings.commonSection, items: secondSectionItems),
            SettingsSection(title: SettingsVCStrings.dataSection, items: thirdSectionItems),
            SettingsSection(title: SettingsVCStrings.aboutAppSection, items: fourthSectionItems),
            SettingsSection(sectionFooter: SettingsVCStrings.findErrorFooter, items: fifthSectionItems)
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
            let themeOptions = FLCAppTheme.allCases
            
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
    
    static func updateAppTheme(in tableView: UITableView, sections: [SettingsSection], with contentType: FLCSettingsContentType) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let firstWindow = windowScene.windows.first else { return }
        guard let appTheme = FLCAppTheme(rawValue: UserDefaultsManager.appTheme)?.userInterfaceStyle else { return }
        UIView.transition(with: firstWindow, duration: 0.3, options: .transitionCrossDissolve, animations: {
            firstWindow.overrideUserInterfaceStyle = appTheme
        })
        tableView.reloadRows(at: [SettingsVCUIHelper.getIndexPath(for: contentType, in: sections)], with: .none)
    }
    
    static func presentShareAppSheet(in vc: UIViewController, sourceView: UITableView, at indexPath: IndexPath) {
        guard let appStoreAppPageURL = URL(string: Links.appStoreAppPageURL) else { return }
        
        let shareSheetVC = UIActivityViewController(activityItems: [appStoreAppPageURL], applicationActivities: nil)
        shareSheetVC.popoverPresentationController?.sourceView = sourceView
        shareSheetVC.popoverPresentationController?.sourceRect = sourceView.rectForRow(at: indexPath)
        
        vc.present(shareSheetVC, animated: true)
    }
    
    static func goToAppStoreReviewPage() {
        guard let appStoreReviewURL = URL(string: Links.appStoreReviewURL) else { return }
        
        if UIApplication.shared.canOpenURL(appStoreReviewURL) {
            UIApplication.shared.open(appStoreReviewURL, options: [:], completionHandler: nil)
        } else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantOpenAppStore, style: .error)
        }
    }
}
