import UIKit

class FLCTipView: UIView {
    
    private let triangleView = UIView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    private let closeButton = UIButton()
    private let textLabel = FLCSubtitleLabel(color: .label.withAlphaComponent(0.85), textAlignment: .left)
    
    private let padding: CGFloat = 15

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureBlurView()
        configureCloseButton()
        configureTextLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureTriangle()
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(triangleView, blurView)
        
        backgroundColor = .label.withAlphaComponent(0.5)
        
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 6.0
        layer.masksToBounds = false
    }
    
    private func configureTriangle() {
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        triangleView.backgroundColor = .clear
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = createTriangle(height: triangleView.frame.height)
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blurEffectView.frame = bounds
        blurEffectView.contentView.backgroundColor = .label.withAlphaComponent(0.04)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.mask = maskLayer
        
        triangleView.addSubview(blurEffectView)
        
        NSLayoutConstraint.activate([
            triangleView.bottomAnchor.constraint(equalTo: topAnchor),
            triangleView.widthAnchor.constraint(equalToConstant: 25),
            triangleView.heightAnchor.constraint(equalToConstant: 21),
            triangleView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -45)
        ])
    }
    
    private func configureBlurView() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.pinToEdges(of: self)
        blurView.contentView.addSubviews(closeButton, textLabel)
        
        blurView.layer.masksToBounds = true
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 15
    }
    
    private func configureCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.configuration = .plain()
        closeButton.configuration?.image = Icons.xmark
        closeButton.configuration?.baseBackgroundColor = .clear
        closeButton.configuration?.baseForegroundColor = .lightGray
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant: padding),
            closeButton.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -padding),
            closeButton.widthAnchor.constraint(equalToConstant: 15),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
        ])
    }
    
    private func configureTextLabel() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: padding),
            textLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: padding),
            textLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -padding),
            textLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -padding)
        ])
    }
    
    private static func configureTip(tip: FLCTipView, in view: UIView, target: UIView) {
        view.addSubview(tip)
        
        NSLayoutConstraint.activate([
            tip.topAnchor.constraint(equalTo: target.bottomAnchor, constant: 23),
            tip.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            tip.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    static func showTip(withText: String, in view: UIView, target: UIView) {
        let tip = FLCTipView()
        tip.textLabel.text = withText
        configureTip(tip: tip, in: view, target: target)
    }
    
    private func createTriangle(height: CGFloat) -> CGPath {
        let point1 = CGPoint(x: height/2, y:0)
        let point2 = CGPoint(x: height , y: height)
        let point3 =  CGPoint(x: 0, y: height)
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: height))
        path.addArc(tangent1End: point1, tangent2End: point2, radius: 3)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: 0)
        path.addArc(tangent1End: point3, tangent2End: point1, radius: 0)
        path.closeSubpath()
        return path
    }
    
    @objc private func closeButtonTapped() {
        HapticManager.addHaptic(style: .light)
    }
}
