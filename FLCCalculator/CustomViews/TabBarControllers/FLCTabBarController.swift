import UIKit

class FLCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(resource: .flcOrange)
        viewControllers = [createCalculationsVC(), createUsefulInfoVC(), createSettingsVC()]
    }
    
    func createCalculationsVC() -> UINavigationController {
        let calculationsVC = CalculationsVC()
        calculationsVC.title = CalculationsVCStrings.calculations
        calculationsVC.tabBarItem = UITabBarItem(title: CalculationsVCStrings.calculations, image: FLCIcon.listBullet.icon, tag: 0)
        
        return UINavigationController(rootViewController: calculationsVC)
    }
    
    func createUsefulInfoVC() -> UINavigationController {
        let usefulInfoVC = UsefulInfoVC()
        usefulInfoVC.title = UsefulInfoVCStrings.useful
        usefulInfoVC.tabBarItem = UITabBarItem(title: UsefulInfoVCStrings.useful, image: FLCIcon.docText.icon, tag: 1)
        
        return UINavigationController(rootViewController: usefulInfoVC)
    }
    
    func createSettingsVC() -> UINavigationController {
        let settingsVC = SettingsVC()
        settingsVC.title = SettingsVCStrings.settings
        settingsVC.tabBarItem = UITabBarItem(title: SettingsVCStrings.settings, image: FLCIcon.gear.icon, tag: 2)
        
        return UINavigationController(rootViewController: settingsVC)
    }
}
