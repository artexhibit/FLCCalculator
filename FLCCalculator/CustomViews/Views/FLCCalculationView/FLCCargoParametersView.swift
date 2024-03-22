import UIKit

class FLCCargoParametersView: FLCCalculationView {
    
    private let stackView = UIStackView()
    
    let cargoTypePickerButton = FLCListPickerButton(placeholderText: "Тип груза")
    let weightTextField = FLCNumberTextField(placeholderText: "Вес груза, кг")
    let volumeTextField = FLCNumberTextField(placeholderText: "Объём, м3")
    private let invoiceAmountTextField = FLCNumberTextField(placeholderText: "Сумма по инвойсу")
    let invoiceCurrencyPickerButton = FLCListPickerButton(placeholderText: "Валюта")
    private let tintedView = FLCTintedView(color: .accent)
    private let customsClearanceTextViewLabel = FLCTextViewLabel(text: "Необходимо таможенное оформление".makeAttributed(icon: Icons.infoSign, tint: .accent, size: (0, -5, 24, 23), placeIcon: .afterText), color: .flcNumberTextFieldLabel, textAlignment: .left)
    let customsClearanceSwitch = UISwitch()
    let nextButton = FLCButton(color: .accent, title: "Далее", systemImageName: "arrowshape.forward.fill")
    
    var filledTextFileds = [UITextField: Bool]()
    var filledButtons = [FLCListPickerButton: Bool]()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTitleLabel()
        configureStackView()
        configureCargoTypePickerButton()
        configureInvoiceAmountTextField()
        configureInvoiceCurrencyPickerButton()
        configureTintedView()
        configureCustomsClearanceSwitch()
        configureNextButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCustomsClearanceLabel()
        setCalculationVCDelegate()
    }
    
    private func setCalculationVCDelegate() {
        guard let vc = self.findParentViewController() as? CalculationVC else { return }
        vc.delegate = self
    }
    
    private func configure() {
        addSubviews(cargoTypePickerButton, stackView, invoiceAmountTextField, invoiceCurrencyPickerButton, tintedView, nextButton)
        
        flcTextFields.append(contentsOf: [weightTextField, volumeTextField, invoiceAmountTextField])
        flcListPickerButtons.append(contentsOf: [cargoTypePickerButton, invoiceCurrencyPickerButton])
        
        flcTextFields.forEach { $0.navigationDelegate = self }
        flcTextFields.forEach { filledTextFileds[$0] = false }
        flcListPickerButtons.forEach { filledButtons[$0] = false }
    }
    
    private func configureTitleLabel() { titleLabel.text = "Расскажите нам о вашем грузе" }
    
    private func configureCargoTypePickerButton() {
        cargoTypePickerButton.delegate = self
        
        NSLayoutConstraint.activate([
            cargoTypePickerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding * 3.5),
            cargoTypePickerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            cargoTypePickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            cargoTypePickerButton.heightAnchor.constraint(equalTo: cargoTypePickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        stackView.addArrangedSubview(weightTextField)
        stackView.addArrangedSubview(volumeTextField)
        
        weightTextField.delegate = self
        volumeTextField.delegate = self
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cargoTypePickerButton.bottomAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalTo: weightTextField.widthAnchor, multiplier: 0.31)
        ])
    }
    
    private func configureInvoiceAmountTextField() {
        invoiceAmountTextField.delegate = self
        
        NSLayoutConstraint.activate([
            invoiceAmountTextField.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            invoiceAmountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            invoiceAmountTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            invoiceAmountTextField.heightAnchor.constraint(equalTo: cargoTypePickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
    
    private func configureInvoiceCurrencyPickerButton() { 
        invoiceCurrencyPickerButton.delegate = self
        
        NSLayoutConstraint.activate([
            invoiceCurrencyPickerButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            invoiceCurrencyPickerButton.leadingAnchor.constraint(equalTo: invoiceAmountTextField.trailingAnchor, constant: padding),
            invoiceCurrencyPickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            invoiceCurrencyPickerButton.heightAnchor.constraint(equalTo: cargoTypePickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
    
    private func configureTintedView() {
        tintedView.addSubviews(customsClearanceTextViewLabel, customsClearanceSwitch)
        
        NSLayoutConstraint.activate([
            tintedView.topAnchor.constraint(equalTo: invoiceAmountTextField.bottomAnchor, constant: padding * 1.5),
            tintedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            tintedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureCustomsClearanceLabel() {
        customsClearanceTextViewLabel.delegate = self
        
        let labelWidth = tintedView.frame.width - customsClearanceSwitch.frame.width - 3 * padding
        
        NSLayoutConstraint.activate([
            customsClearanceTextViewLabel.topAnchor.constraint(equalTo: tintedView.topAnchor, constant: padding),
            customsClearanceTextViewLabel.leadingAnchor.constraint(equalTo: tintedView.leadingAnchor, constant: padding),
            customsClearanceTextViewLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            customsClearanceTextViewLabel.bottomAnchor.constraint(equalTo: tintedView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureCustomsClearanceSwitch() {
        customsClearanceSwitch.translatesAutoresizingMaskIntoConstraints = false
        customsClearanceSwitch.onTintColor = .accent
        customsClearanceSwitch.isOn = true
        customsClearanceSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            customsClearanceSwitch.centerYAnchor.constraint(equalTo: customsClearanceTextViewLabel.centerYAnchor),
            customsClearanceSwitch.trailingAnchor.constraint(equalTo: tintedView.trailingAnchor, constant: -padding * 1.5)
        ])
    }
    
    private func configureNextButton() {
        nextButton.delegate = self
        
        let widthConstraint = nextButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
        let heightConstraint = nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor, multiplier: 1/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: tintedView.bottomAnchor, constant: padding * 4),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            widthConstraint, heightConstraint,
            
            nextButton.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            nextButton.widthAnchor.constraint(lessThanOrEqualToConstant: 450)
        ])
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
    }
}

extension FLCCargoParametersView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            guard let text = textField.text else { return }
            
            if text.isEmpty {
                textField.text = textField != self.invoiceAmountTextField ? FLCNumberTextField.placeholderValue : "0"
                textField.moveCursorTo(position: 0)
            } else {
                textField.text = text
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            guard let text = textField.text else { return }
            
            if text.isEmpty {
                textField.text = textField != self.invoiceAmountTextField ? FLCNumberTextField.placeholderValue : "0"
            } else {
                if self.filledTextFileds[textField] == false {
                    self.filledTextFileds[textField] = true
                    self.delegate?.didEnterRequiredInfo()
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let formatter = textField != self.invoiceAmountTextField ? NumberFormatter.getFLCNumberFormatter() : NumberFormatter.getFLCNumberFormatter(withDecimals: 0)

        let decimalSeparator = formatter.decimalSeparator ?? ""
        guard let text = textField.text else { return false }
        let separatorIndex = text.firstIndex(of: Character(formatter.decimalSeparator ?? "")) ?? text.endIndex
        let separatorPositon = text.distance(from: text.startIndex, to: separatorIndex)
 
        if textField.getCursorPosition() == text.count && text.contains(decimalSeparator) && !string.isEmpty { return false }
  
        if string == decimalSeparator {
            return TextFieldManager.moveCursorToDecimals(in: textField, withText: text, decimalSeparator: decimalSeparator, separatorPositon: separatorPositon)
        }
    
        if (textField.getCursorPosition() - 1 == separatorPositon) && string.isEmpty {
            return TextFieldManager.removeCharacterBefore(positon: separatorPositon, and: textField, inText: text, withDecimalSeparator: decimalSeparator, using: formatter)
        }
       
        if text == FLCNumberTextField.placeholderValue && textField.getCursorPosition() == 0 || text == "0" && !string.isEmpty {
            TextFieldManager.replaceFirstCharacter(with: string, in: textField, and: text)
            return false
        }
      
        let newText = NSString(string: text).replacingCharacters(in: range, with: string)
        let formattedNumber = TextFieldManager.createFormattedNumber(from: newText, using: formatter)
        textField.text = formattedNumber
       
        let cursorOffset = TextFieldManager.calculateCursorOffset(range: range, text: text, string: string, formatter: formatter, number: formattedNumber)
        textField.moveCursorTo(position: cursorOffset)

        return false
    }
}

extension FLCCargoParametersView: FLCPickerDelegate {
    func didSelectItem(pickedItem: FLCPickerItem, triggerButton: FLCListPickerButton) {
        if triggerButton.titleIsEmpty { delegate?.didEnterRequiredInfo() }
        triggerButton.set(title: pickedItem.title)
        
        delegate?.didSelectItem(pickedItem: pickedItem, triggerButton: triggerButton)
    }
    
    func didClosePickerView(parentButton: FLCListPickerButton) {}
}

extension FLCCargoParametersView: FLCNumberTextFieldDelegate {
    func didRequestNextTextfield(_ textField: FLCNumberTextField) {
        guard let targetTextFieldIndex = flcTextFields.firstIndex(where: { $0 == textField }), targetTextFieldIndex < flcTextFields.count - 1 else { return }
       let _ = flcTextFields[targetTextFieldIndex + 1].becomeFirstResponder()
    }
    
    func didRequestPreviousTextField(_ textField: FLCNumberTextField) {
        guard let targetTextFieldIndex = flcTextFields.firstIndex(where: { $0 == textField }), targetTextFieldIndex > 0 else { return }
        let _ = flcTextFields[targetTextFieldIndex - 1].becomeFirstResponder()
    }
}

extension FLCCargoParametersView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let imageName = textAttachment.image, imageName.description.contains("info.circle") {
            HapticManager.addHaptic(style: .light)
            
           let iconPosition = textView.getIconAttachmentPosition(for: characterRange)
            guard !tipView.isShowing else { return false }
            tipView.showTipOnMainThread(withText: "Мы - лицензированный таможенный брокер, с собственным отделом таможенного оформления.", in: self, target: textView, trianglePosition: iconPosition)
            return false
        }
        return true
    }
}
