import UIKit

protocol LoginVCDelegate: AnyObject {
    func didSuccessWithLogin(for number: String, country: FLCUserCountry)
    func didFoundPhoneNumberDoesntExists(number: String)
}

final class LoginVC: FLCLoginVC {
    
    private let enterPhoneTitleLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 19, weight: .medium)
    private let countryCodePickerButton = FLCListPickerButton(placeholderText: "Страна", smallLabelFontSize: 25, mainLabelFontSize: 20)
    private let phoneTextField = FLCNumberTextField(smallLabelPlaceholderText: "Номер телефона", smallLabelFontSize: 20, keyboardType: .phonePad, fontSize: 20, fontWeight: .bold)
    private let verificationCodeButton = FLCButton(color: .flcOrange, title: "Получить код", isEnabled: false)
    private let privacyPolicyAgreenmentTextViewLabel = FLCTextViewLabel(text: "Нажимая на кнопку «Получить код», вы соглашаетесь с Правилами обработки персональных данных ООО «Фри Лайнс Компани»".makeAttributed(text: "Правилами обработки персональных данных", attributes: [.underlineStyle, .link], linkValue: "privacyPolicy"))
    
    private var pickedCountryItem: FLCCountryPhonesData?
    weak var delegate: LoginVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureEnterPhoneTitleLabel()
        configureCountryCodePickerButton()
        configurePhoneTextField()
        configureVerificationCodeButton()
        configurePrivacyPolicyAgreenmentTextViewLabel()
    }
    
    private func configureVC() {
        navigationItem.title = "Войти"
        loginConfirmationVC.delegate = self
        loginConfirmationVC.setReturnButtonDelegate(vc: self)
        enterUserCredentialsView.addSubviews(countryCodePickerButton, enterPhoneTitleLabel, phoneTextField, verificationCodeButton, privacyPolicyAgreenmentTextViewLabel)
    }
    
    private func configureEnterPhoneTitleLabel() {
        enterPhoneTitleLabel.text = "Чтобы войти, выберите страну, введите ваш номер телефона, а затем четырёхзначный код из смс"
        
        NSLayoutConstraint.activate([
            enterPhoneTitleLabel.topAnchor.constraint(equalTo: enterUserCredentialsView.topAnchor, constant: padding),
            enterPhoneTitleLabel.leadingAnchor.constraint(equalTo: enterUserCredentialsView.leadingAnchor, constant: padding),
            enterPhoneTitleLabel.trailingAnchor.constraint(equalTo: enterUserCredentialsView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureCountryCodePickerButton() {
        countryCodePickerButton.delegate = self
        
        NSLayoutConstraint.activate([
            countryCodePickerButton.topAnchor.constraint(equalTo: enterPhoneTitleLabel.bottomAnchor, constant: padding * 2),
            countryCodePickerButton.leadingAnchor.constraint(equalTo: enterUserCredentialsView.leadingAnchor, constant: padding),
            countryCodePickerButton.heightAnchor.constraint(equalToConstant: 55),
            countryCodePickerButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configurePhoneTextField()  {
        phoneTextField.delegate = self
        
        NSLayoutConstraint.activate([
            phoneTextField.topAnchor.constraint(equalTo: enterPhoneTitleLabel.bottomAnchor, constant: padding * 2),
            phoneTextField.leadingAnchor.constraint(equalTo: countryCodePickerButton.trailingAnchor, constant: padding / 2),
            phoneTextField.trailingAnchor.constraint(equalTo: enterUserCredentialsView.trailingAnchor, constant: -padding),
            phoneTextField.heightAnchor.constraint(equalToConstant: 55)
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard !countryCodePickerButton.titleIsEmpty else {
            FLCPopupView.showOnMainThread(title: "Сначала выберите страну", position: .top)
            return false
        }
        textField.placeholder = pickedCountryItem?.phoneMask ?? ""
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let endPosition = textField.text?.count else { return }
        textField.moveCursorTo(position: endPosition)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        TextFieldManager.managePhoneTextFieldInput(textField: textField, range: range, string: string, mask: pickedCountryItem?.phoneMask ?? "")
        TextFieldManager.isValid(.phone(mask: pickedCountryItem?.phoneMask ?? ""), textField.text ?? "") ? verificationCodeButton.setEnabled() : verificationCodeButton.setDisabled()
        return false
    }
}

extension LoginVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        switch button {
        case verificationCodeButton: 
            AuthorizationVCHelper.handleVerificationCodeButtonTap(loginConfirmationVC: loginConfirmationVC, pickedCountry: pickedCountryItem, phoneTextField: phoneTextField, enterUserCredentialsView: enterUserCredentialsView, leadingConstraint: leadingConstraint, vc: self)
        default: break
        }
    }
}

extension LoginVC: UITextViewDelegate {
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        switch textItem.content{
        case .link(let url): 
            TextViewManager.configureItem(with: url, in: self)
            return UIAction(title: "") { _ in }
        case .textAttachment(_), .tag(_): break
        @unknown default: break
        }
        return defaultAction
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        TextViewManager.configureItem(with: URL, in: self)
        return false
    }
}

extension LoginVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController { return self }
}

extension LoginVC: FLCLoginConfirmationVCDelegate {
    func didSuccessWithVerificationCode(sender: UIViewController) {
        self.dismiss(animated: true)
        let phoneNumber = ((pickedCountryItem?.phoneCode ?? "") + (phoneTextField.text ?? "")).extractDigits()
        delegate?.didSuccessWithLogin(for: phoneNumber, country: pickedCountryItem?.country ?? .russia)
    }
}

extension LoginVC: FLCTextButtonDelegate {
    func didTapButton(_ button: FLCTextButton) {
        switch button {
        case loginConfirmationVC.getReturnButton(): FLCUIHelper.move(view: loginConfirmationVCContainer, constraint: leadingConstraint, vc: self, direction: .backward)
        default: break
        }
    }
}

extension LoginVC: DelegateConfigurable {
    func setDelegate(with vc: UIViewController) { self.delegate = vc as? LoginVCDelegate }
}

extension LoginVC: FLCListPickerButtonDelegate {
    func didTapButton(_ button: FLCListPickerButton) {
        guard button == countryCodePickerButton else { return }
        CalculationHelper.presentListPickerVC(from: button, items: CalculationInfo.countryPhonesData.map { $0.convertToPickerItem() }, in: self)
    }
}

extension LoginVC: FLCPickerDelegate {
    func didSelectItem(pickedItem: FLCPickerItem, triggerButton: FLCListPickerButton) {
        triggerButton.set(title: pickedItem.subtitle)
        pickedCountryItem = CalculationInfo.countryPhonesData.first(where: { $0.countryName == pickedItem.title })
        
        phoneTextField.makeEmpty()
        phoneTextField.returnToIdentity()
    }
    func didClosePickerView(parentButton: FLCListPickerButton) {}
}
