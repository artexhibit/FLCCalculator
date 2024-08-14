import UIKit

struct ProfileSettingsVCHelper {
    static func performExitFromAccount(in vc: UIViewController) {
        KeychainManager.shared.delete(type: FLCUserCredentials.self)
        UserDefaultsPercistenceManager.deleteItemFromUserDefaults(itemType: FLCUser.self)
        vc.dismiss(animated: true) { AuthorizationVCHelper.presentAuthorizationVC(animated: true) }
    }
    
    static func performAccountDeletion(ofUser user: FLCUser?, in vc: UIViewController) {
        guard NetworkStatusManager.shared.isDeviceOnline else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.needInternetConnection, style: .error)
            return
        }
        
        FLCPopupView.showOnMainThread(title: FLCPopupMessages.oneMinute, style: .spinner)
        
        Task {
            do {
                let _ = try await AuthorizationManager.shared.accountDeletionRequest(user?.mobilePhone ?? "")
                KeychainManager.shared.delete(type: FLCUserCredentials.self)
                UserDefaultsPercistenceManager.deleteItemFromUserDefaults(itemType: FLCUser.self)
                await vc.dismiss(animated: true) { AuthorizationVCHelper.presentAuthorizationVC(animated: true) }
                await FLCPopupView.removeFromMainThread()
                await FLCPopupView.showOnMainThread(systemImage: FLCIcon.checkmark.icon, title: FLCPopupMessages.deleteAccountRequest)
            } catch {
                await FLCPopupView.removeFromMainThread()
                await FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantDeleteAccount, style: .error)
            }
        }
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
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.infoFilledWrong, style: .error)
            return false
        }
        return true
    }
    
    static func createNewUserData(user: FLCUser?, with textFields: [UITextField], countryCodePickerButton: FLCListPickerButton) -> FLCUser {
        guard var updatedUser = user else { return FLCUser(email: user?.email ?? "", mobilePhone: user?.mobilePhone ?? "", userCountry: user?.userCountry ?? .russia) }
        
        textFields.forEach { textField in
            guard let textFieldName = (textField as? FLCNumberTextField)?.getSmallLabel().text else { return }
            
            switch textFieldName {
            case ProfileSettingsStrings.fio: updatedUser.fio = textField.text
            case ProfileSettingsStrings.dateOfBirth: updatedUser.birthDate = textField.text
            case ProfileSettingsStrings.phoneNumber: updatedUser.mobilePhone = (countryCodePickerButton.showingTitle + (textField.text ?? "")).extractDigits()
            case ProfileSettingsStrings.email: updatedUser.email = textField.text ?? ""
            case ProfileSettingsStrings.companyName: updatedUser.companyName = textField.text
            case ProfileSettingsStrings.inn: updatedUser.inn = Int(textField.text ?? "")
            case ProfileSettingsStrings.dtCount: updatedUser.dtCount = Int(textField.text ?? "")
            default: break
            }
        }
        return updatedUser
    }

    @MainActor
    static func saveNewUserData(user: FLCUser?, textFields: [UITextField], countryCodePickerButton: FLCListPickerButton, vc: ProfileSettingsVC) async {
        FLCPopupView.showOnMainThread(title: FLCPopupMessages.saving, style: .spinner)
        
        do {
            var updatedUser = createNewUserData(user: user, with: textFields, countryCodePickerButton: countryCodePickerButton)
            guard let userCredentials = KeychainManager.shared.read(type: FLCUserCredentials.self) else { throw FLCError.invalidData }
            updatedUser.setBirthDateToISO8601(from: updatedUser.birthDate ?? "")
            
            try await AuthorizationManager.shared.saveAccountDataToBubbleDatabase(for: updatedUser, token: userCredentials.credentials.response.token, userId: userCredentials.credentials.response.userId)
            
            updatedUser.setBirthDateFromISO8601(from: updatedUser.birthDate ?? "")
            UserDefaultsPercistenceManager.updateItemInUserDefaults(item: updatedUser)
            
            FLCPopupView.removeFromMainThread()
            FLCPopupView.showOnMainThread(systemImage: FLCIcon.checkmark.icon, title: FLCPopupMessages.dataSaved)
            vc.delegate?.didUpdateUserInfo()
            vc.dismiss(animated: true)
        } catch {
            FLCPopupView.removeFromMainThread()
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantSave, style: .error)
        }
    }
    
    private static func handlePhoneNumberChange(phoneNumber: String, vc: ProfileSettingsVC) async {
        let verificationCode = AuthorizationManager.shared.createVerificationCode()
        
        do {
            try await NetworkManager.shared.sendSMS(code: verificationCode, phoneNumber: phoneNumber)
            await showLoginConfirmationVC(code: verificationCode, phoneNumber: phoneNumber, vc: vc)
        } catch {
            await FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantSendSMS, style: .error)
        }
    }
    
    private static func showLoginConfirmationVC(code: String, phoneNumber: String, vc: ProfileSettingsVC) async {
        let loginConfirmationVC = await FLCLoginConfirmationVC(myltiplyTopPaddingBy: 3)
        
        await MainActor.run { loginConfirmationVC.delegate = vc as FLCLoginConfirmationVCDelegate }
        await loginConfirmationVC.setLoginConfirmationView(phoneNumber: phoneNumber, verificationCode: code, isReturnButtonOn: false)
        let navController = await UINavigationController(rootViewController: loginConfirmationVC)
        await navController.sheetPresentationController?.getFLCSheetPresentationController(in: vc.view, otherDeviceHeight: 0.4)
        await vc.present(navController, animated: true)
    }
    
    static func validateAndSaveUserData(textFieldsValidity: [UITextField: Bool], textFields: [UITextField], countryCodePickerButton: FLCListPickerButton, phoneTextField: UITextField, oldPhoneNumber: String, vc: ProfileSettingsVC, user: FLCUser?) {
        if isAllDataValid(textFieldsValidity) {
            DispatchQueue.main.async {
                guard NetworkStatusManager.shared.isDeviceOnline else {
                    FLCPopupView.showOnMainThread(title: FLCPopupMessages.needInternetConnection, style: .error)
                    return
                }
                let countryData = CalculationInfo.countryPhonesData.first(where: { $0.phoneCode == countryCodePickerButton.showingTitle })
                let newPhoneNumber = ((countryCodePickerButton.showingTitle) + (phoneTextField.text ?? "")).extractDigits()
                let displayingPhoneNumber = ((countryCodePickerButton.showingTitle) + " " + TextFieldManager.formatPhoneNumber(with: countryData?.phoneMask ?? "", phone: (phoneTextField.text?.extractDigits() ?? "")))
        
                guard oldPhoneNumber == newPhoneNumber else {
                    Task { await handlePhoneNumberChange(phoneNumber: displayingPhoneNumber, vc: vc) }
                    return
                }
                Task { await saveNewUserData(user: user, textFields: textFields, countryCodePickerButton: countryCodePickerButton, vc: vc) }
            }
        }
    }
}
