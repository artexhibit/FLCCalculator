import UIKit

class CalculationResultCell: UITableViewCell {
    
    static let reuseID = "CalculationResultCell"
    
    private let containerView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    var titleTextView = FLCTextViewLabel()
    let subtitle = FLCSubtitleLabel(color: .gray, textAlignment: .left)
    private let daysIcon = UIImageView()
    let daysLabel = FLCTitleLabel(color: .lightGray, textAlignment: .right, size: 19)
    let priceLabel = FLCTitleLabel(color: .label, textAlignment: .right, size: 23)
    
    private let padding: CGFloat = 20
    private var daysLabelHeightConstraint: NSLayoutConstraint!
    private var subtitleBottomConstraint: NSLayoutConstraint!
    private var isShimmering = false
    
    var type: FLCCalculationResultCellType = .russianDelivery
    
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
        NotificationsManager.notifyWhenInForeground(self, selector: #selector(restartShimmerEffect))
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil { if isShimmering { addShimmerAnimation() } }
    }
    
    func set(with item: CalculationResultItem, in viewController: UIViewController) {
        let attributedText = item.title.makeAttributed(icon: Icons.infoSign, tint: .gray, size: (0, -4, 24, 23), placeIcon: .afterText)
        
        addShimmerAnimation()
        
        self.type = item.type
        self.titleTextView.delegate = viewController as? UITextViewDelegate
        self.titleTextView.text = item.title
        
        switch type {
        case .russianDelivery:
            CalculationCellUIHelper.configureRussianDelivery(cell: self, with: item, and: attributedText)
        case .insurance:
            self.titleTextView.attributedText = attributedText
            let currencyCode = FLCCurrencySymbol(currencyCode: item.calculationData.invoiceCurrency) ?? .USD
            
            priceLabel.text = PriceCalculationManager.calculateInsurance(for: .chinaTruck, invoiceAmount: item.calculationData.invoiceAmount).formatAsCurrency(symbol: .USD)
            subtitle.text = "\(PriceCalculationManager.getInsurancePersentage(for: .chinaTruck))% от стоимости инвойса (\(item.calculationData.invoiceAmount.formatAsCurrency(symbol: currencyCode)))"
            removeDaysContent()
            removeShimmerAnimation()
        }
        self.titleTextView.setStyle(color: .label, textAlignment: .left, fontWeight: .bold, fontSize: 23)
    }
    
    private func configure() {
        selectionStyle = .none
        contentView.addSubviews(containerView)
        
        configureContainerView()
        configureTitleTextView()
        configureSubtitle()
        configureDaysIcon()
        configureDaysLabel()
        configurePriceLabel()
        configureGradient()
    }
    
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubviews(titleTextView, subtitle, daysIcon, daysLabel, priceLabel)
        containerView.layer.addSublayer(gradientLayer)
        containerView.pinToEdges(of: contentView, withPadding: padding / 2)
        
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 10
    }
    
    private func configureTitleTextView() {
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding * 0.5),
            titleTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 0.5),
            titleTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleTextView.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -padding * 0.15),
        ])
    }
    
    private func configureSubtitle() {
        subtitleBottomConstraint = subtitle.bottomAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: -padding * 2)
        
        NSLayoutConstraint.activate([
            subtitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 0.5),
            subtitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            subtitleBottomConstraint
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
        daysLabelHeightConstraint = daysLabel.heightAnchor.constraint(equalToConstant: 21)
        
        NSLayoutConstraint.activate([
            daysLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding * 0.5),
            daysLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -padding * 0.2),
            daysLabelHeightConstraint
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
        isShimmering = true
    }
    
    func removeShimmerAnimation() {
        isShimmering = false
        gradientLayer.removeAnimation(forKey: "shimmer")
        
        gradientLayer.colors = nil
        gradientLayer.locations = nil
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    private func removeDaysContent() {
        daysLabelHeightConstraint.constant = 1
        subtitleBottomConstraint.constant = -padding
    }
    
    @objc private func restartShimmerEffect() { if isShimmering { addShimmerAnimation() } }
}
