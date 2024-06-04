import UIKit

class FLCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(resource: .flcOrange)
        viewControllers = [createCalculationsVC(), createUsefulInfoVC(), createSettingsVC()]
    }
    
    func createCalculationsVC() -> UINavigationController {
        let calculationsVC = CalculationsVC()
        calculationsVC.title = "Расчёты"
        calculationsVC.tabBarItem = UITabBarItem(title: "Расчёты", image: UIImage(systemName: "list.bullet.rectangle.portrait.fill"), tag: 0)
        
        return UINavigationController(rootViewController: calculationsVC)
    }
    
    func createUsefulInfoVC() -> UINavigationController {
        let usefulInfoVC = UsefulInfoVC()
        usefulInfoVC.title = "Полезное"
        usefulInfoVC.tabBarItem = UITabBarItem(title: "Полезное", image: UIImage(systemName: "doc.text.fill"), tag: 1)
        
        return UINavigationController(rootViewController: usefulInfoVC)
    }
    
    func createSettingsVC() -> UINavigationController {
        let settingsVC = SettingsVC()
        settingsVC.title = "Настройки"
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 2)
        
        return UINavigationController(rootViewController: settingsVC)
    }
}
