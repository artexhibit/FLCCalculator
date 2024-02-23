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

extension FLCCargoParametersView: FLCListPickerButtonDelegate {
    func buttonTapped(_ button: FLCListPickerButton) {
    }
}
