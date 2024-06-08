import UIKit

struct AuthorizationVCHelper {
    static func presentAuthorizationVC(animated: Bool = false) {
        DispatchQueue.main.async {
            if !UserDefaultsManager.isUserLoggedIn {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first, let rootController = window.rootViewController else { return }
         
                if let flcTabBar = rootController as? FLCTabBarController { flcTabBar.selectedIndex = 0 }
                
                let authorizationVC = AuthorizationVC()
                authorizationVC.modalPresentationStyle = .fullScreen
                rootController.present(authorizationVC, animated: animated)
            }
        }
    }
    
    static func handleSuccessRegistration(with phone: String, and email: String) {
        UserDefaultsManager.isUserLoggedIn = true
        let newUser = FLCUser(name: "Гость\(LoginVCHelper.createVerificationCode(digits: 5))", email: email, mobilePhone: phone)
        _ = UserDefaultsPercistenceManager.updateItemInUserDefaults(item: newUser)
    }
    
    static func showAuthVC(in vc: UIViewController) {
        let loginVC = LoginVC()
        loginVC.delegate = vc as? LoginVCDelegate
        let navController = UINavigationController(rootViewController: loginVC)
        vc.present(navController, animated: true)
    }
    
    static func showRegistrationVC(in vc: UIViewController) {
        let registrationVC = RegistrationVC()
        registrationVC.delegate = vc as? RegistrationVCDelegate
        let navController = UINavigationController(rootViewController: registrationVC)
        vc.present(navController, animated: true)
    }
}
