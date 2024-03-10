import UIKit

class FLCTransportParametersView: FLCCalculationView {
    
    let countryPickerButton = FLCListPickerButton(placeholderText: "Страна Отправления")
    let deliveryTypePickerButton = FLCListPickerButton(placeholderText: "Условия Поставки")
    let departurePickerButton = FLCListPickerButton(placeholderText: "Пункт отправления")
    let destinationPickerButton = FLCListPickerButton(placeholderText: "Пункт назначения")
    
    var listPickerButtons = [FLCListPickerButton]()
    var listPickerButtonsWithTitle = [FLCListPickerButton: Bool]()
    private var deliveryTypeTopContraint: NSLayoutConstraint!

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
        listPickerButtons.append(contentsOf: [deliveryTypePickerButton, departurePickerButton, destinationPickerButton])
        listPickerButtons.forEach { listPickerButtonsWithTitle[$0] = false }
    }
    
    private func configureTitleLabel() { titleLabel.text = "Осталось заполнить параметры перевозки" }
    
    private func configureCountryPickerButton() {
        countryPickerButton.delegate = self
        
        NSLayoutConstraint.activate([
            countryPickerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding * 3),
            countryPickerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            countryPickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            countryPickerButton.heightAnchor.constraint(equalTo: countryPickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
    
    private func configureDeliveryTypePickerButton() {
        deliveryTypePickerButton.delegate = self
        deliveryTypePickerButton.setDisabled()
        deliveryTypeTopContraint = deliveryTypePickerButton.topAnchor.constraint(equalTo: countryPickerButton.bottomAnchor, constant: padding * 5)
        
        NSLayoutConstraint.activate([
            deliveryTypeTopContraint,
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
    
    func removeExtraTopPaddingBetweenFirstButtons() {
        deliveryTypeTopContraint.constant = padding
        UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
    }
}

extension FLCTransportParametersView: FLCPickerDelegate {
    func didSelectItem(pickedItem: String, triggerButton: FLCListPickerButton) {
        if triggerButton.titleIsEmpty { delegate?.didEnterRequiredInfo() }
        
        UIView.performWithoutAnimation {
            triggerButton.set(title: pickedItem)
            triggerButton.titleLabel?.text = pickedItem
            triggerButton.layoutIfNeeded()
        }
        delegate?.didSelectItem(triggerButton: triggerButton)
    }
    
    func didClosePickerView(parentButton: FLCListPickerButton) {}
}
