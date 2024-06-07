import UIKit

struct ProfileSettingsVCHelper {
    static func performExitFromAccount(in vc: UIViewController) {
        UserDefaultsManager.isUserLoggedIn = false
        vc.dismiss(animated: true) { AuthorizationVCHelper.presentAuthorizationVC(animated: true) }
    }
}
