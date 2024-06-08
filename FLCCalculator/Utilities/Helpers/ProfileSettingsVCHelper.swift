import UIKit

struct ProfileSettingsVCHelper {
    static func performExitFromAccount(in vc: UIViewController) {
        UserDefaultsManager.isUserLoggedIn = false
        vc.dismiss(animated: true) { AuthorizationVCHelper.presentAuthorizationVC(animated: true) }
    }
    
    static func configureTextIn(_ textFields: [UITextField]) {
        textFields.compactMap { $0 as? FLCNumberTextField }.filter { !($0.text?.isEmpty ?? false) }.forEach { $0.moveUpSmallLabel() }
    }
    
    static func handleKeyboard(in vc: ProfileSettingsVC) {
        NotificationsManager.notifyWhenKeyboardWillHide(vc, selector: #selector(vc.keyboardWillHide(notification:)))
        NotificationsManager.notifyWhenKeyboardWillShow(vc, selector: #selector(vc.keyboardWillShow(notification:)))
    }
    
    static func keyboardWillShow(notification: Notification, scrollView: UIScrollView) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    static func keyboardWillHide(notification: Notification, scrollView: UIScrollView) { scrollView.contentInset = UIEdgeInsets.zero }
}
