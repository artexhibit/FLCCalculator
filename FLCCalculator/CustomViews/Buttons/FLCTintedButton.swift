import UIKit

protocol FLCTintedButtonDelegate: AnyObject {
    func didTapButton(_ button: FLCTintedButton)
}

class FLCTintedButton: UIButton {
    
    weak var delegate: FLCTintedButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, title: String, systemImageName: String, size: UIButton.Configuration.Size) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImageName: systemImageName, size: size)
    }
    
    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .large
        
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    final func set(color: UIColor, title: String, systemImageName: String, size: UIButton.Configuration.Size) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title
        configuration?.buttonSize = size
        
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
    
    @objc private func buttonTapped() {
        HapticManager.addHaptic(style: .light)
        delegate?.didTapButton(self)
    }
}
