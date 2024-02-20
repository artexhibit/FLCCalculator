import UIKit

class FLCEmptyStateView: UIView {
    
    private let placeholderImage = UIImageView()
    private let titleLabel = FLCTitleLabel(color: .lightGray, textAlignment: .center)
    private let subtitleLabel = FLCSubtitleLabel(color: .lightGray, textAlignment: .center)
    private let startCalculationButton = FLCButton(color: .accent, title: "Новый расчёт", systemImageName: "plus")
    private let padding: CGFloat = 15

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(titleText: String, subtitleText: String) {
        self.init(frame: .zero)
        self.titleLabel.text = titleText
        self.subtitleLabel.text = subtitleText
    }
    
    private func configure() {
        addSubviews(placeholderImage, titleLabel, subtitleLabel, startCalculationButton)
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
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureSubtitleLabel() {
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding + 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding - 10),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureStartCalculationButton() {
        startCalculationButton.addTarget(self, action: #selector(startCalculationButtonTapped), for: .touchUpInside)
        
        let widthConstraint = startCalculationButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        let heightConstraint = startCalculationButton.heightAnchor.constraint(equalTo: placeholderImage.widthAnchor, multiplier: 1/4.5)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            startCalculationButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: padding + 20),
            startCalculationButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            widthConstraint, heightConstraint,
            
            startCalculationButton.heightAnchor.constraint(lessThanOrEqualToConstant: 70),
            startCalculationButton.widthAnchor.constraint(lessThanOrEqualToConstant: 450)
        ])
    }
    
   @objc private func startCalculationButtonTapped() { }
}
