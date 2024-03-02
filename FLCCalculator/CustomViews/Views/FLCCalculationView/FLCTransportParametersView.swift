import UIKit

class FLCTransportParametersView: FLCCalculationView {
    
    let countryPickerButton = FLCListPickerButton(placeholderText: "Страна Отправления")
    let deliveryTypePickerButton = FLCListPickerButton(placeholderText: "Условия Поставки")
    var flcListPickerButtons = [FLCListPickerButton]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTitleLabel()
        configureCountryPickerButton()
        configureDeliveryTypePickerButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(countryPickerButton, deliveryTypePickerButton)
        flcListPickerButtons.append(contentsOf: [deliveryTypePickerButton])
    }
    
    private func configureTitleLabel() { titleLabel.text = "Осталось заполнить параметры перевозки" }
    
    private func configureCountryPickerButton() {
        countryPickerButton.delegate = self
        countryPickerButton.menu = countryPickerButton.configureUIMenu(with: CalculationData.countriesOptions)
        countryPickerButton.showsMenuAsPrimaryAction = true
        
        NSLayoutConstraint.activate([
            countryPickerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding * 3),
            countryPickerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            countryPickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            countryPickerButton.heightAnchor.constraint(equalTo: countryPickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
    
    private func configureDeliveryTypePickerButton() {
        deliveryTypePickerButton.delegate = self
        deliveryTypePickerButton.menu = deliveryTypePickerButton.configureUIMenu(with: CalculationData.chinaDeliveryTypes)
        deliveryTypePickerButton.showsMenuAsPrimaryAction = false
        deliveryTypePickerButton.setDisabled()
        
        NSLayoutConstraint.activate([
            deliveryTypePickerButton.topAnchor.constraint(equalTo: countryPickerButton.bottomAnchor, constant: padding * 2),
            deliveryTypePickerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            deliveryTypePickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            deliveryTypePickerButton.heightAnchor.constraint(equalTo: deliveryTypePickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
}
