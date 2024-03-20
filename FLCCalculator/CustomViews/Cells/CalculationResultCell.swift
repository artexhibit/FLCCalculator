import UIKit

class CalculationResultCell: UITableViewCell {
    
    static let reuseID = "CalculationResultCell"
    
    private let containerView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let title = FLCTitleLabel(color: .label, textAlignment: .left, size: 23)
    private let subtitle = FLCSubtitleLabel(color: .gray, textAlignment: .left)
    private let daysIcon = UIImageView()
    private let daysLabel = FLCTitleLabel(color: .lightGray, textAlignment: .right, size: 19)
    private let priceLabel = FLCTitleLabel(color: .label, textAlignment: .right, size: 23)
    
    private let padding: CGFloat = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layoutIfNeeded()
        gradientLayer.frame = containerView.bounds
    }
    
    func set(with item: CalculationResultItem) {
        addShimmerAnimation()
        
        self.title.text = item.title
        self.subtitle.attributedText = item.subtitle.makeAttributed(icon: Icons.truck, size: (0, -3, 24, 17), placeIcon: .beforeText)
        
        switch item.type {
        case .russianDelivery:
            Task {
                do {
                    let data = try await NetworkManager.shared.getRussianDelivery(for: item)
                    let price = data.getPrice().add(markup: .russianDelivery).formatIntoCurrency(symbol: .rub)
                    
                    priceLabel.text = price
                    daysLabel.text = "\(data.getDays() ?? "?") дн."
                    removeShimmerAnimation()
                }
            }
        }
    }
    
    private func configure() {
        selectionStyle = .none
        contentView.addSubviews(containerView)
        
        configureContainerView()
        configureTitle()
        configureSubtitle()
        configureDaysIcon()
        configureDaysLabel()
        configurePriceLabel()
        configureGradient()
    }
    
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubviews(title, subtitle, daysIcon, daysLabel, priceLabel)
        containerView.layer.addSublayer(gradientLayer)
        containerView.pinToEdges(of: contentView, withPadding: padding / 2)
        
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 10
    }
    
    private func configureTitle() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding * 0.5),
            title.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 0.5),
            title.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            title.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -padding * 0.15),
        ])
    }
    
    private func configureSubtitle() {
        
        NSLayoutConstraint.activate([
            subtitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 0.5),
            subtitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            subtitle.bottomAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: -padding * 2)
        ])
    }
    
    private func configureDaysIcon() {
        daysIcon.translatesAutoresizingMaskIntoConstraints = false
        daysIcon.contentMode = .scaleAspectFit
        daysIcon.tintColor = .lightGray
        daysIcon.image = UIImage(systemName: "clock.badge.checkmark")
        
        NSLayoutConstraint.activate([
            daysIcon.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor, constant: 1),
            daysIcon.trailingAnchor.constraint(equalTo: daysLabel.leadingAnchor, constant: -3),
            daysIcon.heightAnchor.constraint(equalTo: daysLabel.heightAnchor)
        ])
    }
    
    private func configureDaysLabel() {
        NSLayoutConstraint.activate([
            daysLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding * 0.5),
            daysLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -padding * 0.2),
            daysLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
    
    private func configurePriceLabel() {
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding * 0.5),
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding * 0.5),
            priceLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
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
    
    private func addShimmerAnimation() {
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
    }
    
    private func removeShimmerAnimation() {
        gradientLayer.removeAnimation(forKey: "shimmer")
        
        gradientLayer.colors = nil
        gradientLayer.locations = nil
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
    }
}
