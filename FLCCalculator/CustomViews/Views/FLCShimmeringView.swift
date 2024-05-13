import UIKit

class FLCShimmeringView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    private var isShimmering = false
    private var insets: (dx: CGFloat, dy: CGFloat) = (-3, 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(frame: CGRect, insets: (dx: CGFloat, dy: CGFloat) = (-3, 1)) {
        self.init(frame: frame)
        self.insets = insets
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientLayerAnimation(insets: insets)
        NotificationsManager.notifyWhenInForeground(self, selector: #selector(restartShimmerEffect))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.layer.addSublayer(gradientLayer)
        self.isUserInteractionEnabled = true
    }
    
    private func configureGradient() {
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.3, 0.5, 0.7]
        gradientLayer.cornerRadius = 10
        
        gradientLayer.colors = [
            UIColor.flcGradientColorOne.cgColor,
            UIColor.flcGradientColorTwo.cgColor,
            UIColor.flcGradientColorOne.cgColor
        ]
    }
    
    func getIsShimmering() -> Bool { return self.isShimmering }
    func addShimmerAnimation() {
        configureGradient()
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-0.7, -0.5, -0.3]
        animation.toValue = [1.3, 1.5, 1.7]
        animation.repeatCount = .infinity
        animation.duration = 1.8
        animation.repeatCount = 1
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.animations = [animation]
        group.duration = 2.5
        group.repeatCount = .infinity
        
        gradientLayer.add(group, forKey: "shimmer")
        isShimmering = true
    }
    
    func removeShimmerAnimation(delay: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.isShimmering = false
            self.gradientLayer.removeAnimation(forKey: "shimmer")
            
            self.gradientLayer.colors = nil
            self.gradientLayer.locations = nil
            self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        }
    }
    
    private func setupGradientLayerAnimation(insets: (dx: CGFloat, dy: CGFloat)) {
        self.layoutIfNeeded()
        gradientLayer.frame = self.bounds.insetBy(dx: insets.dx, dy: insets.dy)
    }
    @objc private func restartShimmerEffect() { if isShimmering { addShimmerAnimation() } }
}
