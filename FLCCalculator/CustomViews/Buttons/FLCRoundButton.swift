import UIKit

protocol FLCRoundButtonDelegate: AnyObject {
    func didTapButton(_ button: FLCRoundButton)
}

class FLCRoundButton: UIButton {
    
    weak var delegate: FLCRoundButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage, tint: UIColor) {
        self.init(frame: .zero)
        configuration?.image = image
        configuration?.baseBackgroundColor = tint
        configuration?.baseForegroundColor = tint
    }
    
    private func configure(size: Double = 0) {
        configuration = .tinted()
        configuration?.cornerStyle = .capsule
        
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        HapticManager.addHaptic(style: .light)
        delegate?.didTapButton(self)
    }
}
