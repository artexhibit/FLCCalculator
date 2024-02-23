import UIKit

protocol FLCEmptyStateViewDelegate: AnyObject {
    func didTapActionButton()
}

class FLCEmptyStateView: UIView {
    
    private let placeholderImage = UIImageView()
    private let titleLabel = FLCTitleLabel(color: .lightGray, textAlignment: .center)
    private let subtitleLabel = FLCSubtitleLabel(color: .lightGray, textAlignment: .center)
    private let actionButton = FLCButton(color: .accent, title: "Новый расчёт", systemImageName: "plus")
    
    weak var delegate: FLCEmptyStateViewDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(titleText: String, subtitleText: String, delegate: FLCEmptyStateViewDelegate) {
        self.init(frame: .zero)
        self.titleLabel.text = titleText
        self.subtitleLabel.text = subtitleText
        
        self.delegate = delegate
    }
    
    private func configure() {
        addSubviews(placeholderImage, titleLabel, subtitleLabel, actionButton)
        configurePlaceholderImage()
        configureTitleLable()
        configureSubtitleLabel()
        configureStartCalculationButton()
    }
    
    private func configurePlaceholderImage() {
        placeholderImage.image = UIImage(resource: .emptyStateView)
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = placeholderImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65)
        let heightConstraint = placeholderImage.heightAnchor.constraint(equalTo: placeholderImage.widthAnchor, multiplier: 74/175)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            placeholderImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -70),
            placeholderImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            widthConstraint, heightConstraint,
            
            placeholderImage.heightAnchor.constraint(lessThanOrEqualToConstant: 400),
            placeholderImage.widthAnchor.constraint(lessThanOrEqualToConstant: 500)
        ])
    }
    
    private func configureTitleLable() {
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor),
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
            subtitleLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureStartCalculationButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        let padding: CGFloat = 30
        let widthConstraint = actionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        let heightConstraint = actionButton.heightAnchor.constraint(equalTo: placeholderImage.widthAnchor, multiplier: 1/4.5)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: padding),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            widthConstraint, heightConstraint,
            
            actionButton.heightAnchor.constraint(lessThanOrEqualToConstant: 70),
            actionButton.widthAnchor.constraint(lessThanOrEqualToConstant: 450)
        ])
    }
    
   @objc private func actionButtonTapped() {
       delegate.didTapActionButton()
   }
}
