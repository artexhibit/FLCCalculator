import UIKit

protocol AuthorizationVCDelegate: AnyObject {
    func didSuccessWithAuthorization()
}

final class AuthorizationVC: UIViewController {
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let enterPhoneView = UIView()
    private let enterPhoneTitleLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 19, weight: .medium)
    private let phoneTextField = FLCNumberTextField(smallLabelPlaceholderText: "Номер телефона", smallLabelFontSize: 20, keyboardType: .phonePad, fontSize: 27, fontWeight: .bold)
    private let verificationCodeButton = FLCButton(color: .flcOrange, title: "Получить код", isEnabled: false)
    private let privacyPolicyAgreenmentTextViewLabel = FLCTextViewLabel(text: "Нажимая на кнопку «Получить код», вы соглашаетесь с Правилами обработки персональных данных ООО «Фри Лайнс Компани»".makeAttributed(text: "Правилами обработки персональных данных", attributes: [.underlineStyle, .link], linkValue: "privacyPolicy"))
    private let loginConfirmationView = LoginConfirmationView()
    
    private var leadingConstraint: NSLayoutConstraint!
    private let padding: CGFloat = 18
    
    weak var delegate: AuthorizationVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureScrollView()
        configureContainerView()
        configureEnterPhoneView()
        configureLoginConfirmationView()
        configureEnterPhoneTitleLabel()
        configurePhoneTextField()
        configureVerificationCodeButton()
        configurePrivacyPolicyAgreenmentTextViewLabel()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        navigationItem.title = "Войти"
        setNavBarColor(color: UIColor.flcOrange)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    @objc func closeButtonPressed() { self.dismiss(animated: true) }
    
    private func configureScrollView() {
        scrollView.delegate = self
        
        scrollView.addSubview(containerView)
        scrollView.pinToEdges(of: view)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func configureContainerView() {
        containerView.addSubviews(enterPhoneView, loginConfirmationView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    private func configureEnterPhoneView() {
        enterPhoneView.addSubviews(enterPhoneTitleLabel, phoneTextField, verificationCodeButton, privacyPolicyAgreenmentTextViewLabel)
        enterPhoneView.translatesAutoresizingMaskIntoConstraints = false
        
        leadingConstraint = enterPhoneView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([
            enterPhoneView.topAnchor.constraint(equalTo: containerView.topAnchor),
            leadingConstraint,
            enterPhoneView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            enterPhoneView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func configureLoginConfirmationView() {
        loginConfirmationView.delegate = self
        loginConfirmationView.setReturnButtonDelegate(vc: self)
        
        NSLayoutConstraint.activate([
            loginConfirmationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loginConfirmationView.leadingAnchor.constraint(equalTo: enterPhoneView.trailingAnchor),
            loginConfirmationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            loginConfirmationView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
    }
    
    private func configureEnterPhoneTitleLabel() {
        enterPhoneTitleLabel.text = "Чтобы войти, введите ваш номер телефона, а затем четырёхзначный код из смс"
        
        NSLayoutConstraint.activate([
            enterPhoneTitleLabel.topAnchor.constraint(equalTo: enterPhoneView.topAnchor, constant: padding),
            enterPhoneTitleLabel.leadingAnchor.constraint(equalTo: enterPhoneView.leadingAnchor, constant: padding),
            enterPhoneTitleLabel.trailingAnchor.constraint(equalTo: enterPhoneView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configurePhoneTextField()  {
        phoneTextField.delegate = self
        
        NSLayoutConstraint.activate([
            phoneTextField.topAnchor.constraint(equalTo: enterPhoneTitleLabel.bottomAnchor, constant: padding * 2),
            phoneTextField.leadingAnchor.constraint(equalTo: enterPhoneView.leadingAnchor, constant: padding),
            phoneTextField.trailingAnchor.constraint(equalTo: enterPhoneView.trailingAnchor, constant: -padding),
            phoneTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureVerificationCodeButton() {
        verificationCodeButton.delegate = self
        
        let heightAnchor: CGFloat = DeviceTypes.isiPhoneSE3rdGen ? 70 : 60
        let widthConstraint = verificationCodeButton.widthAnchor.constraint(equalTo: enterPhoneView.widthAnchor, multiplier: 0.9)
        let heightConstraint = verificationCodeButton.heightAnchor.constraint(equalTo: verificationCodeButton.widthAnchor, multiplier: 1/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            verificationCodeButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: padding * 2.5),
            verificationCodeButton.centerXAnchor.constraint(equalTo: enterPhoneView.centerXAnchor),
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
            privacyPolicyAgreenmentTextViewLabel.leadingAnchor.constraint(equalTo: enterPhoneView.leadingAnchor, constant: padding),
            privacyPolicyAgreenmentTextViewLabel.trailingAnchor.constraint(equalTo: enterPhoneView.trailingAnchor, constant: -padding),
            privacyPolicyAgreenmentTextViewLabel.bottomAnchor.constraint(equalTo: enterPhoneView.bottomAnchor, constant: -padding)
        ])
    }
}

extension AuthorizationVC: UIScrollViewDelegate {}

extension AuthorizationVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) { textField.placeholder = "+7 (XXX) XXX-XX-XX" }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        let cursorPosition = textField.getCursorPosition()
        let formattedText = TextFieldManager.formatPhoneNumber(with: "+7 (XXX) XXX-XX-XX", phone: newString)
        
        textField.text = formattedText
        
        let newCursorPosition = string.isEmpty ? max(2, cursorPosition - 1) : cursorPosition + (formattedText.count - text.count)
        textField.moveCursorTo(position: newCursorPosition)
        
        TextFieldManager.isValidPhoneNumber(in: textField.text ?? "") ? verificationCodeButton.setEnabled() : verificationCodeButton.setDisabled()
        return false
    }
}

extension AuthorizationVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        switch button {
        case verificationCodeButton: 
            AuthorizationVCHelper.handleVerificationCodeButtonTap(loginConfirmationView: loginConfirmationView, phoneTextField: phoneTextField, enterPhoneView: enterPhoneView, leadingConstraint: leadingConstraint, vc: self)
        default: break
        }
    }
}

extension AuthorizationVC: UITextViewDelegate {
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        switch textItem.content{
        case .link(let url): 
            AuthorizationVCHelper.configureItem(with: url, in: self)
            return UIAction(title: "") { _ in }
        case .textAttachment(_), .tag(_): break
        @unknown default: break
        }
        return defaultAction
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        AuthorizationVCHelper.configureItem(with: URL, in: self)
        return false
    }
}

extension AuthorizationVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController { return self }
}

extension AuthorizationVC: LoginConfirmationViewDelegate {
    func didSuccessWithVerificationCode() {
        self.dismiss(animated: true)
        delegate?.didSuccessWithAuthorization()
    }
}

extension AuthorizationVC: FLCTextButtonDelegate {
    func didTapButton(_ button: FLCTextButton) {
        switch button {
        case loginConfirmationView.getReturnButton(): FLCUIHelper.move(view: loginConfirmationView, constraint: leadingConstraint, vc: self, direction: .backward)
        default: break
        }
    }
}
