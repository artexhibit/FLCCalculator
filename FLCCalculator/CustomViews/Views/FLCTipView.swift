import UIKit

class FLCTipView: UIView {
    
    private let triangleView = UIView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    private let closeButton = UIButton()
    private let textLabel = FLCSubtitleLabel(color: .label.withAlphaComponent(0.7), textAlignment: .left)
    var isShowing = false
    
    var triangleLeadingConstraint: NSLayoutConstraint!
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
        transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        alpha = 0
        
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
        triangleView.addSubview(addBlurToTriangle())
        
        triangleLeadingConstraint = triangleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 137)
        
        NSLayoutConstraint.activate([
            triangleView.bottomAnchor.constraint(equalTo: topAnchor),
            triangleView.widthAnchor.constraint(equalToConstant: 22),
            triangleView.heightAnchor.constraint(equalToConstant: 22)
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
        
        closeButton.setImage(Icons.xmark, for: .normal)
        closeButton.tintColor = .gray
        closeButton.contentVerticalAlignment = .fill
        closeButton.contentHorizontalAlignment = .fill
        closeButton.imageView?.contentMode = .scaleAspectFit
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant: padding / 1.5),
            closeButton.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -padding / 1.5),
            closeButton.widthAnchor.constraint(equalToConstant: 18),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
        ])
    }
    
    private func configureTextLabel() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: padding / 2),
            textLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: padding),
            textLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -padding),
            textLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureTip(tip: FLCTipView, in view: UIView, target: UIView) {
        view.addSubview(tip)
        
        NSLayoutConstraint.activate([
            tip.topAnchor.constraint(equalTo: target.bottomAnchor, constant: 18),
            tip.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            tip.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func showTipOnMainThread(withText: String, in view: UIView, target: UIView, trianglePosition: CGFloat) {
        DispatchQueue.main.async {
            self.isShowing = true
            self.textLabel.text = withText
            self.configureTrianglePosition(position: trianglePosition)
            
            self.configureTip(tip: self, in: view, target: target)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 2, options: .curveEaseOut) {
                self.alpha = 1.0
                self.transform = .identity
            }
        }
    }
    
    func hideTipOnMainThread() {
        DispatchQueue.main.async {
            self.isShowing = false
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 2, options: .curveEaseOut) {
                self.alpha = 0.0
                self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            } completion: { _ in
                self.removeFromSuperview()
            }
        }
    }
    
    private func configureTrianglePosition(position: CGFloat) {
        layoutIfNeeded()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let adjustmentWidth = (screenWidth - (screenWidth * 0.9)) / 2
        
        triangleLeadingConstraint.constant = position - adjustmentWidth
        triangleLeadingConstraint.isActive = true
    }
    
    private func addTriangle(height: CGFloat) -> CGPath {
        let point1 = CGPoint(x: height/2, y:0)
        let point2 = CGPoint(x: height , y: height)
        let point3 =  CGPoint(x: 0, y: height)
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: height))
        path.addArc(tangent1End: point1, tangent2End: point2, radius: 5)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: 0)
        path.addArc(tangent1End: point3, tangent2End: point1, radius: 0)
        path.closeSubpath()
        return path
    }
    
    private func addBlurToTriangle() -> UIVisualEffectView {
        let maskLayer = CAShapeLayer()
        maskLayer.path = addTriangle(height: triangleView.frame.height)
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blurEffectView.frame = bounds
        blurEffectView.contentView.backgroundColor = .label.withAlphaComponent(0.04)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.mask = maskLayer
        return blurEffectView
    }
    
    @objc private func closeButtonTapped() {
        HapticManager.addHaptic(style: .light)
        hideTipOnMainThread()
    }
}
