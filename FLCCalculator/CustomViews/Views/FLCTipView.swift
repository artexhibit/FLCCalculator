import UIKit

class FLCTipView: UIView {
    
    private let triangleView = UIView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    private let closeButton = UIButton()
    private let textLabel = FLCSubtitleLabel(color: .label.withAlphaComponent(0.7), textAlignment: .left)
    private var tipPosition: FLCTipPosition = .bottom
    var isShowing = false
    
    var triangleLeadingConstraint: NSLayoutConstraint!
    var triangleVerticalConstraint: NSLayoutConstraint!
    
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
        configureTriangle(with: tipPosition)
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(triangleView, blurView)
        
        backgroundColor = .label.withAlphaComponent(0.5)
        transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        alpha = 0
        
        layer.cornerRadius = 17
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 6.0
        layer.masksToBounds = false
    }
    
    private func configureTriangle(with tipPosition: FLCTipPosition) {
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        triangleView.backgroundColor = .clear
        
        triangleView.addSubview(addBlurToTriangle(with: tipPosition))
        
        if let triangleVerticalConstraint { triangleVerticalConstraint.isActive = false }
        triangleLeadingConstraint = triangleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 137)
        
        switch tipPosition {
        case .top:
            triangleVerticalConstraint = triangleView.topAnchor.constraint(equalTo: bottomAnchor)
        case .bottom:
            triangleVerticalConstraint = triangleView.bottomAnchor.constraint(equalTo: topAnchor)
        }
        
        NSLayoutConstraint.activate([
            triangleVerticalConstraint,
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
    
    private func configureTip(tip: FLCTipView, in view: UIView, target: UIView, position: FLCTipPosition) {
        view.addSubview(tip)
        
        switch position {
        case .top:
            tip.bottomAnchor.constraint(equalTo: target.topAnchor, constant: -18).isActive = true
        case .bottom:
            tip.topAnchor.constraint(equalTo: target.bottomAnchor, constant: 18).isActive = true
        }
        
        NSLayoutConstraint.activate([
            tip.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            tip.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func showTipOnMainThread(withText: String, in view: UIView, target: UIView, trianglePosition: CGFloat) {
        DispatchQueue.main.async {
            let position = self.setTipPosition(in: view, target: target)
            
            self.setTrianglePosition(position: trianglePosition)
            self.isShowing = true
            self.textLabel.text = withText
            self.tipPosition = position
            self.configureTip(tip: self, in: view, target: target, position: position)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 2, options: .curveEaseOut) {
                self.alpha = 1.0
                self.transform = .identity
            }
        }
    }
    
    private func setTipPosition(in view: UIView, target: UIView) -> FLCTipPosition {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let tipHeight = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + 18
        let activeWindow = view.window?.windowScene?.windows.first { $0.isKeyWindow }
        let targetFrameInWindow = target.convert(target.bounds, to: activeWindow)
        let safeAreaVerticalInsets = (activeWindow?.safeAreaInsets.bottom ?? 0) + (activeWindow?.safeAreaInsets.top ?? 0)
        let spaceBelowTarget = (activeWindow?.frame.maxY ?? 0) - targetFrameInWindow.maxY - safeAreaVerticalInsets
    
        return tipHeight > spaceBelowTarget ? .top : .bottom
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
    
    private func setTrianglePosition(position: CGFloat) {
        layoutIfNeeded()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let adjustmentWidth = (screenWidth - (screenWidth * 0.9)) / 2
        let finalPosition = position - adjustmentWidth
        
        if finalPosition < 13 {
            triangleLeadingConstraint.constant = 13
        } else if finalPosition > screenWidth * 0.8 {
            triangleLeadingConstraint.constant = screenWidth * 0.8
        } else {
            triangleLeadingConstraint.constant = finalPosition
        }
        triangleLeadingConstraint.isActive = true
    }
    
    private func addTriangle(height: CGFloat, tipPosition: FLCTipPosition) -> CGPath {
        let path = CGMutablePath()
        var point1, point2, point3: CGPoint
        
        switch tipPosition {
        case .bottom:
            point1 = CGPoint(x: height/2, y: 0)
            point2 = CGPoint(x: height, y: height)
            point3 = CGPoint(x: 0, y: height)
            
        case .top:
            point1 = CGPoint(x: height/2, y: height)
            point2 = CGPoint(x: height, y: 0)
            point3 = CGPoint(x: 0, y: 0)
        }
        path.move(to: point3)
        path.addArc(tangent1End: point1, tangent2End: point2, radius: 5)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: 0)
        path.addArc(tangent1End: point3, tangent2End: point1, radius: 0)
        
        path.closeSubpath()
        return path
    }
    
    private func addBlurToTriangle(with tipPosition: FLCTipPosition) -> UIVisualEffectView {
        let alpha = self.traitCollection.userInterfaceStyle == .dark ? 0.06 : 0.04
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = addTriangle(height: triangleView.frame.height, tipPosition: tipPosition)
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blurEffectView.frame = bounds
        blurEffectView.contentView.backgroundColor = .label.withAlphaComponent(alpha)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.mask = maskLayer
        return blurEffectView
    }
    
    @objc private func closeButtonTapped() {
        HapticManager.addHaptic(style: .light)
        hideTipOnMainThread()
    }
}
