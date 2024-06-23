import UIKit

struct ProfileSettingsVCHelper {
    static func performExitFromAccount(in vc: UIViewController) {
        KeychainManager.shared.delete(type: FLCUserCredentials.self)
        vc.dismiss(animated: true) { AuthorizationVCHelper.presentAuthorizationVC(animated: true) }
    }
    
    static func performAccountDeletion(in vc: UIViewController) {
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
    
    private static func isAllDataValid(_ textFieldsValidity: [UITextField: Bool]) -> Bool {
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
    
    static func createNewUserData(user: FLCUser?, with textFields: [UITextField]) -> FLCUser {
       guard var updatedUser = user else { return FLCUser(email: user?.email ?? "", mobilePhone: user?.mobilePhone ?? "") }
        
        textFields.forEach { textField in
            guard let textFieldName = (textField as? FLCNumberTextField)?.getSmallLabel().text else { return }
            
            switch textFieldName {
            case ProfileSettingsTextFieldsNames.fio: updatedUser.fio = textField.text
            case ProfileSettingsTextFieldsNames.dateOfBirth: updatedUser.birthDate = textField.text
            case ProfileSettingsTextFieldsNames.phoneNumber: updatedUser.mobilePhone = textField.text?.extractDigits() ?? ""
            case ProfileSettingsTextFieldsNames.email: updatedUser.email = textField.text ?? ""
            case ProfileSettingsTextFieldsNames.companyName: updatedUser.companyName = textField.text
            case ProfileSettingsTextFieldsNames.inn: updatedUser.inn = Int(textField.text ?? "")
            case ProfileSettingsTextFieldsNames.dtCount: updatedUser.dtCount = Int(textField.text ?? "")
            default: break
            }
        }
        return updatedUser
    }

    @MainActor
    static func saveNewUserData(user: FLCUser?, textFields: [UITextField], vc: ProfileSettingsVC) async {
        FLCPopupView.showOnMainThread(title: "Сохраняем", style: .spinner)
        
        do {
            var updatedUser = createNewUserData(user: user, with: textFields)
            guard let userCredentials = KeychainManager.shared.read(type: FLCUserCredentials.self) else { throw FLCError.invalidData }
            updatedUser.setBirthDateToISO8601(from: updatedUser.birthDate ?? "")
            
            try await AuthorizationManager.shared.saveAccountDataToBubbleDatabase(for: updatedUser, token: userCredentials.credentials.response.token, userId: userCredentials.credentials.response.userId)
            
            updatedUser.setBirthDateFromISO8601(from: updatedUser.birthDate ?? "")
            UserDefaultsPercistenceManager.updateItemInUserDefaults(item: updatedUser)
            
            FLCPopupView.removeFromMainThread()
            FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Данные сохранены")
            vc.delegate?.didUpdateUserInfo()
            vc.dismiss(animated: true)
        } catch {
            FLCPopupView.removeFromMainThread()
            FLCPopupView.showOnMainThread(title: "Не удалось сохранить. Попробуйте ещё раз", style: .error)
        }
    }
    
    private static func handlePhoneNumberChange(phoneNumber: String, vc: ProfileSettingsVC) async {
        let verificationCode = AuthorizationManager.shared.createVerificationCode()
        
        do {
            try await NetworkManager.shared.sendSMS(code: verificationCode, phoneNumber: phoneNumber)
            await showLoginConfirmationVC(code: verificationCode, phoneNumber: phoneNumber, vc: vc)
        } catch {
            await FLCPopupView.showOnMainThread(title: "Не удалось отправить СМС", style: .error)
        }
    }
    
    private static func showLoginConfirmationVC(code: String, phoneNumber: String, vc: ProfileSettingsVC) async {
        let loginConfirmationVC = await FLCLoginConfirmationVC(myltiplyTopPaddingBy: 3)
        
        await MainActor.run { loginConfirmationVC.delegate = vc as FLCLoginConfirmationVCDelegate }
        await loginConfirmationVC.setLoginConfirmationView(phoneNumber: phoneNumber, verificationCode: code, isReturnButtonOn: false)
        let navController = await UINavigationController(rootViewController: loginConfirmationVC)
        await navController.sheetPresentationController?.getFLCSheetPresentationController(in: vc.view, size: 0.4)
        await vc.present(navController, animated: true)
    }
    
    static func validateAndSaveUserData(textFieldsValidity: [UITextField: Bool], textFields: [UITextField], phoneTextField: UITextField, oldPhoneNumber: String, vc: ProfileSettingsVC, user: FLCUser?) {
        if isAllDataValid(textFieldsValidity) {
            DispatchQueue.main.async {
                guard NetworkStatusManager.shared.isDeviceOnline else {
                    FLCPopupView.showOnMainThread(title: "Необходимо активное подключение к интернету", style: .error)
                    return
                }
                let newPhoneNumber = phoneTextField.text?.extractDigits() ?? ""
                
                guard oldPhoneNumber == newPhoneNumber else {
                    Task { await handlePhoneNumberChange(phoneNumber: newPhoneNumber, vc: vc) }
                    return
                }
                Task { await saveNewUserData(user: user, textFields: textFields, vc: vc) }
            }
        }
    }
}
