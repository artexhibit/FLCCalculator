import UIKit

class CalculationResultCell: UITableViewCell {
    
    static let reuseID = "CalculationResultCell"
    
    private let containerView = UIView()
    private let gradientLayer = CAGradientLayer()
        
    let titleTextView = FLCTextViewLabel()
    let subtitle = FLCSubtitleLabel(color: .gray, textAlignment: .left)
    private let daysIcon = UIImageView()
    let daysTextView = FLCTextViewLabel()
    let priceLabel = FLCTitleLabel(color: .label, textAlignment: .right, size: 23)
    let failedPriceCalcContainer = UIView()
    private let failedPriceCalcContentStackView = UIStackView()
    private let failedPriceCalcErrorTitleLabel = FLCTitleLabel(color: .lightGray, textAlignment: .center, size: 18)
    let failedPriceCalcErrorSubtitleLabel = FLCSubtitleLabel(color: .lightGray, textAlignment: .center)
    let failedPriceCalcRetryButton = FLCTintedButton(color: .lightGray, title: "Обновить", systemImageName: "arrow.triangle.2.circlepath", size: .medium)
    
    var daysLabelHeightConstraint: NSLayoutConstraint!
    var subtitleBottomConstraint: NSLayoutConstraint!
    
    let padding: CGFloat = 20
    private var isShimmering = false
    private var presentedVC: UIViewController?
    var type: FLCCalculationResultCellType = .russianDelivery
    var calculationResultItem: CalculationResultItem?
    
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
        containerView.addSubviews(titleTextView, subtitle, daysIcon, daysTextView, priceLabel, failedPriceCalcContainer)
        containerView.layer.addSublayer(gradientLayer)
        containerView.pinToEdges(of: contentView, withPadding: padding / 2)
        
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 10
    }
    
    private func configureTitleTextView() {
        titleTextView.delegate = self
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding * 0.5),
            titleTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 0.5),
            titleTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            titleTextView.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -padding * 0.15),
        ])
    }
    
    private func configureSubtitle() {
        subtitleBottomConstraint = subtitle.bottomAnchor.constraint(equalTo: daysTextView.bottomAnchor, constant: -padding * 2)
        
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
            daysIcon.centerYAnchor.constraint(equalTo: daysTextView.centerYAnchor, constant: 1),
            daysIcon.trailingAnchor.constraint(equalTo: daysTextView.leadingAnchor, constant: -7),
            daysIcon.heightAnchor.constraint(equalTo: daysTextView.heightAnchor)
        ])
    }
    
    private func configureDaysLabel() {
        daysTextView.delegate = self
        daysLabelHeightConstraint = daysTextView.heightAnchor.constraint(equalToConstant: 21)
        
        NSLayoutConstraint.activate([
            daysTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding * 0.5),
            daysTextView.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -padding * 0.25),
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
    
    private func configureFailedPriceCalcContainer() {
        failedPriceCalcContainer.hide()
        failedPriceCalcContainer.translatesAutoresizingMaskIntoConstraints = false
        failedPriceCalcContainer.pinToEdges(of: containerView)
        failedPriceCalcContainer.layer.cornerRadius = 10
        failedPriceCalcContainer.clipsToBounds = true
        failedPriceCalcContainer.backgroundColor = .secondarySystemBackground
        failedPriceCalcContainer.addSubviews(failedPriceCalcContentStackView)
        
        configureFailedPriceCalcContainerContentStackView()
        configureFailedPriceCalcErrorTitleLabel()
    }
    
    private func configureFailedPriceCalcContainerContentStackView() {
        failedPriceCalcContentStackView.addArrangedSubview(failedPriceCalcErrorTitleLabel)
        failedPriceCalcContentStackView.addArrangedSubview(failedPriceCalcErrorSubtitleLabel)
        failedPriceCalcContentStackView.addArrangedSubview(failedPriceCalcRetryButton)
        
        failedPriceCalcContentStackView.axis = .vertical
        failedPriceCalcContentStackView.alignment = .center
        failedPriceCalcContentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        failedPriceCalcContentStackView.setCustomSpacing(-4, after: failedPriceCalcErrorTitleLabel)
        failedPriceCalcContentStackView.setCustomSpacing(10, after: failedPriceCalcErrorSubtitleLabel)
        
        NSLayoutConstraint.activate([
            failedPriceCalcContentStackView.centerXAnchor.constraint(equalTo: failedPriceCalcContainer.centerXAnchor),
            failedPriceCalcContentStackView.centerYAnchor.constraint(equalTo: failedPriceCalcContainer.centerYAnchor),
            failedPriceCalcContentStackView.leadingAnchor.constraint(greaterThanOrEqualTo: failedPriceCalcContainer.leadingAnchor, constant: padding / 2.5),
            failedPriceCalcContentStackView.trailingAnchor.constraint(lessThanOrEqualTo: failedPriceCalcContainer.trailingAnchor, constant: -padding / 2.5)
        ])
    }
    
    private func configureFailedPriceCalcErrorTitleLabel() {
        failedPriceCalcErrorTitleLabel.text = "Не удалось получить расчёт"
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
    
    func set(with item: CalculationResultItem, presentedVC: UIViewController) {
        let attributedText = item.title.makeAttributed(icon: Icons.infoSign, tint: .gray, size: (0, -4, 22, 21), placeIcon: .beforeText)
        
        addShimmerAnimation()
        
        self.type = item.type
        self.titleTextView.text = item.title
        self.presentedVC = presentedVC
        self.calculationResultItem = item
        
        guard !item.hasError else {
            configureFailedPriceCalcContainer()
            failedPriceCalcErrorSubtitleLabel.text = item.title
            failedPriceCalcContainer.show()
            removeShimmerAnimation()
            return
        }
        
        switch type {
        case .russianDelivery:
            CalculationCellUIHelper.configureRussianDelivery(cell: self, with: item, and: attributedText)
        case .insurance:
            CalculationCellUIHelper.configureInsurance(cell: self, with: item, and: attributedText)
        case .deliveryFromWarehouse:
            CalculationCellUIHelper.configureDeliveryFromWarehouse(cell: self, with: item, and: attributedText)
        case .cargoHandling:
            CalculationCellUIHelper.configureCargoHandling(cell: self, with: item, and: attributedText)
        case .customsClearancePrice:
            CalculationCellUIHelper.configureCustomsClearance(cell: self, with: item, and: attributedText)
        case .customsWarehouseServices:
            CalculationCellUIHelper.configureCustomsWarehouseServices(cell: self, with: item, and: attributedText)
        case .deliveryToWarehouse:
            CalculationCellUIHelper.configureDeliveryToWarehouse(cell: self, with: item, and: attributedText)
        }
        self.titleTextView.setStyle(color: .label, textAlignment: .left, fontWeight: .bold, fontSize: 20)
        self.daysTextView.setStyle(color: .lightGray, textAlignment: .right, fontWeight: .bold, fontSize: 19)
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
    
    func removeShimmerAnimation(delay: Double = 0.0) {
        isShimmering = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.gradientLayer.removeAnimation(forKey: "shimmer")
            
            self.gradientLayer.colors = nil
            self.gradientLayer.locations = nil
            self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        }
    }
    @objc private func restartShimmerEffect() { if isShimmering { addShimmerAnimation() } }
}

extension CalculationResultCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let imageName = textAttachment.image {
            HapticManager.addHaptic(style: .light)
            
            guard let totalPriceVC = presentedVC as? TotalPriceVC else { return false }
            TotalPriceVCUIHelper.showDetent(in: totalPriceVC, type: .smallDetent) { totalPriceVC.setupUIForSmallDetent() }
            
            guard let parentVC = self.findParentViewController() as? CalculationResultVC else { return false }
            let popover = FLCPopoverVC()
            var iconType = ""
            
            if parentVC.showingPopover.isShowing { parentVC.showingPopover.hidePopoverFromMainThread() }
            parentVC.showingPopover = popover
            
            if imageName.description.contains("info.circle") {
                iconType = "info.circle"
            } else if imageName.description.contains("questionmark.circle.fill") {
                iconType = "questionmark.circle.fill"
            }
            popover.showPopoverOnMainThread(withText: CalculationCellUIHelper.configurePopoverMessage(in: self, iconType: iconType), in: parentVC, target: textView, characterRange: characterRange, presentedVC: presentedVC)
            return false
        }
        return true
    }
}
