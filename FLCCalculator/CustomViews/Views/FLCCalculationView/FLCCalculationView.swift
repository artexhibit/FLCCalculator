import UIKit

protocol FLCCalculationViewDelegate: AnyObject {
    func didEnterRequiredInfo()
    func didTapListPickerButton(_ button: FLCListPickerButton)
    func didTapFLCButton(_ button: FLCButton)
}

class FLCCalculationView: UIView {
    
    let padding: CGFloat = 15
    let titleLabel = FLCTitleLabel(color: .label, textAlignment: .left)
    
    weak var delegate: FLCCalculationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
}

extension FLCCalculationView: FLCListPickerButtonDelegate {
    func didTapButton(_ button: FLCListPickerButton) { delegate?.didTapListPickerButton(button) }
}

extension FLCCargoParametersView: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) { delegate?.didTapFLCButton(button) }
}
