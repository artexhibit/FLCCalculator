import UIKit

protocol FLCButtonDelegate: AnyObject {
    func didTapButton(_ button: FLCButton)
}

class FLCButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    
    weak var delegate: FLCButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, title: String, systemImageName: String) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImageName: systemImageName)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    private func configure() {
        configuration = .filled()
        configuration?.cornerStyle = .medium
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.addSublayer(gradientLayer)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    final func set(color: UIColor, title: String, systemImageName: String) {
        configuration?.baseBackgroundColor = color
        configuration?.title = title
        
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
    
    @objc private func buttonTapped() {
        FeedbackGeneratorManager.addHaptic(style: .light)
        delegate?.didTapButton(self)
    }
    
    func addShineEffect() {
        let gradientColorClear = UIColor.accent.withAlphaComponent(0.4).cgColor
        let gradientColorWhite = UIColor.white.withAlphaComponent(0.5).cgColor
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 14
        
        gradientLayer.colors = [gradientColorClear, gradientColorWhite, gradientColorClear]
        gradientLayer.locations = [0.3, 0.5, 0.7]
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-0.8, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = 1
        animation.duration = 2
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.animations = [animation]
        group.duration = 6
        group.repeatCount = .infinity
        
        gradientLayer.add(group, forKey: "glowAnimation")
    }
}
