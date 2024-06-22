import UIKit

protocol RegistrationVCDelegate: AnyObject {
    func didSuccessWithRegistration(phoneNumber: String, email: String)
    func didFoundPhoneNumberExists(number: String)
}

class RegistrationVC: FLCLoginVC {
    
    private let enterPhoneAndEmailTitleLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 19, weight: .medium)
    private let phoneTextField = FLCNumberTextField(smallLabelPlaceholderText: "Номер телефона", smallLabelFontSize: 20, keyboardType: .phonePad, fontSize: 27, fontWeight: .bold)
    private let emailTextField = FLCNumberTextField(smallLabelPlaceholderText: "Email", smallLabelFontSize: 20, keyboardType: .emailAddress, fontSize: 23, fontWeight: .bold)
    private let proceedWithRegistrationButton = FLCButton(color: .flcOrange, title: "Зарегистрироваться", isEnabled: false)
    
    private var isPhoneValid = false
    private var isEmailValid = false
    
    weak var delegate: RegistrationVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureEnterPhoneTitleLabel()
        configurePhoneTextField()
        configureEmailTextField()
        configureProceedWithRegistrationButton()
    }
    
    private func configureVC() {
        navigationItem.title = "Регистрация"
        loginConfirmationView.delegate = self
        loginConfirmationView.setReturnButtonDelegate(vc: self)
        enterUserCredentialsView.addSubviews(enterPhoneAndEmailTitleLabel, phoneTextField, emailTextField, proceedWithRegistrationButton)
    }
    
    private func configureEnterPhoneTitleLabel() {
        enterPhoneAndEmailTitleLabel.text = "Чтобы зарегистрироваться, введите ваш номер телефона и email, а затем четырёхзначный код из смс"
        
        NSLayoutConstraint.activate([
            enterPhoneAndEmailTitleLabel.topAnchor.constraint(equalTo: enterUserCredentialsView.topAnchor, constant: padding),
            enterPhoneAndEmailTitleLabel.leadingAnchor.constraint(equalTo: enterUserCredentialsView.leadingAnchor, constant: padding),
            enterPhoneAndEmailTitleLabel.trailingAnchor.constraint(equalTo: enterUserCredentialsView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configurePhoneTextField()  {
        phoneTextField.delegate = self
        phoneTextField.flcNumberTextfieldDelegate = self
        
        NSLayoutConstraint.activate([
            phoneTextField.topAnchor.constraint(equalTo: enterPhoneAndEmailTitleLabel.bottomAnchor, constant: padding * 2),
            phoneTextField.leadingAnchor.constraint(equalTo: enterUserCredentialsView.leadingAnchor, constant: padding),
            phoneTextField.trailingAnchor.constraint(equalTo: enterUserCredentialsView.trailingAnchor, constant: -padding),
            phoneTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureEmailTextField()  {
        emailTextField.delegate = self
        emailTextField.flcNumberTextfieldDelegate = self
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: padding),
            emailTextField.leadingAnchor.constraint(equalTo: enterUserCredentialsView.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: enterUserCredentialsView.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureProceedWithRegistrationButton() {
        proceedWithRegistrationButton.delegate = self
        
        let heightAnchor: CGFloat = DeviceTypes.isiPhoneSE3rdGen ? 70 : 60
        let widthConstraint = proceedWithRegistrationButton.widthAnchor.constraint(equalTo: enterUserCredentialsView.widthAnchor, multiplier: 0.9)
        let heightConstraint = proceedWithRegistrationButton.heightAnchor.constraint(equalTo: proceedWithRegistrationButton.widthAnchor, multiplier: 1/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            proceedWithRegistrationButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding * 2.5),
            proceedWithRegistrationButton.centerXAnchor.constraint(equalTo: enterUserCredentialsView.centerXAnchor),
            widthConstraint, heightConstraint,
            
            proceedWithRegistrationButton.heightAnchor.constraint(lessThanOrEqualToConstant: heightAnchor),
            proceedWithRegistrationButton.widthAnchor.constraint(lessThanOrEqualToConstant: 400)
        ])
    }
}

extension RegistrationVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTextField { textField.placeholder = "+7 (XXX) XXX-XX-XX" }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        TextFieldManager.returnTextFieldsLabelToIdentity(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case phoneTextField: 
            TextFieldManager.managePhoneTextFieldInput(textField: textField, range: range, string: string)
            isPhoneValid = TextFieldManager.isValid(.phone, textField.text ?? "")
        case emailTextField:
            TextFieldManager.manageEmailTextFieldInput(textField: textField, range: range, string: string)
            isEmailValid = TextFieldManager.isValid(.email, textField.text ?? "")
        default: break
        }
        
        isPhoneValid && isEmailValid ? proceedWithRegistrationButton.setEnabled() : proceedWithRegistrationButton.setDisabled()
        return false
    }
}

extension RegistrationVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        switch button {
        case proceedWithRegistrationButton:
            AuthorizationVCHelper.handleVerificationCodeButtonTap(loginConfirmationView: loginConfirmationView, phoneTextField: phoneTextField, enterUserCredentialsView: enterUserCredentialsView, leadingConstraint: leadingConstraint, vc: self)
        default: break
        }
    }
}

extension RegistrationVC: LoginConfirmationViewDelegate {
    func didSuccessWithVerificationCode() {
        self.dismiss(animated: true)
        delegate?.didSuccessWithRegistration(phoneNumber: phoneTextField.text?.extractDigits() ?? "", email: emailTextField.text ?? "")
    }
}

extension RegistrationVC: FLCTextButtonDelegate {
    func didTapButton(_ button: FLCTextButton) {
        switch button {
        case loginConfirmationView.getReturnButton(): FLCUIHelper.move(view: loginConfirmationView, constraint: leadingConstraint, vc: self, direction: .backward)
        default: break
        }
    }
}

extension RegistrationVC: FLCNumberTextFieldDelegate {
    func didRequestNextTextfield(_ textField: FLCNumberTextField) {
        TextFieldManager.goToNextTextField(activeTF: textField, allTFs: [phoneTextField, emailTextField])
    }
    
    func didRequestPreviousTextField(_ textField: FLCNumberTextField) {
        TextFieldManager.goToPreviousTextField(activeTF: textField, allTFs: [phoneTextField, emailTextField])
    }
}

extension RegistrationVC: DelegateConfigurable {
    func setDelegate(with vc: UIViewController) { self.delegate = vc as? RegistrationVCDelegate }
}
