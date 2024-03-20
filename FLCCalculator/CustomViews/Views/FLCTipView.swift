import UIKit

class FLCTipView: UIView {
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    private let closeButton = UIButton()
    private let textLabel = FLCSubtitleLabel(color: .label.withAlphaComponent(0.7), textAlignment: .left)
    
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
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        
        backgroundColor = .label.withAlphaComponent(0.2)
        
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 6.0
        layer.masksToBounds = false
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
            tip.topAnchor.constraint(equalTo: target.bottomAnchor, constant: 15),
            tip.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            tip.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    static func showTip(withText: String, in view: UIView, target: UIView) {
        let tip = FLCTipView()
        tip.textLabel.text = withText
        configureTip(tip: tip, in: view, target: target)
    }
    
    @objc private func closeButtonTapped() {
        HapticManager.addHaptic(style: .light)
    }
}
