import UIKit

class FLCCargoParametersView: UIView {
    
    private let padding: CGFloat = 15
    private let titleLabel = FLCTitleLabel(color: .label, textAlignment: .left)
    private let stackView = UIStackView()
    private let weightTextField = FLCNumberTextField(placeholderText: "Вес груза, кг")
    private let volumeTextField = FLCNumberTextField(placeholderText: "Объём, м3")
    private let cargoTypePickerButton = FLCListPickerButton(placeholderText: "Тип груза")
    private let invoiceAmountTextField = FLCNumberTextField(placeholderText: "Сумма по инвойсу")
    private let invoiceCurrencyPickerButton = FLCListPickerButton(placeholderText: "Валюта")
    private let customsClearanceLabel = FLCSubtitleLabel(color: .label, textAlignment: .left)
    private let customsClearanceSwitch = UISwitch()
    let nextButton = FLCButton(color: .accent, title: "Далее", systemImageName: "arrowshape.forward.fill")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTitleLabel()
        configureStackView()
        configureCargoTypePickerButton()
        configureInvoiceAmountTextField()
        configureInvoiceCurrencyPickerButton()
        configureCustomsClearanceLabel()
        configureCustomsClearanceSwitch()
        configureNextButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(titleLabel, stackView, cargoTypePickerButton, invoiceAmountTextField, invoiceCurrencyPickerButton, customsClearanceLabel, customsClearanceSwitch, nextButton)
        backgroundColor = .systemBackground
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "Расскажите нам о вашем грузе"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.addArrangedSubview(weightTextField)
        stackView.addArrangedSubview(volumeTextField)
        
        weightTextField.delegate = self
        volumeTextField.delegate = self
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding * 3),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalTo: weightTextField.widthAnchor, multiplier: 0.31)
        ])
    }
    
    private func configureCargoTypePickerButton() {
        cargoTypePickerButton.delegate = self
        
        NSLayoutConstraint.activate([
            cargoTypePickerButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            cargoTypePickerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            cargoTypePickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            cargoTypePickerButton.heightAnchor.constraint(equalTo: cargoTypePickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
    
    private func configureInvoiceAmountTextField() {
        invoiceAmountTextField.delegate = self
        
        NSLayoutConstraint.activate([
            invoiceAmountTextField.topAnchor.constraint(equalTo: cargoTypePickerButton.bottomAnchor, constant: padding),
            invoiceAmountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            invoiceAmountTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            invoiceAmountTextField.heightAnchor.constraint(equalTo: cargoTypePickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
    
    private func configureInvoiceCurrencyPickerButton() {
        invoiceCurrencyPickerButton.delegate = self
        
        NSLayoutConstraint.activate([
            invoiceCurrencyPickerButton.topAnchor.constraint(equalTo: cargoTypePickerButton.bottomAnchor, constant: padding),
            invoiceCurrencyPickerButton.leadingAnchor.constraint(equalTo: invoiceAmountTextField.trailingAnchor, constant: padding / 2),
            invoiceCurrencyPickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            invoiceCurrencyPickerButton.heightAnchor.constraint(equalTo: cargoTypePickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
    
    private func configureCustomsClearanceLabel() {
        customsClearanceLabel.text = "Нужно таможенное оформление (подача ДТ, ЭЦП)"
        
        NSLayoutConstraint.activate([
            customsClearanceLabel.topAnchor.constraint(equalTo: invoiceAmountTextField.bottomAnchor, constant: padding),
            customsClearanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding * 1.5),
            customsClearanceLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
        ])
    }
    
    private func configureCustomsClearanceSwitch() {
        customsClearanceSwitch.translatesAutoresizingMaskIntoConstraints = false
        customsClearanceSwitch.onTintColor = .accent
        customsClearanceSwitch.isOn = true
        customsClearanceSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            customsClearanceSwitch.centerYAnchor.constraint(equalTo: customsClearanceLabel.centerYAnchor),
            customsClearanceSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding * 1.5)
        ])
    }
    
    private func configureNextButton() {
        let widthConstraint = nextButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
        let heightConstraint = nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor, multiplier: 1/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: customsClearanceLabel.bottomAnchor, constant: padding * 5),
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
                textField.text = textField != self.invoiceAmountTextField ? FLCNumberTextField.placeholderValue : ""
                textField.setCursorAfterTypedNumber()
            } else {
                textField.text = text
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var formatter = textField != self.invoiceAmountTextField ? NumberFormatter.getFLCNumberFormatter() : NumberFormatter.getFLCNumberFormatter(withDecimals: 0)

        let decimalSeparator = formatter.decimalSeparator ?? ""
        guard let text = textField.text else { return false }
        let separatorIndex = text.firstIndex(of: Character(formatter.decimalSeparator ?? "")) ?? text.endIndex
        let separatorPositon = text.distance(from: text.startIndex, to: separatorIndex)
  
        if string == decimalSeparator {
            if text.contains(decimalSeparator) {
                if textField.getCursorPosition() > separatorPositon { return false }
                textField.moveCursorTo(position: separatorPositon + 2)
            } else {
                textField.text = text + "\(decimalSeparator)00"
                textField.moveCursorTo(position: separatorPositon + 2)
                return false
            }
        }
   
        if (textField.getCursorPosition() > separatorPositon) && !string.isEmpty {
            let index = text.index(text.startIndex, offsetBy: textField.getCursorPosition() - 1)
            guard let charBeforeCursorRange = Range(NSRange(location: textField.getCursorPosition() - 1, length: 1), in: text) else { return false }
            
            if text[index] == Character(decimalSeparator) {
                var newText = text.replacingOccurrences(of: ",", with: ".")
                
                newText.insert(contentsOf: string, at: index)
                if newText.contains(".") { formatter = NumberFormatter.getFLCNumberFormatter() }
                textField.text = formatter.string(from: NSNumber(value: Double(newText) ?? 0)) ?? ""
                
               //textField.moveCursorTo(position: separatorPositon)
            } else {
                if string != formatter.decimalSeparator {
                    textField.text = text.replacingCharacters(in: charBeforeCursorRange, with: string)
                    textField.moveCursorTo(position: separatorPositon + 3)
                }
            }
            return false
        }
       
        if textField.getCursorPosition() - 1 == separatorPositon && string.isEmpty {
            guard let charBeforeSeparator = Range(NSRange(location: separatorPositon - 1, length: 1), in: text) else { return false }
            textField.text = text.replacingCharacters(in: charBeforeSeparator, with: "")
            textField.moveCursorTo(position: textField.getCursorPosition() - 3)
            
            if textField.text?.firstIndex(of: Character(decimalSeparator)) == textField.text?.startIndex {
                textField.text = FLCNumberTextField.placeholderValue
                textField.moveCursorTo(position: separatorPositon)
            }
            return false
        }
    
        if text == FLCNumberTextField.placeholderValue && !string.isEmpty {
            textField.text = string + text.dropFirst()
            textField.setCursorAfterTypedNumber()
            return false
        }
       
        let newText = NSString(string: text).replacingCharacters(in: range, with: string)
        let completeString = newText.replacingOccurrences(of: formatter.groupingSeparator, with: "").replacingOccurrences(of: ",", with: ".")

        guard let value = Double(completeString) else {
            textField.text = "0"
            return false
        }

        if completeString.contains(".") { formatter = NumberFormatter.getFLCNumberFormatter() }
        let formattedNumber = formatter.string(from: NSNumber(value: value)) ?? ""
        textField.text = formattedNumber
       
        var cursorOffset = range.location + string.count
        let oldNumberOfGroupingSeparators = text.filter { $0 == formatter.groupingSeparator.first }.count
        let newNumberOfGroupingSeparators = formattedNumber.filter { $0 == formatter.groupingSeparator.first }.count
        cursorOffset += (newNumberOfGroupingSeparators - oldNumberOfGroupingSeparators)
        textField.moveCursorTo(position: cursorOffset)
        
        if textField.getCursorPosition() == 0 && string.isEmpty {
            textField.moveCursorTo(position: textField.getCursorPosition() + 1)
        }
        return false
    }
}

extension FLCCargoParametersView: FLCListPickerButtonDelegate {
    func buttonTapped(_ button: FLCListPickerButton) {
    }
}
