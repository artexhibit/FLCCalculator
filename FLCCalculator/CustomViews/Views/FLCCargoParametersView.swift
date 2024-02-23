import UIKit

class FLCCargoParametersView: UIView {
    
    let padding: CGFloat = 15
    let titleLabel = FLCTitleLabel(color: .label, textAlignment: .left)
    let stackView = UIStackView()
    let weightTextField = FLCNumberTextField(placeholderText: "Вес груза, кг")
    let volumeTextField = FLCNumberTextField(placeholderText: "Объём, м3")
    let cargoTypePickerButton = FLCListPickerButton(placeholderText: "Тип груза")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTitleLabel()
        configureStackView()
        configureCargoTypePickerButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(titleLabel, stackView, cargoTypePickerButton)
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
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding * 2),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalTo: weightTextField.widthAnchor, multiplier: 0.31)
        ])
    }
    
    private func configureCargoTypePickerButton() {
        NSLayoutConstraint.activate([
            cargoTypePickerButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            cargoTypePickerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            cargoTypePickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            cargoTypePickerButton.heightAnchor.constraint(equalTo: cargoTypePickerButton.widthAnchor, multiplier: 0.3/2)
        ])
    }
}
