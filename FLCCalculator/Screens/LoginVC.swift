import UIKit

protocol LoginVCDelegate: AnyObject {
    func didSuccessWithLogin()
}

final class LoginVC: FLCLoginVC {
    
    private let enterPhoneTitleLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 19, weight: .medium)
    private let phoneTextField = FLCNumberTextField(smallLabelPlaceholderText: "Номер телефона", smallLabelFontSize: 20, keyboardType: .phonePad, fontSize: 27, fontWeight: .bold)
    private let verificationCodeButton = FLCButton(color: .flcOrange, title: "Получить код", isEnabled: false)
    private let privacyPolicyAgreenmentTextViewLabel = FLCTextViewLabel(text: "Нажимая на кнопку «Получить код», вы соглашаетесь с Правилами обработки персональных данных ООО «Фри Лайнс Компани»".makeAttributed(text: "Правилами обработки персональных данных", attributes: [.underlineStyle, .link], linkValue: "privacyPolicy"))
    
    weak var delegate: LoginVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureEnterPhoneTitleLabel()
        configurePhoneTextField()
        configureVerificationCodeButton()
        configurePrivacyPolicyAgreenmentTextViewLabel()
    }
    
    private func configureVC() {
        navigationItem.title = "Войти"
        loginConfirmationView.delegate = self
        loginConfirmationView.setReturnButtonDelegate(vc: self)
        enterUserCredentialsView.addSubviews(enterPhoneTitleLabel, phoneTextField, verificationCodeButton, privacyPolicyAgreenmentTextViewLabel)
    }
    
    private func configureEnterPhoneTitleLabel() {
        enterPhoneTitleLabel.text = "Чтобы войти, введите ваш номер телефона, а затем четырёхзначный код из смс"
        
        NSLayoutConstraint.activate([
            enterPhoneTitleLabel.topAnchor.constraint(equalTo: enterUserCredentialsView.topAnchor, constant: padding),
            enterPhoneTitleLabel.leadingAnchor.constraint(equalTo: enterUserCredentialsView.leadingAnchor, constant: padding),
            enterPhoneTitleLabel.trailingAnchor.constraint(equalTo: enterUserCredentialsView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configurePhoneTextField()  {
        phoneTextField.delegate = self
        
        NSLayoutConstraint.activate([
            phoneTextField.topAnchor.constraint(equalTo: enterPhoneTitleLabel.bottomAnchor, constant: padding * 2),
            phoneTextField.leadingAnchor.constraint(equalTo: enterUserCredentialsView.leadingAnchor, constant: padding),
            phoneTextField.trailingAnchor.constraint(equalTo: enterUserCredentialsView.trailingAnchor, constant: -padding),
            phoneTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureVerificationCodeButton() {
        verificationCodeButton.delegate = self
        
        let heightAnchor: CGFloat = DeviceTypes.isiPhoneSE3rdGen ? 70 : 60
        let widthConstraint = verificationCodeButton.widthAnchor.constraint(equalTo: enterUserCredentialsView.widthAnchor, multiplier: 0.9)
        let heightConstraint = verificationCodeButton.heightAnchor.constraint(equalTo: verificationCodeButton.widthAnchor, multiplier: 1/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            verificationCodeButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: padding * 2.5),
            verificationCodeButton.centerXAnchor.constraint(equalTo: enterUserCredentialsView.centerXAnchor),
            widthConstraint, heightConstraint,
            
            verificationCodeButton.heightAnchor.constraint(lessThanOrEqualToConstant: heightAnchor),
            verificationCodeButton.widthAnchor.constraint(lessThanOrEqualToConstant: 400)
        ])
    }
    
    private func configurePrivacyPolicyAgreenmentTextViewLabel() {
        privacyPolicyAgreenmentTextViewLabel.delegate = self
        privacyPolicyAgreenmentTextViewLabel.setStyle(color: .lightGray, textAlignment: .center, fontSize: 15)
                
        NSLayoutConstraint.activate([
            privacyPolicyAgreenmentTextViewLabel.topAnchor.constraint(equalTo: verificationCodeButton.bottomAnchor, constant: padding / 2),
            privacyPolicyAgreenmentTextViewLabel.leadingAnchor.constraint(equalTo: enterUserCredentialsView.leadingAnchor, constant: padding),
            privacyPolicyAgreenmentTextViewLabel.trailingAnchor.constraint(equalTo: enterUserCredentialsView.trailingAnchor, constant: -padding),
            privacyPolicyAgreenmentTextViewLabel.bottomAnchor.constraint(equalTo: enterUserCredentialsView.bottomAnchor, constant: -padding)
        ])
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) { textField.placeholder = "+7 (XXX) XXX-XX-XX" }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        TextFieldManager.managePhoneTextFieldInput(textField: textField, range: range, string: string)
        TextFieldManager.isValid(.phone, textField.text ?? "") ? verificationCodeButton.setEnabled() : verificationCodeButton.setDisabled()
        return false
    }
}

extension LoginVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        switch button {
        case verificationCodeButton: 
            LoginVCHelper.handleVerificationCodeButtonTap(loginConfirmationView: loginConfirmationView, phoneTextField: phoneTextField, enterUserCredentialsView: enterUserCredentialsView, leadingConstraint: leadingConstraint, vc: self)
        default: break
        }
    }
}

extension LoginVC: UITextViewDelegate {
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        switch textItem.content{
        case .link(let url): 
            LoginVCHelper.configureItem(with: url, in: self)
            return UIAction(title: "") { _ in }
        case .textAttachment(_), .tag(_): break
        @unknown default: break
        }
        return defaultAction
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        LoginVCHelper.configureItem(with: URL, in: self)
        return false
    }
}

extension LoginVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController { return self }
}

extension LoginVC: LoginConfirmationViewDelegate {
    func didSuccessWithVerificationCode() {
        self.dismiss(animated: true)
        delegate?.didSuccessWithLogin()
    }
}

extension LoginVC: FLCTextButtonDelegate {
    func didTapButton(_ button: FLCTextButton) {
        switch button {
        case loginConfirmationView.getReturnButton(): FLCUIHelper.move(view: loginConfirmationView, constraint: leadingConstraint, vc: self, direction: .backward)
        default: break
        }
    }
}
