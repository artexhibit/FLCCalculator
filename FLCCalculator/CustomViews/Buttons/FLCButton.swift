import UIKit

protocol FLCButtonDelegate: AnyObject {
    func didTapButton(_ button: FLCButton)
}

final class FLCButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    var isShining = false
    
    weak var delegate: FLCButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, title: String, subtitle: String? = nil, systemImageName: String? = nil) {
        self.init(frame: .zero)
        set(color: color, title: title, subtitle: subtitle, systemImageName: systemImageName)
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
        tintAdjustmentMode = .normal
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        NotificationsManager.notifyWhenInForeground(self, selector: #selector(restartShineEffect))
    }
        
    func set(color: UIColor, title: String, subtitle: String?, systemImageName: String?, titleFontSize: CGFloat = 20) {
        configuration?.baseBackgroundColor = color
        configuration?.title = title
        configuration?.titleAlignment = .center
        configuration?.subtitle = subtitle
        
        if let imageName = systemImageName { configuration?.image = UIImage(systemName: imageName) }
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
        configuration?.setupCustomFont(ofSize: titleFontSize)
    }
    
    @objc private func buttonTapped() {
        HapticManager.addHaptic(style: .light)
        delegate?.didTapButton(self)
    }
    
    @objc private func restartShineEffect() { if isShining { self.addShineEffect() } }
    
    func addShineEffect() {        
        gradientLayer.removeAnimation(forKey: "shineAnimation")
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 10
        
        gradientLayer.colors = [
            UIColor.flcOrange.withAlphaComponent(0.01).cgColor,
            UIColor.white.withAlphaComponent(0.7).cgColor,
            UIColor.flcOrange.withAlphaComponent(0.01).cgColor
        ]
        gradientLayer.locations = [0.4, 0.5, 0.6]
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = 1
        animation.duration = 1.5
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.animations = [animation]
        group.duration = 4.5
        group.repeatCount = .infinity
        
        isShining = true
        gradientLayer.add(group, forKey: "shineAnimation")
    }
    
    func removeShineEffect() {
        gradientLayer.removeAnimation(forKey: "shineAnimation")
        
        gradientLayer.colors = nil
        gradientLayer.locations = nil
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        isShining = false
    }
}
