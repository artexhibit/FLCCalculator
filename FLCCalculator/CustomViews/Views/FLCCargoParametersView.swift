import UIKit

class FLCCargoParametersView: UIView {
    
    let padding: CGFloat = 15
    let weightTextField = FLCNumberTextField(placeholderText: "Вес груза, кг")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureWeightTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemBackground
        self.addSubview(weightTextField)
    }
    
    private func configureWeightTextField() {
        
        NSLayoutConstraint.activate([
            weightTextField.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            weightTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            weightTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            weightTextField.heightAnchor.constraint(equalTo: weightTextField.widthAnchor, multiplier: 0.31/2)
        ])
    }
}
