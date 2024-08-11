import UIKit

struct AuthorizationVCHelper {
    static func presentAuthorizationVC(animated: Bool = false) {
        DispatchQueue.main.async {
            guard let userCredentials = KeychainManager.shared.read(type: FLCUserCredentials.self), userCredentials.isTokenValid else {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first, let rootController = window.rootViewController else { return }
                
                if let flcTabBar = rootController as? FLCTabBarController { flcTabBar.selectedIndex = 0 }
                
                let authorizationVC = AuthorizationVC()
                authorizationVC.modalPresentationStyle = .fullScreen
                rootController.present(authorizationVC, animated: animated)
                return
            }
        }
    }
    
    static func handleVerificationCodeButtonTap(loginConfirmationVC: FLCLoginConfirmationVC, pickedCountry: FLCCountryPhonesData?, phoneTextField: UITextField, enterUserCredentialsView: UIView, leadingConstraint: NSLayoutConstraint, vc: UIViewController) {
        let phoneNumber = ((pickedCountry?.phoneCode ?? "") + (phoneTextField.text ?? "")).extractDigits()
        let reviewPhoneNumber = Bundle.main.infoDictionary?[SecretsStrings.appStoreReviewPhone] as? String ?? ""
        let verificationCode = phoneNumber == reviewPhoneNumber ? Bundle.main.infoDictionary?[SecretsStrings.appStoreReviewCode] as? String ?? "" : AuthorizationManager.shared.createVerificationCode()
        
        Task {
            do {
                guard NetworkStatusManager.shared.isDeviceOnline else {
                    await FLCPopupView.showOnMainThread(title: FLCPopupMessages.needInternetConnection, style: .error)
                    return
                }
                await FLCPopupView.showOnMainThread(title: FLCPopupMessages.sendingSMS, style: .spinner)
                
                guard try await checkPhoneNumberExistense(phoneNumber: phoneNumber, vc: vc) else {
                    await FLCPopupView.removeFromMainThread()
                    return
                }
                if SMSManager.canSendSMS() {
                    try await sendVerificationCode(verificationCode: verificationCode, loginConfirmationVC: loginConfirmationVC, phoneTextField: phoneTextField, pickedCountry: pickedCountry, enterPhoneView: enterUserCredentialsView, leadingConstraint: leadingConstraint, vc: vc)
                    
                    await FLCPopupView.removeFromMainThread()
                    await FLCPopupView.showOnMainThread(systemImage: FLCIcon.checkmark.icon, title: FLCPopupMessages.sentSMS)
                } else {
                    let timeUntilCanSendSMS = SMSManager.timeUntilNextSMS()
                    await FLCPopupView.showOnMainThread(title: "\(FLCPopupMessages.zeroAttempts) \(timeUntilCanSendSMS)", style: .error)
                }
            } catch {
                await FLCPopupView.removeFromMainThread()
                await FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantSendSMS, style: .error)
            }
        }
    }
    
    static func sendVerificationCode(verificationCode: String, loginConfirmationVC: FLCLoginConfirmationVC, phoneTextField: UITextField, pickedCountry: FLCCountryPhonesData?, enterPhoneView: UIView, leadingConstraint: NSLayoutConstraint, vc: UIViewController) async throws {
  
        do {
            try await NetworkManager.shared.sendSMS(code: verificationCode, phoneNumber: phoneTextField.text?.extractDigits() ?? "")
            SMSManager.increaseSMSCounter()
            
            updateUIAfterSuccessfulSMS(verificationCode: verificationCode, loginConfirmationVC: loginConfirmationVC, phoneTextField: phoneTextField, pickedCountry: pickedCountry, enterPhoneView: enterPhoneView, leadingConstraint: leadingConstraint, vc: vc)
        } catch {
            await FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantSendSMS, style: .error)
        }
    }
    
    static func updateUIAfterSuccessfulSMS(verificationCode: String, loginConfirmationVC: FLCLoginConfirmationVC, phoneTextField: UITextField, pickedCountry: FLCCountryPhonesData?, enterPhoneView: UIView, leadingConstraint: NSLayoutConstraint, vc: UIViewController) {
        DispatchQueue.main.async {
            let displayingPhoneNumber = ((pickedCountry?.phoneCode ?? "") + " " + TextFieldManager.formatPhoneNumber(with: pickedCountry?.phoneMask ?? "", phone: (phoneTextField.text?.extractDigits() ?? "")))
            loginConfirmationVC.setLoginConfirmationView(phoneNumber: displayingPhoneNumber, verificationCode: verificationCode)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                FLCUIHelper.move(view: enterPhoneView, constraint: leadingConstraint, vc: vc, direction: .forward)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { loginConfirmationVC.makeFirstTextFieldActive() }
        }
    }
    
    private static func checkPhoneNumberExistense(phoneNumber: String, vc: UIViewController) async throws -> Bool {
        let isPhoneNumberExists = try await AuthorizationManager.shared.isPhoneNumberExist(phoneNumber)
        
        if let loginVC = vc as? LoginVC {
            guard isPhoneNumberExists else {
                await loginVC.delegate?.didFoundPhoneNumberDoesntExists(number: phoneNumber)
                await loginVC.dismiss(animated: true)
                return false
            }
        } else if let registrationVC = vc as? RegistrationVC {
            guard !isPhoneNumberExists else {
                await registrationVC.delegate?.didFoundPhoneNumberExists(number: phoneNumber)
                await registrationVC.dismiss(animated: true)
                return false
            }
        }
        return true
    }
    
    static func handleSuccessLogin(with number: String, in vc: UIViewController, country: FLCUserCountry) {
        guard NetworkStatusManager.shared.isDeviceOnline else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantLoginNoInternet, style: .error)
            return
        }
        FLCPopupView.showOnMainThread(title: FLCPopupMessages.loginInProcess, style: .spinner)
        
        Task {
            do {
                let loginCredentials = try await AuthorizationManager.shared.loginWithPhoneNumber(number)
                KeychainManager.shared.save(loginCredentials)
                let userInfo = try await AuthorizationManager.shared.getUserInfo(token: loginCredentials.credentials.response.token, userId: loginCredentials.credentials.response.userId, country: country)
                UserDefaultsPercistenceManager.updateItemInUserDefaults(item: userInfo)
                await FLCPopupView.removeFromMainThread()
                await vc.dismiss(animated: true)
            } catch {
                await FLCPopupView.removeFromMainThread()
                await FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantLoginTryAgain)
            }
        }
    }
    
    static func handleSuccessRegistration(with number: String, email: String, country: FLCUserCountry, in vc: UIViewController) {
        guard NetworkStatusManager.shared.isDeviceOnline else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantCompleteRegistrationNoInternet, style: .error)
            return
        }
        FLCPopupView.showOnMainThread(title: FLCPopupMessages.completingRegistration, style: .spinner)
        
        Task {
            do {
                let registrationCredentials = try await AuthorizationManager.shared.registerUserWith(number: number, email: email)
                KeychainManager.shared.save(registrationCredentials)
                let newUser = FLCUser(fio: "\(AuthorizationStrings.user)\(AuthorizationManager.shared.createVerificationCode(digits: 5))", email: email, mobilePhone: number, userCountry: country)
                UserDefaultsPercistenceManager.updateItemInUserDefaults(item: newUser)
                try await AuthorizationManager.shared.saveAccountDataToBubbleDatabase(for: newUser, token: registrationCredentials.credentials.response.token, userId: registrationCredentials.credentials.response.userId)
                await FLCPopupView.removeFromMainThread()
                await vc.dismiss(animated: true)
            } catch {
                await FLCPopupView.removeFromMainThread()
                await FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantRegisterTryAgain)
            }
        }
    }
    
    static func handleNumberNotExist(in vc: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { vc.presentNewVC(ofType: RegistrationVC.self) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantFindTheNumber)
        }
    }
    
    static func handleNumberAlreadyExist(in vc: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { vc.presentNewVC(ofType: LoginVC.self) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.numberAlreadyRegistered)
        }
    }
    
    static func moveFLCLogoImageViewUp(yContraint: NSLayoutConstraint, vc: UIViewController, container: UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            yContraint.constant = -150
            UIView.animate(withDuration: 0.5, animations: { vc.view.layoutIfNeeded() }) { _ in
                container.show(withAnimationDuration: 0.3)
            }
        }
    }
}
