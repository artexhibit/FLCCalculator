import UIKit

struct AuthorizationVCHelper {
    static func presentAuthorizationVC(animated: Bool = false) {
        DispatchQueue.main.async {
            let userCredentials = KeychainManager.shared.read(type: FLCUserCredentials.self)
            
            if !(userCredentials?.isTokenValid ?? false) {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first, let rootController = window.rootViewController else { return }
                
                if let flcTabBar = rootController as? FLCTabBarController { flcTabBar.selectedIndex = 0 }
                
                let authorizationVC = AuthorizationVC()
                authorizationVC.modalPresentationStyle = .fullScreen
                rootController.present(authorizationVC, animated: animated)
            }
        }
    }
    
    static func handleVerificationCodeButtonTap(loginConfirmationVC: FLCLoginConfirmationVC, phoneTextField: UITextField, enterUserCredentialsView: UIView, leadingConstraint: NSLayoutConstraint, vc: UIViewController) {
        let phoneNumber = phoneTextField.text?.extractDigits() ?? ""
        
        Task {
            do {
                guard NetworkStatusManager.shared.isDeviceOnline else {
                    await FLCPopupView.showOnMainThread(title: "Необходимо активное подключение к интернету", style: .error)
                    return
                }
                try await checkPhoneNumberExistense(phoneNumber: phoneNumber, vc: vc)
                
                if SMSManager.canSendSMS() {
                    await FLCPopupView.showOnMainThread(title: "Отправляем СМС", style: .spinner)
                    
                    try await sendVerificationCode(verificationCode: AuthorizationManager.shared.createVerificationCode(), loginConfirmationVC: loginConfirmationVC, phoneTextField: phoneTextField, enterPhoneView: enterUserCredentialsView, leadingConstraint: leadingConstraint, vc: vc)
                    
                    await FLCPopupView.removeFromMainThread()
                    await FLCPopupView.showOnMainThread(title: "СМС отправлено")
                } else {
                    let timeUntilCanSendSMS = SMSManager.timeUntilNextSMS()
                    await FLCPopupView.showOnMainThread(title: "Вы использовали все попытки. Повторить можно через \(timeUntilCanSendSMS)", style: .error)
                }
            } catch {
                await FLCPopupView.showOnMainThread(title: "Не удалось отправить СМС", style: .error)
            }
        }
    }
    
    static func sendVerificationCode(verificationCode: String, loginConfirmationVC: FLCLoginConfirmationVC, phoneTextField: UITextField, enterPhoneView: UIView, leadingConstraint: NSLayoutConstraint, vc: UIViewController) async throws {
  
        do {
            try await NetworkManager.shared.sendSMS(code: verificationCode, phoneNumber: phoneTextField.text?.extractDigits() ?? "")
            SMSManager.increaseSMSCounter()
            
            updateUIAfterSuccessfulSMS(verificationCode: verificationCode, loginConfirmationVC: loginConfirmationVC, phoneTextField: phoneTextField, enterPhoneView: enterPhoneView, leadingConstraint: leadingConstraint, vc: vc)
        } catch {
            await FLCPopupView.showOnMainThread(title: "Не удалось отправить СМС", style: .error)
        }
    }
    
    static func updateUIAfterSuccessfulSMS(verificationCode: String, loginConfirmationVC: FLCLoginConfirmationVC, phoneTextField: UITextField, enterPhoneView: UIView, leadingConstraint: NSLayoutConstraint, vc: UIViewController) {
        DispatchQueue.main.async {
            loginConfirmationVC.setLoginConfirmationView(phoneNumber: phoneTextField.text ?? "", verificationCode: verificationCode)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                FLCUIHelper.move(view: enterPhoneView, constraint: leadingConstraint, vc: vc, direction: .forward)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { loginConfirmationVC.makeFirstTextFieldActive() }
        }
    }
    
    private static func checkPhoneNumberExistense(phoneNumber: String, vc: UIViewController) async throws {
        let isPhoneNumberExists = try await AuthorizationManager.shared.isPhoneNumberExist(phoneNumber)
        
        if let loginVC = vc as? LoginVC {
            guard isPhoneNumberExists else {
                await loginVC.delegate?.didFoundPhoneNumberDoesntExists(number: phoneNumber)
                await loginVC.dismiss(animated: true)
                return
            }
        } else if let registrationVC = vc as? RegistrationVC {
            guard !isPhoneNumberExists else {
                await registrationVC.delegate?.didFoundPhoneNumberExists(number: phoneNumber)
                await registrationVC.dismiss(animated: true)
                return
            }
        }
    }
    
    static func handleSuccessLogin(with number: String, in vc: UIViewController) {
        guard NetworkStatusManager.shared.isDeviceOnline else {
            FLCPopupView.showOnMainThread(title: "Не удалось завершить вход, отсутствует подключение к интернету", style: .error)
            return
        }
        FLCPopupView.showOnMainThread(title: "Завершаем вход", style: .spinner)
        
        Task {
            do {
                let loginCredentials = try await AuthorizationManager.shared.loginWithPhoneNumber(number)
                KeychainManager.shared.save(loginCredentials)
                let userInfo = try await AuthorizationManager.shared.getUserInfo(token: loginCredentials.credentials.response.token, userId: loginCredentials.credentials.response.userId)
                UserDefaultsPercistenceManager.updateItemInUserDefaults(item: userInfo)
                await FLCPopupView.removeFromMainThread()
                await vc.dismiss(animated: true)
            } catch {
                await FLCPopupView.removeFromMainThread()
                await FLCPopupView.showOnMainThread(title: "Не удалось завершить вход. Попробуйте ещё раз")
            }
        }
    }
    
    static func handleSuccessRegistration(with number: String, email: String, in vc: UIViewController) {
        guard NetworkStatusManager.shared.isDeviceOnline else {
            FLCPopupView.showOnMainThread(title: "Не удалось завершить регистрацию, отсутствует подключение к интернету", style: .error)
            return
        }
        FLCPopupView.showOnMainThread(title: "Завершаем регистрацию", style: .spinner)
        
        Task {
            do {
                let registrationCredentials = try await AuthorizationManager.shared.registerUserWith(number: number, email: email)
                KeychainManager.shared.save(registrationCredentials)
                let newUser = FLCUser(fio: "Гость\(AuthorizationManager.shared.createVerificationCode(digits: 5))", email: email, mobilePhone: number)
                UserDefaultsPercistenceManager.updateItemInUserDefaults(item: newUser)
                try await AuthorizationManager.shared.saveAccountDataToBubbleDatabase(for: newUser, token: registrationCredentials.credentials.response.token, userId: registrationCredentials.credentials.response.userId)
                await FLCPopupView.removeFromMainThread()
                await vc.dismiss(animated: true)
            } catch {
                await FLCPopupView.removeFromMainThread()
                await FLCPopupView.showOnMainThread(title: "Не удалось завершить регистрацию. Попробуйте ещё раз")
            }
        }
    }
    
    static func handleNumberNotExist(in vc: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { vc.presentNewVC(ofType: RegistrationVC.self) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            FLCPopupView.showOnMainThread(title: "Мы не нашли у себя такого номера. Пожалуйста, зарегистрируйтесь")
        }
    }
    
    static func handleNumberAlreadyExist(in vc: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { vc.presentNewVC(ofType: LoginVC.self) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            FLCPopupView.showOnMainThread(title: "Такой номер уже зарегистрирован. Пожалуйста, войдите")
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
