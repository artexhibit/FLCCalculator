import UIKit

class FLCTransportParametersView: FLCCalculationView {
    
    let countryPickerButton = FLCListPickerButton(placeholderText: "Страна Отправления")
    let deliveryTypePickerButton = FLCListPickerButton(placeholderText: "Условия Поставки")
    let departurePickerButton = FLCListPickerButton(placeholderText: "Пункт отправления")
    let destinationPickerButton = FLCListPickerButton(placeholderText: "Пункт назначения")
    let calculateButton = FLCButton(color: .flcOrange, title: "Рассчитать")
    let returnToPreviousViewButton = FLCTextButton(title: "вернуться назад")
    
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
        configureCalculateButton()
        configureReturnToPreviousViewButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil { if calculateButton.isShining { calculateButton.addShineEffect() } }
    }
    
    private func configure() {
        addSubviews(countryPickerButton, deliveryTypePickerButton, departurePickerButton, destinationPickerButton, calculateButton, returnToPreviousViewButton)
        flcListPickerButtons.append(contentsOf: [deliveryTypePickerButton, departurePickerButton, destinationPickerButton])
        flcListPickerButtons.forEach { listPickerButtonsWithTitle[$0] = false }
    }
    
    private func configureTitleLabel() { titleLabel.text = "Осталось заполнить параметры перевозки" }
    
    private func configureCountryPickerButton() {
        countryPickerButton.delegate = self
        
        NSLayoutConstraint.activate([
            countryPickerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding * 3.5),
            countryPickerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            countryPickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            countryPickerButton.heightAnchor.constraint(equalTo: countryPickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
    
    private func configureDeliveryTypePickerButton() {
        deliveryTypePickerButton.delegate = self
        deliveryTypePickerButton.setDisabled()
        deliveryTypeTopContraint = deliveryTypePickerButton.topAnchor.constraint(equalTo: countryPickerButton.bottomAnchor, constant: padding * 4)
        
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
    
    private func configureCalculateButton() {
        calculateButton.delegate = self
        
        let widthConstraint = calculateButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
        let heightConstraint = calculateButton.heightAnchor.constraint(equalTo: calculateButton.widthAnchor, multiplier: 1/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            calculateButton.topAnchor.constraint(equalTo: destinationPickerButton.bottomAnchor, constant: padding * 5),
            calculateButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            widthConstraint, heightConstraint,
            
            calculateButton.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            calculateButton.widthAnchor.constraint(lessThanOrEqualToConstant: 450)
        ])
    }
    
    private func configureReturnToPreviousViewButton() {
        returnToPreviousViewButton.delegate = self
        
        NSLayoutConstraint.activate([
            returnToPreviousViewButton.topAnchor.constraint(equalTo: calculateButton.bottomAnchor),
            returnToPreviousViewButton.centerXAnchor.constraint(equalTo: calculateButton.centerXAnchor)
        ])
    }
    
    func removeExtraTopPaddingBetweenFirstButtons() {
        deliveryTypeTopContraint.constant = padding
        UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
    }
}

extension FLCTransportParametersView: FLCPickerDelegate {
    func didSelectItem(pickedItem: FLCPickerItem, triggerButton: FLCListPickerButton) {
        if countryPickerButton.titleIsEmpty { delegate?.didEnterRequiredInfo() }
        
        UIView.performWithoutAnimation {
            if triggerButton.showingTitle.contains(FLCCities.istanbul.rawValue) {
                CalculationHelper.setTitle(for: triggerButton, pickedItem: pickedItem, addString: ", \(FLCCities.istanbul.rawValue)")
                return
            }
            if pickedItem.canBeAddedAsTitle {
                CalculationHelper.setTitle(for: triggerButton, pickedItem: pickedItem)
            } else {
                CalculationHelper.setTitle(for: triggerButton, pickedItem: pickedItem, title: "\(triggerButton.showingTitle) +1")
            }
        }
        delegate?.didSelectItem(pickedItem: pickedItem, triggerButton: triggerButton)
    }
    
    func didClosePickerView(parentButton: FLCListPickerButton) {}
}
