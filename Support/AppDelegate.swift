import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseManager.configureFirebase()
        updateCurrencyData()
        return true
    }
    
    private func updateCurrencyData() {
        Task {
            do {
                let currencyData = try await NetworkManager.shared.getCurrencyData()
                guard let _ = PersistenceManager.update(currencyData: currencyData) else {
                    FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось обновить курсы валют", style: .error)
                    return
                }
                FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Курсы валют обновлены", style: .normal)
            } catch {
                FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось получить курсы валют", style: .error)
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

