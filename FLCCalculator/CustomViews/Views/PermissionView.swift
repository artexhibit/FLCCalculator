import UIKit

class PermissionView: UIView {
    
    private let padding: CGFloat = 10
    
    private let iconView = FLCIconView()
    private let textContentView = UIView()
    private let titleLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 20, weight: .bold)
    private let subtitleLabel = FLCSubtitleLabel(color: .lightGray, textAlignment: .left, textStyle: .callout)
    private let permissionButton = FLCTintedButton(color: .flcOrange, title: "Разрешить", cornerStyle: .capsule)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureIconView()
        configureTextContentView()
        configureTitleLabel()
        configureSubtitleLabel()
        configurePermissionButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(item: PermissionItem) {
        self.init(frame: .zero)
        iconView.set(image: item.icon, backgroundColor: item.iconBackgroundColor)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
    
    private func configure() {
        addSubviews(iconView, textContentView, permissionButton)
        backgroundColor = .systemGray6.withAlphaComponent(0.5)
    }
    
    private func configureIconView() {
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: padding * 1.5),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding * 1.5),
            iconView.widthAnchor.constraint(equalToConstant: 35),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
        ])
    }
    
    private func configureTextContentView() {
        textContentView.translatesAutoresizingMaskIntoConstraints = false
        textContentView.addSubviews(titleLabel, subtitleLabel)
        
        NSLayoutConstraint.activate([
            textContentView.topAnchor.constraint(equalTo: topAnchor, constant: padding * 1.3),
            textContentView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: padding),
            textContentView.trailingAnchor.constraint(equalTo: permissionButton.leadingAnchor, constant: -padding * 1.5),
            textContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: textContentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: textContentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: textContentView.trailingAnchor)
        ])
    }
    
    private func configureSubtitleLabel() {
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: textContentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: textContentView.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: textContentView.bottomAnchor)
        ])
    }
    
    private func configurePermissionButton() {
        permissionButton.delegate = self
        
        NSLayoutConstraint.activate([
            permissionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            permissionButton.centerYAnchor.constraint(equalTo: textContentView.centerYAnchor, constant: -padding)
        ])
    }
}

extension PermissionView: FLCTintedButtonDelegate {
    func didTapButton(_ button: FLCTintedButton) {
        print("hello")
    }
}
