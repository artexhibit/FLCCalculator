import UIKit

struct ProfileSettingsVCHelper {
    static func performExitFromAccount(in vc: UIViewController) {
        KeychainManager.shared.delete(type: FLCUserCredentials.self)
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
    
    static func isAllDataValid(_ textFieldsValidity: [UITextField: Bool]) -> Bool {
        var shouldShowErrorPopup = false
        
        textFieldsValidity.forEach { textField, validity in
            validity ? (textField as? FLCNumberTextField)?.switchToOrangeColors() : (textField as? FLCNumberTextField)?.switchToRedColors()
            if !validity { shouldShowErrorPopup = true }
        }
        if shouldShowErrorPopup {
            FLCPopupView.showOnMainThread(title: "Информация заполнена некорректно. Пожалуйста, исправьте", style: .error)
            return false
        }
        return true
    }
    
    static func createNewUserData(user: FLCUser?, with textFields: [UITextField]) -> FLCUser? {
        guard var updatedUser = user else { return nil }
        
        textFields.forEach { textField in
            guard let textFieldName = (textField as? FLCNumberTextField)?.getSmallLabel().text else { return }
            
            switch textFieldName {
            case ProfileSettingsTextFieldsNames.name: updatedUser.fio = textField.text
            case ProfileSettingsTextFieldsNames.dateOfBirth: updatedUser.birthDate = textField.text
            case ProfileSettingsTextFieldsNames.phoneNumber: updatedUser.mobilePhone = textField.text ?? ""
            case ProfileSettingsTextFieldsNames.email: updatedUser.email = textField.text ?? ""
            case ProfileSettingsTextFieldsNames.companyName: updatedUser.companyName = textField.text
            case ProfileSettingsTextFieldsNames.companyTaxPayerID: updatedUser.inn = Int(textField.text ?? "0")
            case ProfileSettingsTextFieldsNames.customsDeclarationsAmountPerYear: updatedUser.dtCount = Int(textField.text ?? "0")
            default: break
            }
        }
        return updatedUser
    }
}
