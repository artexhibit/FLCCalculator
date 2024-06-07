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
    
    convenience init(color: UIColor, title: String? = "", titleFontSize: CGFloat = 15, systemImageName: String? = nil, size: UIButton.Configuration.Size? = nil, cornerStyle: UIButton.Configuration.CornerStyle = .medium) {
        self.init(frame: .zero)
        set(color: color, title: title, titleFontSize: titleFontSize, systemImageName: systemImageName, size: size, cornerStyle: cornerStyle)
    }
    
    private func configure() {
        configuration = .tinted()
        
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    final func set(color: UIColor, title: String?, titleFontSize: CGFloat, systemImageName: String? = nil, size: UIButton.Configuration.Size?, cornerStyle: UIButton.Configuration.CornerStyle) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title
        configuration?.cornerStyle = cornerStyle
        configuration?.setupCustomFont(ofSize: titleFontSize)
        
        if size != nil { configuration?.buttonSize = size ?? .small }
        if systemImageName != nil { configuration?.image = UIImage(systemName: systemImageName ?? "") }
        
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
    
    @objc private func buttonTapped() {
        HapticManager.addHaptic(style: .light)
        delegate?.didTapButton(self)
    }
}
