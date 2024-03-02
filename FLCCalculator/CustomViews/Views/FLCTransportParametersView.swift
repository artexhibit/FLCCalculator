import UIKit

class FLCTransportParametersView: UIView {
    
    private let padding: CGFloat = 15
    private let titleLabel = FLCTitleLabel(color: .label, textAlignment: .left)
    let countryPickerButton = FLCListPickerButton(placeholderText: "Страна Отправления")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTitleLabel()
        configureCountryPickerButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(titleLabel, countryPickerButton)
        backgroundColor = .systemBackground
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "Осталось заполнить параметры перевозки"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
    
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
}

extension FLCTransportParametersView: FLCListPickerButtonDelegate {
    func didTapButton(_ button: FLCListPickerButton) {
        
    }
}
