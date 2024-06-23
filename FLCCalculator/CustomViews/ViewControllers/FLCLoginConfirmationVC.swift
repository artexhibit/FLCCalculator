import UIKit

protocol FLCLoginConfirmationVCDelegate: AnyObject {
    func didSuccessWithVerificationCode(sender: UIViewController)
}

final class FLCLoginConfirmationVC: UIViewController {
    
    private let loginConfirmationTitleLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 19, weight: .medium)
    private let verificationCodeTextFieldsStackView = UIStackView()
    private var verificationCodeTextFields = [FLCNumberTextField]()
    private let returnToEnterPhoneViewButton = FLCTextButton(title: "вернуться назад")
    
    private let padding: CGFloat = 18
    private var myltiplyTopPaddingBy: CGFloat = 1
    private var verificationCode = ""
    
    weak var delegate: FLCLoginConfirmationVCDelegate?
    
    init(myltiplyTopPaddingBy: CGFloat = 1) {
        super.init(nibName: nil, bundle: nil)
        self.myltiplyTopPaddingBy = myltiplyTopPaddingBy
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureLoginConfirmationTitleLabel()
        configureFailedPriceCalcContainerContentStackView()
        configureVerificationCodeTextFields()
        configureReturnToEnterPhoneViewButton()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubviews(loginConfirmationTitleLabel, verificationCodeTextFieldsStackView, returnToEnterPhoneViewButton)
    }
    
    private func configureLoginConfirmationTitleLabel() {
        NSLayoutConstraint.activate([
            loginConfirmationTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: padding * myltiplyTopPaddingBy),
            loginConfirmationTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            loginConfirmationTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureFailedPriceCalcContainerContentStackView() {
        verificationCodeTextFieldsStackView.axis = .horizontal
        verificationCodeTextFieldsStackView.alignment = .center
        verificationCodeTextFieldsStackView.distribution = .equalSpacing
        verificationCodeTextFieldsStackView.spacing = 10
        verificationCodeTextFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verificationCodeTextFieldsStackView.topAnchor.constraint(equalTo: loginConfirmationTitleLabel.bottomAnchor, constant: padding * 2),
            verificationCodeTextFieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            verificationCodeTextFieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureVerificationCodeTextFields() {
        for _ in 0..<4 {
            let verificationCodeTextField = FLCNumberTextField(keyboardType: .numberPad, textContentType: .oneTimeCode, fontSize: 45, fontWeight: .bold, addClearButton: false, withSmallLabel: false, isTextCentered: true)
            
            verificationCodeTextField.delegate = self
            verificationCodeTextField.flcNumberTextfieldDelegate = self
            
            verificationCodeTextFieldsStackView.addArrangedSubview(verificationCodeTextField)
            verificationCodeTextFields.append(verificationCodeTextField)
            
            NSLayoutConstraint.activate([
                verificationCodeTextField.widthAnchor.constraint(equalToConstant: 70),
                verificationCodeTextField.heightAnchor.constraint(equalTo: verificationCodeTextField.widthAnchor)
            ])
        }
    }
    
    private func configureReturnToEnterPhoneViewButton() {
        NSLayoutConstraint.activate([
            returnToEnterPhoneViewButton.topAnchor.constraint(equalTo: verificationCodeTextFieldsStackView.bottomAnchor, constant: padding),
            returnToEnterPhoneViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setLoginConfirmationView(phoneNumber: String, verificationCode: String, isReturnButtonOn: Bool = true) {
        self.verificationCode = verificationCode
        
        let labelMain = "Код подтверждения".makeAttributed(text: "Код подтверждения", attributes: [.font], font: UIFont.systemFont(ofSize: 25, weight: .bold)) ?? NSAttributedString()
        let attributedPhoneString = "\n\nНа номер \(phoneNumber) был отправлен код подтверждения".makeAttributed(text: phoneNumber, attributes: [.font], font: UIFont.systemFont(ofSize: 20, weight: .bold)) ?? NSAttributedString()

        loginConfirmationTitleLabel.attributedText = NSMutableAttributedString().combine(strings: labelMain, attributedPhoneString)
        
        if !isReturnButtonOn {
            returnToEnterPhoneViewButton.isUserInteractionEnabled = false
            returnToEnterPhoneViewButton.layer.opacity = 0
        }
    }
    
    func makeFirstTextFieldActive() { _ = verificationCodeTextFields.first?.becomeFirstResponder() }
    func getReturnButton() -> FLCTextButton { returnToEnterPhoneViewButton }
    func setReturnButtonDelegate(vc: UIViewController) { returnToEnterPhoneViewButton.delegate = vc as? FLCTextButtonDelegate }
}

extension FLCLoginConfirmationVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = ""
        
        if !string.isEmpty {
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) { return false }
            
            if string.count > 1 {
                for (idx, digit) in string.enumerated() { verificationCodeTextFields[idx].text = String(digit) }
                _ = verificationCodeTextFields.last?.becomeFirstResponder()
            } else {
                textField.text = string
                TextFieldManager.goToNextTextField(activeTF: textField, allTFs: verificationCodeTextFields)
            }
        } else {
            TextFieldManager.goToPreviousTextField(activeTF: textField, allTFs: verificationCodeTextFields)
        }
        
        if LoginConfirmationHelper.isTypedVerificationCodeMatch(in: verificationCodeTextFields, verificationCode: verificationCode) {
            delegate?.didSuccessWithVerificationCode(sender: self)
        }
        return false
    }
}

extension FLCLoginConfirmationVC: FLCNumberTextFieldDelegate {
    func didTriggerDeleteBackward(_ textField: FLCNumberTextField) {
        TextFieldManager.goToPreviousTextField(activeTF: textField, allTFs: verificationCodeTextFields)
    }
}
