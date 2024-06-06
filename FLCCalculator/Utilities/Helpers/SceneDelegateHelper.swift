import UIKit

struct SceneDelegateHelper {
    static func configureNavBar() { UINavigationBar.appearance().tintColor = UIColor(resource: .flcOrange) }
    
    static func configureAppTheme(in window: UIWindow?) {
        guard let appTheme = FLCThemeOptions(rawValue: UserDefaultsManager.appTheme)?.userInterfaceStyle else { return }
        window?.overrideUserInterfaceStyle = appTheme
    }
    
    static func configureUIWindow(in scene: UIScene) -> UIWindow? {
        guard let windowScene = (scene as? UIWindowScene) else { return nil }
        let tabBarController = FLCTabBarController()
        
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        return window
    }
}
