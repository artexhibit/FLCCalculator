import UIKit

class FLCTransportParametersView: FLCCalculationView {
    
    let countryPickerButton = FLCListPickerButton(placeholderText: "Страна Отправления")
    let deliveryTypePickerButton = FLCListPickerButton(placeholderText: "Условия Поставки")
    let departurePickerButton = FLCListPickerButton(placeholderText: "Пункт отправления")
    let destinationPickerButton = FLCListPickerButton(placeholderText: "Пункт назначения")
    var flcListPickerButtons = [FLCListPickerButton]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTitleLabel()
        configureCountryPickerButton()
        configureDeliveryTypePickerButton()
        configureDeparturePickerButton()
        configureDestinationPickerButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(countryPickerButton, deliveryTypePickerButton, departurePickerButton, destinationPickerButton)
        flcListPickerButtons.append(contentsOf: [deliveryTypePickerButton, departurePickerButton, destinationPickerButton])
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
    
    private func configureDeparturePickerButton() {
        departurePickerButton.delegate = self
        departurePickerButton.setDisabled()
        
        NSLayoutConstraint.activate([
            departurePickerButton.topAnchor.constraint(equalTo: deliveryTypePickerButton.bottomAnchor, constant: padding),
            departurePickerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            departurePickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            departurePickerButton.heightAnchor.constraint(equalTo: departurePickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
    
    private func configureDestinationPickerButton() {
        destinationPickerButton.delegate = self
        destinationPickerButton.setDisabled()
        
        NSLayoutConstraint.activate([
            destinationPickerButton.topAnchor.constraint(equalTo: departurePickerButton.bottomAnchor, constant: padding),
            destinationPickerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            destinationPickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            destinationPickerButton.heightAnchor.constraint(equalTo: destinationPickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
}

extension FLCTransportParametersView: FLCListPickerDelegate {
    func didSelectItem(pickedItem: String, parentButton: FLCListPickerButton) {
  
        switch parentButton {
        case departurePickerButton:
            if parentButton.titleIsEmpty { delegate?.didEnterRequiredInfo() }
            departurePickerButton.set(title: pickedItem)
        default:
            break
        }
    }
    
    func didClosePickerView(parentButton: FLCListPickerButton) {
        
        switch parentButton {
        case departurePickerButton:
            if departurePickerButton.titleLabel?.text?.isEmpty ?? true {
                departurePickerButton.smallLabelView.returnSmallLabelToIdentity()
            }
        default:
            break
        }
    }
}
