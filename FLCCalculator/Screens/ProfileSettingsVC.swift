import UIKit

protocol ProfileSettingsVCDelegate: AnyObject {
    func didUpdateUserInfo()
}

class ProfileSettingsVC: UIViewController {
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let personalSectionLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 23, weight: .bold)
    private let nameTextField = FLCNumberTextField(smallLabelPlaceholderText: ProfileSettingsTextFieldsNames.name, smallLabelFontSize: 16, keyboardType: .default, fontSize: 18, fontWeight: .bold)
    private let birthdayTextField = FLCNumberTextField(smallLabelPlaceholderText: ProfileSettingsTextFieldsNames.dateOfBirth, smallLabelFontSize: 16, keyboardType: .decimalPad, fontSize: 18, fontWeight: .bold)
    private let contactsSectionLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 23, weight: .bold)
    private let phoneTextField = FLCNumberTextField(smallLabelPlaceholderText: ProfileSettingsTextFieldsNames.phoneNumber, smallLabelFontSize: 16, keyboardType: .phonePad, fontSize: 18, fontWeight: .bold)
    private let emailTextField = FLCNumberTextField(smallLabelPlaceholderText: ProfileSettingsTextFieldsNames.email, smallLabelFontSize: 17, keyboardType: .emailAddress, fontSize: 18, fontWeight: .bold)
    private let companySectionLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 23, weight: .bold)
    private let companyNameTextField = FLCNumberTextField(smallLabelPlaceholderText: ProfileSettingsTextFieldsNames.companyName, smallLabelFontSize: 16, keyboardType: .default, fontSize: 18, fontWeight: .bold)
    private let companyTaxPayerIDTextField = FLCNumberTextField(smallLabelPlaceholderText: ProfileSettingsTextFieldsNames.companyTaxPayerID, smallLabelFontSize: 16, keyboardType: .numberPad, fontSize: 18, fontWeight: .bold)
    private let customsDeclarationsAmountPerYearTextField = FLCNumberTextField(smallLabelPlaceholderText: ProfileSettingsTextFieldsNames.customsDeclarationsAmountPerYear, smallLabelFontSize: 16, keyboardType: .numberPad, fontSize: 18, fontWeight: .bold)
    private let privacyPolicyAgreenmentTextViewLabel = FLCTextViewLabel(text: "Изменяя и сохраняя данные в профиле, вы соглашаетесь с Правилами обработки персональных данных ООО «Фри Лайнс Компани»".makeAttributed(text: "Правилами обработки персональных данных", attributes: [.underlineStyle, .link], linkValue: "privacyPolicy"))
    private let saveButton = FLCButton(color: .flcOrange, title: "Сохранить изменения")
    private let exitButton = FLCTintedButton(color: .flcGray, title: "Выйти из аккаунта", titleFontSize: 20)
    private let deleteButton = FLCTintedButton(color: .systemRed, title: "Удалить аккаунт", titleFontSize: 20)
    
    private var user: FLCUser? = UserDefaultsPercistenceManager.retrieveItemFromUserDefaults()
    private let containerHeight: CGFloat = 980
    private let textFieldsHeight: CGFloat = 50
    private let textFieldsSmallLabelSize: CGFloat = 17
    private let padding: CGFloat = 17
    private var textFieldsValidity = [UITextField: Bool]()
    private var textFields: [UITextField] {
        [nameTextField, birthdayTextField, phoneTextField, emailTextField, companyNameTextField, companyTaxPayerIDTextField, customsDeclarationsAmountPerYearTextField]
    }
    
    weak var delegate: ProfileSettingsVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureScrollView()
        configureContainerView()
        configurePersonalSectionLabel()
        configureNameTextField()
        configureBirthdayTextField()
        configureContactsSectionLabel()
        configurePhoneTextField()
        configureEmailTextField()
        configureCompanySectionLabel()
        configureCompanyNameTextField()
        configureCompanyTaxPayerIDTextField()
        configureCustomsDeclarationsAmountPerYearTextField()
        configurePrivacyPolicyAgreenmentTextViewLabel()
        configureSaveButton()
        configureExitButton()
        configureDeleteButton()
        
        ProfileSettingsVCHelper.handleKeyboard(in: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProfileSettingsVCHelper.configureTextIn(textFields)
    }
    
    private func configureVC() {
        view.addSubview(scrollView)
        configureTapGesture(selector: #selector(self.viewTapped))
        
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Мой профиль"
        view.backgroundColor = .systemBackground
        setNavBarColor(color: UIColor.flcOrange)
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        
        scrollView.addSubview(containerView)
        scrollView.pinToEdges(of: view)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func configureContainerView() {
        containerView.addSubviews(personalSectionLabel, nameTextField, birthdayTextField, contactsSectionLabel, phoneTextField, emailTextField, companySectionLabel, companyNameTextField, companyTaxPayerIDTextField, customsDeclarationsAmountPerYearTextField, privacyPolicyAgreenmentTextViewLabel, saveButton, exitButton, deleteButton)
        containerView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
    }
    private func configurePersonalSectionLabel() {
        personalSectionLabel.text = "Персональная информация"
        
        NSLayoutConstraint.activate([
            personalSectionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding / 2),
            personalSectionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            personalSectionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            personalSectionLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureNameTextField()  {
        nameTextField.delegate = self
        nameTextField.text = user?.name ?? ""
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: personalSectionLabel.bottomAnchor, constant: padding / 1.5),
            nameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            nameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            nameTextField.heightAnchor.constraint(equalToConstant: textFieldsHeight)
        ])
    }
    
    private func configureBirthdayTextField()  {
        birthdayTextField.delegate = self
        birthdayTextField.text = user?.birthDate ?? ""
        
        NSLayoutConstraint.activate([
            birthdayTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: padding / 2),
            birthdayTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            birthdayTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            birthdayTextField.heightAnchor.constraint(equalToConstant: textFieldsHeight)
        ])
    }
    
    private func configureContactsSectionLabel() {
        contactsSectionLabel.text = "Контакты"
        
        NSLayoutConstraint.activate([
            contactsSectionLabel.topAnchor.constraint(equalTo: birthdayTextField.bottomAnchor, constant: padding),
            contactsSectionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            contactsSectionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            contactsSectionLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configurePhoneTextField()  {
        phoneTextField.delegate = self
        phoneTextField.text = user?.mobilePhone ?? ""
        
        NSLayoutConstraint.activate([
            phoneTextField.topAnchor.constraint(equalTo: contactsSectionLabel.bottomAnchor, constant: padding / 1.5),
            phoneTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            phoneTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            phoneTextField.heightAnchor.constraint(equalToConstant: textFieldsHeight)
        ])
    }
    
    private func configureEmailTextField()  {
        emailTextField.delegate = self
        emailTextField.text = user?.email ?? ""
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: padding / 2),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: textFieldsHeight)
        ])
    }
    
    private func configureCompanySectionLabel() {
        companySectionLabel.text = "О компании"
        
        NSLayoutConstraint.activate([
            companySectionLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            companySectionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            companySectionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            companySectionLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureCompanyNameTextField()  {
        companyNameTextField.delegate = self
        companyNameTextField.text = user?.companyName ?? ""
        
        NSLayoutConstraint.activate([
            companyNameTextField.topAnchor.constraint(equalTo: companySectionLabel.bottomAnchor, constant: padding / 1.5),
            companyNameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            companyNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            companyNameTextField.heightAnchor.constraint(equalToConstant: textFieldsHeight)
        ])
    }
    
    private func configureCompanyTaxPayerIDTextField()  {
        companyTaxPayerIDTextField.delegate = self
        companyTaxPayerIDTextField.text = user?.companyTaxPayerID ?? ""
        
        NSLayoutConstraint.activate([
            companyTaxPayerIDTextField.topAnchor.constraint(equalTo: companyNameTextField.bottomAnchor, constant: padding / 2),
            companyTaxPayerIDTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            companyTaxPayerIDTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            companyTaxPayerIDTextField.heightAnchor.constraint(equalToConstant: textFieldsHeight)
        ])
    }
    
    private func configureCustomsDeclarationsAmountPerYearTextField()  {
        customsDeclarationsAmountPerYearTextField.delegate = self
        customsDeclarationsAmountPerYearTextField.text = user?.customsDeclarationsAmountPerYear ?? ""
        
        NSLayoutConstraint.activate([
            customsDeclarationsAmountPerYearTextField.topAnchor.constraint(equalTo:         companyTaxPayerIDTextField.bottomAnchor, constant: padding / 2),
            customsDeclarationsAmountPerYearTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            customsDeclarationsAmountPerYearTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            customsDeclarationsAmountPerYearTextField.heightAnchor.constraint(equalToConstant: textFieldsHeight)
        ])
    }
    
    private func configureSaveButton() {
        saveButton.delegate = self
        
        let widthConstraint = saveButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9)
        let heightConstraint = saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 1/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: customsDeclarationsAmountPerYearTextField.bottomAnchor, constant: padding * 2),
            saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            widthConstraint, heightConstraint,
            
            saveButton.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            saveButton.widthAnchor.constraint(lessThanOrEqualToConstant: 450)
        ])
    }
    
    private func configurePrivacyPolicyAgreenmentTextViewLabel() {
        privacyPolicyAgreenmentTextViewLabel.delegate = self
        privacyPolicyAgreenmentTextViewLabel.setStyle(color: .lightGray, textAlignment: .left, fontSize: 14)
        
        NSLayoutConstraint.activate([
            privacyPolicyAgreenmentTextViewLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: padding / 2),
            privacyPolicyAgreenmentTextViewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 1.3),
            privacyPolicyAgreenmentTextViewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding * 1.3)
        ])
    }

    private func configureExitButton() {
        exitButton.delegate = self
        
        let widthConstraint = exitButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9)
        let heightConstraint = exitButton.heightAnchor.constraint(equalTo: exitButton.widthAnchor, multiplier: 1/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: privacyPolicyAgreenmentTextViewLabel.bottomAnchor, constant: padding * 3),
            exitButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            widthConstraint, heightConstraint,
            
            exitButton.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            exitButton.widthAnchor.constraint(lessThanOrEqualToConstant: 450)
        ])
    }
    
    private func configureDeleteButton() {
        deleteButton.delegate = self
        
        let widthConstraint = deleteButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9)
        let heightConstraint = deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 1/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: padding / 2),
            deleteButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            widthConstraint, heightConstraint,
            
            deleteButton.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            deleteButton.widthAnchor.constraint(lessThanOrEqualToConstant: 450)
        ])
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        ProfileSettingsVCHelper.keyboardWillShow(notification: notification, scrollView: scrollView)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        ProfileSettingsVCHelper.keyboardWillHide(notification: notification, scrollView: scrollView)
    }
    @objc private func closeButtonPressed() { dismiss(animated: true) }
    @objc private func viewTapped(_ gesture: UITapGestureRecognizer) { view.endEditing(true) }
}

extension ProfileSettingsVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case phoneTextField: textField.placeholder = "+7 (XXX) XXX-XX-XX"
        case birthdayTextField: textField.placeholder = "ДД.MM.ГГГГ"
        case nameTextField: textField.placeholder = "Иванов Иван Иванович"
        case companyNameTextField: textField.placeholder = "ООО/ИП Название юр. лица"
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        TextFieldManager.returnTextFieldsLabelToIdentity(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case phoneTextField:
            TextFieldManager.managePhoneTextFieldInput(textField: textField, range: range, string: string)
            textFieldsValidity[textField] = TextFieldManager.isValid(.phone, textField.text ?? "")
        case emailTextField:
            TextFieldManager.manageEmailTextFieldInput(textField: textField, range: range, string: string)
            textFieldsValidity[textField] = TextFieldManager.isValid(.email, textField.text ?? "")
        case nameTextField:
            TextFieldManager.manageNameTextFieldInput(textField: textField, range: range, string: string)
            textFieldsValidity[textField] = TextFieldManager.isValid(.username, textField.text ?? "")
        case birthdayTextField:
            TextFieldManager.manageBirthdayTextFieldInput(textField: textField, range: range, string: string)
            textFieldsValidity[textField] = TextFieldManager.isValid(.birthdate, textField.text ?? "")
        case companyNameTextField:
            TextFieldManager.manageCompanyNameTextFieldInput(textField: textField, range: range, string: string)
            textFieldsValidity[textField] = TextFieldManager.isValid(.companyName, textField.text ?? "")
        case companyTaxPayerIDTextField:
            TextFieldManager.manageDigitsTextFieldInput(textField: textField, range: range, string: string, maxDigits: 12)
            textFieldsValidity[textField] = TextFieldManager.isValid(.taxPayerID, textField.text ?? "")
        case customsDeclarationsAmountPerYearTextField:
            TextFieldManager.manageDigitsTextFieldInput(textField: textField, range: range, string: string, maxDigits: 4)
            textFieldsValidity[textField] = TextFieldManager.isValid(.customsDeclarationsAmount, textField.text ?? "")
        default: break
        }
        return false
    }
}

extension ProfileSettingsVC: UITextViewDelegate {
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

extension ProfileSettingsVC: FLCTintedButtonDelegate {
    func didTapButton(_ button: FLCTintedButton) {
        switch button {
        case exitButton: ProfileSettingsVCHelper.performExitFromAccount(in: self)
        case deleteButton: break
        default: break
        }
    }
}

extension ProfileSettingsVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        switch button {
        case saveButton:
            if ProfileSettingsVCHelper.isAllDataValid(textFieldsValidity), let updatedUser = ProfileSettingsVCHelper.createNewUserData(user: user, with: textFields) {
                UserDefaultsPercistenceManager.updateItemInUserDefaults(item: updatedUser)
                FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Данные успешно обновлены")
                delegate?.didUpdateUserInfo()
                dismiss(animated: true)
            }
        default: break
        }
    }
}

extension ProfileSettingsVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController { return self }
}

extension ProfileSettingsVC: UIScrollViewDelegate {}
