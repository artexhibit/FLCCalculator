import UIKit

protocol LoginConfirmationViewDelegate: AnyObject {
    func didSuccessWithVerificationCode()
}

final class LoginConfirmationView: UIView {
    
    private let loginConfirmationTitleLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 19, weight: .medium)
    private let verificationCodeTextFieldsStackView = UIStackView()
    private var verificationCodeTextFields = [FLCNumberTextField]()
    
    private let padding: CGFloat = 18
    private var verificationCode = ""
    
    weak var delegate: LoginConfirmationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLoginConfirmationTitleLabel()
        configureFailedPriceCalcContainerContentStackView()
        configureVerificationCodeTextFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(loginConfirmationTitleLabel, verificationCodeTextFieldsStackView)
    }
    
    private func configureLoginConfirmationTitleLabel() {
        NSLayoutConstraint.activate([
            loginConfirmationTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            loginConfirmationTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            loginConfirmationTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
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
            verificationCodeTextFieldsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            verificationCodeTextFieldsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
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
    
    func setLoginConfirmationView(text: String, verificationCode: String) {
        self.verificationCode = verificationCode
        
        let labelMain = "Код подтверждения".makeAttributed(text: "Код подтверждения", attributes: [.font], font: UIFont.systemFont(ofSize: 25, weight: .bold)) ?? NSAttributedString()
        let attributedPhoneString = "\n\nНа номер \(text) был отправлен код подтверждения".makeAttributed(text: text, attributes: [.font], font: UIFont.systemFont(ofSize: 20, weight: .bold)) ?? NSAttributedString()

        loginConfirmationTitleLabel.attributedText = NSMutableAttributedString().combine(strings: labelMain, attributedPhoneString)
    }
    
    func makeFirstTextFieldActive() { _ = verificationCodeTextFields.first?.becomeFirstResponder() }
}

extension LoginConfirmationView: UITextFieldDelegate {
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
            delegate?.didSuccessWithVerificationCode()
        }
        return false
    }
}

extension LoginConfirmationView: FLCNumberTextFieldDelegate {
    func didTriggerDeleteBackward(_ textField: FLCNumberTextField) {
        TextFieldManager.goToPreviousTextField(activeTF: textField, allTFs: verificationCodeTextFields)
    }
}
