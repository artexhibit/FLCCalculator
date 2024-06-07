import UIKit

struct LoginVCHelper {
    static func createVerificationCode(digits: Int = 4) -> String {
        var number = ""
        for _ in 1...digits { number += "\(Int.random(in: 1...9))" }
        return number
    }
    
    static func handleVerificationCodeButtonTap(loginConfirmationView: LoginConfirmationView, phoneTextField: UITextField, enterUserCredentialsView: UIView, leadingConstraint: NSLayoutConstraint, vc: UIViewController) {
        Task {
            do {
                if SMSManager.canSendSMS() {
                    try await sendVerificationCode(verificationCode: createVerificationCode(), loginConfirmationView: loginConfirmationView, phoneTextField: phoneTextField, enterPhoneView: enterUserCredentialsView, leadingConstraint: leadingConstraint, vc: vc)
                } else {
                    let timeUntilNextSMS = SMSManager.timeUntilNextSMS()
                    await FLCPopupView.showOnMainThread(title: "Вы использовали все попытки. Повторить можно через \(timeUntilNextSMS)", style: .error)
                }
            } catch {
                await FLCPopupView.showOnMainThread(title: "Не удалось отправить СМС", style: .error)
            }
        }
    }
    
    static func sendVerificationCode(verificationCode: String, loginConfirmationView: LoginConfirmationView, phoneTextField: UITextField, enterPhoneView: UIView, leadingConstraint: NSLayoutConstraint, vc: UIViewController) async throws {
        if try await NetworkManager.shared.sendSMS(code: verificationCode, phoneNumber: phoneTextField.text?.extractDigits() ?? "") {
            SMSManager.increaseSMSCounter()
            DispatchQueue.main.async {
                updateUIAfterSuccessfulSMS(verificationCode: verificationCode, loginConfirmationView: loginConfirmationView, phoneTextField: phoneTextField, enterPhoneView: enterPhoneView, leadingConstraint: leadingConstraint, vc: vc)
            }
        } else {
            await FLCPopupView.showOnMainThread(title: "Не удалось отправить СМС", style: .error)
        }
    }
    
    static func updateUIAfterSuccessfulSMS(verificationCode: String, loginConfirmationView: LoginConfirmationView, phoneTextField: UITextField, enterPhoneView: UIView, leadingConstraint: NSLayoutConstraint, vc: UIViewController) {
        loginConfirmationView.setLoginConfirmationView(text: phoneTextField.text ?? "", verificationCode: verificationCode)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            FLCUIHelper.move(view: enterPhoneView, constraint: leadingConstraint, vc: vc, direction: .forward)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { loginConfirmationView.makeFirstTextFieldActive() }
    }
}
