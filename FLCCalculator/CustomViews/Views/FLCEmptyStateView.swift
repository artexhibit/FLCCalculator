import UIKit

class FLCEmptyStateView: UIView {
    
    private let placeholderImage = FLCImageView(image: UIImage(resource: .emptyStateView))
    private let titleLabel = FLCTitleLabel(color: .lightGray, textAlignment: .center)
    private let subtitleLabel = FLCSubtitleLabel(color: .lightGray, textAlignment: .center)
    private let actionButton = FLCButton(color: .flcOrange, title: "Новый расчёт", systemImageName: "plus")
    
    init(withButton: Bool = true, yValue: CGFloat = -70) {
        super.init(frame: .zero)
        configure(withButton: withButton, yValue: yValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil { actionButton.addShineEffect() }
    }
    
    private func configure(withButton: Bool, yValue: CGFloat) {
        backgroundColor = .systemBackground
        addSubviews(placeholderImage, titleLabel, subtitleLabel)
        configurePlaceholderImage(yValue: yValue)
        configureTitleLable()
        configureSubtitleLabel()
        
        if withButton {
            addSubview(actionButton)
            configureActionButton()
        }
    }
        
    private func configurePlaceholderImage(yValue: CGFloat) {
        let widthConstraint = placeholderImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65)
        let heightConstraint = placeholderImage.heightAnchor.constraint(equalTo: placeholderImage.widthAnchor, multiplier: 74/175)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            placeholderImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yValue),
            placeholderImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            widthConstraint, heightConstraint,
            
            placeholderImage.heightAnchor.constraint(lessThanOrEqualToConstant: 400),
            placeholderImage.widthAnchor.constraint(lessThanOrEqualToConstant: 500)
        ])
    }
    
    private func configureTitleLable() {
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureSubtitleLabel() {
        let padding: CGFloat = 35
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureActionButton() {
        actionButton.addShineEffect()
        let padding: CGFloat = 30
        let widthConstraint = actionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        let heightConstraint = actionButton.heightAnchor.constraint(equalTo: placeholderImage.widthAnchor, multiplier: 1/4.5)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: padding * 2),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            widthConstraint, heightConstraint,
            
            actionButton.heightAnchor.constraint(lessThanOrEqualToConstant: 70),
            actionButton.widthAnchor.constraint(lessThanOrEqualToConstant: 450)
        ])
    }
    
    func setup(titleText: String, subtitleText: String) {
        self.titleLabel.text = titleText
        self.subtitleLabel.text = subtitleText
    }
    func setDelegate(for vc: UIViewController) { actionButton.delegate = vc as? FLCButtonDelegate }
    func getActionButton() -> FLCButton { actionButton }
}
