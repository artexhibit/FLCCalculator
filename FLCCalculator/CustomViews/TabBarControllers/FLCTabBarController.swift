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
        calculationsVC.tabBarItem = UITabBarItem(title: CalculationsVCStrings.calculations, image: UIImage(systemName: "list.bullet.rectangle.portrait.fill"), tag: 0)
        
        return UINavigationController(rootViewController: calculationsVC)
    }
    
    func createUsefulInfoVC() -> UINavigationController {
        let usefulInfoVC = UsefulInfoVC()
        usefulInfoVC.title = UsefulInfoVCStrings.useful
        usefulInfoVC.tabBarItem = UITabBarItem(title: UsefulInfoVCStrings.useful, image: UIImage(systemName: "doc.text.fill"), tag: 1)
        
        return UINavigationController(rootViewController: usefulInfoVC)
    }
    
    func createSettingsVC() -> UINavigationController {
        let settingsVC = SettingsVC()
        settingsVC.title = SettingsVCStrings.settings
        settingsVC.tabBarItem = UITabBarItem(title: SettingsVCStrings.settings, image: UIImage(systemName: "gear"), tag: 2)
        
        return UINavigationController(rootViewController: settingsVC)
    }
}
