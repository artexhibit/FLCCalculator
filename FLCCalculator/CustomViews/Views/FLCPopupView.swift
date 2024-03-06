import UIKit

class FLCPopupView: UIView {
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    private let iconView = UIImageView()
    private let messageLabel = FLCSubtitleLabel(color: .red, textAlignment: .center)
    private let padding: CGFloat = 10
    private static var showingPopup: FLCPopupView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureBlurView()
        configureIconView()
        configureMessageLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .accent.withAlphaComponent(0.2)
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.opacity = 0
        addSubview(blurView)
    }
    
    private func configureBlurView() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.pinToEdges(of: self)
        blurView.contentView.addSubviews(iconView, messageLabel)
    }
    
    private func configureIconView() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: padding + 5),
            iconView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            iconView.heightAnchor.constraint(equalTo: blurView.heightAnchor, multiplier: 0.45),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor)
        ])
    }
    
    private func configureMessageLabel() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: blurView.topAnchor, constant: padding * 1.5),
            messageLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -padding * 1.5)
        ])
    }
    
    private func set(with style: FLCPopupViewStyle) {
        switch style {
        case .error:
            iconView.tintColor = .red
            messageLabel.textColor = .red
        case .normal:
            iconView.tintColor = .label
            messageLabel.textColor = .label
        }
    }
    
    private func configureInWindow(with position: FLCPopupViewPosition) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        let positionAnchor: NSLayoutConstraint
        
        window.addSubview(self)
        
        switch position {
        case .top:
            positionAnchor = topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: padding * 5)
        case .bottom:
            positionAnchor = topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -padding * 15)
        }
        
        NSLayoutConstraint.activate([
            positionAnchor,
            centerXAnchor.constraint(equalTo: window.centerXAnchor),
            widthAnchor.constraint(equalTo: window.widthAnchor, multiplier: 0.7)
        ])
    }
    
    static func showOnMainThread(systemImage: String, title: String, style: FLCPopupViewStyle = .normal, position: FLCPopupViewPosition = .bottom) {
        DispatchQueue.main.async {
            guard let showingPopup = showingPopup else {
                showNewPopup(systemImage: systemImage, title: title, style: style, position: position)
                return
            }
            if showingPopup.messageLabel.text != title {
                remove(popup: showingPopup) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { showNewPopup(systemImage: systemImage, title: title, style: style, position: position) }
                }
            }
        }
    }
    
    private static func showNewPopup(systemImage: String, title: String, style: FLCPopupViewStyle, position: FLCPopupViewPosition) {
        let popup = FLCPopupView()
        popup.iconView.image = UIImage(systemName: systemImage)
        popup.messageLabel.text = title
        popup.set(with: style)
        popup.configureInWindow(with: position)
        showingPopup = popup

        UIView.animate(withDuration: 0.3) {
            popup.layer.opacity = 1
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { remove(popup: popup) }
        }
    }
    
    private static func remove(popup: FLCPopupView, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2) {
            popup.layer.opacity = 0
        } completion: { _ in
            showingPopup = nil
            popup.removeFromSuperview()
            completion?()
        }
    }
}
