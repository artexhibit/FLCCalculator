import UIKit

protocol CalculationResultCellDelegate: AnyObject {
    func didPressRetryButton(cell: CalculationResultCell)
}

class CalculationResultCell: UITableViewCell {
    
    static let reuseID = "CalculationResultCell"
    
    private let containerView = UIView()
    private let gradientLayer = CAGradientLayer()
        
    let titleTextView = FLCTextViewLabel()
    let subtitle = FLCSubtitleLabel(color: .flcCalculationResultCellSecondary, textAlignment: .left)
    private let daysIconView = FLCImageView(image: UIImage(systemName: "clock.badge.checkmark"), tint: .flcCalculationResultCellSecondary)
    let daysTextView = FLCTextViewLabel()
    let priceLabel = FLCTitleLabel(color: .flcCalculationResultCellSecondary, textAlignment: .right, size: 23)
    let failedPriceCalcContainer = UIView()
    private let failedPriceCalcContentStackView = UIStackView()
    private let failedPriceCalcErrorTitleLabel = FLCTitleLabel(color: .lightGray, textAlignment: .center, size: 18)
    let failedPriceCalcErrorSubtitleLabel = FLCSubtitleLabel(color: .lightGray, textAlignment: .center)
    let failedPriceCalcRetryButton = FLCTintedButton(color: .lightGray, title: "Пересчитать", systemImageName: "arrow.triangle.2.circlepath", size: .medium)
    private let pickupWarningTintedView = FLCTintedView(color: .flcCalculationResultCellSecondary.makeLighter(delta: 0.5), alpha: 0.15, withText: true)
    
    var daysLabelHeightConstraint: NSLayoutConstraint!
    var subtitleBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: CalculationResultCellDelegate?
    
    let padding: CGFloat = 20
    private var isShimmering = false
    private var presentedVC: UIViewController?
    var type: FLCCalculationResultCellType = .russianDelivery
    private var pickedLogisticsType: FLCLogisticsType = .chinaTruck
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
        setupGradientLayerAnimation()
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
        configurePickupWarningTintedView()
        configureGradient()
    }
    
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubviews(titleTextView, subtitle, daysIconView, daysTextView, priceLabel, pickupWarningTintedView, failedPriceCalcContainer)
        containerView.layer.addSublayer(gradientLayer)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding / 2),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding - 2),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(padding - 2)),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding / 2),
        ])
        
        containerView.backgroundColor = .flcNumberTextFieldBackground
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
        NSLayoutConstraint.activate([
            daysIconView.centerYAnchor.constraint(equalTo: daysTextView.centerYAnchor, constant: 1),
            daysIconView.trailingAnchor.constraint(equalTo: daysTextView.leadingAnchor, constant: -7),
            daysIconView.heightAnchor.constraint(equalTo: daysTextView.heightAnchor)
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
            priceLabel.bottomAnchor.constraint(equalTo: pickupWarningTintedView.topAnchor, constant: -padding * 0.5),
            priceLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func configureFailedPriceCalcContainer() {
        failedPriceCalcContainer.hide()
        failedPriceCalcContainer.translatesAutoresizingMaskIntoConstraints = false
        failedPriceCalcContainer.pinToEdges(of: containerView)
        failedPriceCalcContainer.layer.cornerRadius = 10
        failedPriceCalcContainer.clipsToBounds = true
        failedPriceCalcContainer.backgroundColor = .secondarySystemBackground
        failedPriceCalcContainer.addSubviews(failedPriceCalcContentStackView)
        
        configureFailedPriceCalcContainerContentStackView()
        configureFailedPriceCalcErrorTitleLabel()
        configureFailedPriceCalcRetryButton()
    }
    
    private func configureFailedPriceCalcContainerContentStackView() {
        failedPriceCalcContentStackView.addArrangedSubview(failedPriceCalcErrorTitleLabel)
        failedPriceCalcContentStackView.addArrangedSubview(failedPriceCalcErrorSubtitleLabel)
        failedPriceCalcContentStackView.addArrangedSubview(failedPriceCalcRetryButton)
        
        failedPriceCalcContentStackView.axis = .vertical
        failedPriceCalcContentStackView.alignment = .center
        failedPriceCalcContentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        failedPriceCalcContentStackView.setCustomSpacing(-2, after: failedPriceCalcErrorTitleLabel)
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
    
    private func configureFailedPriceCalcRetryButton() { failedPriceCalcRetryButton.delegate = self }
    
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
    
    private func configurePickupWarningTintedView() {
        let message = "Внимание! Пикап рассчитан из ближайшего к вашей точке крупного города. Фактическая стоимость может измениться"
        
        pickupWarningTintedView.setTextLabel(text: message.makeAttributed(icon: Icons.exclamationMark, tint: .flcCalculationResultCellSecondary, size: (0, -2.5, 17, 16), placeIcon: .beforeText), textAlignment: .left, fontWeight: .regular, fontSize: 15)
        pickupWarningTintedView.hide()
        
        NSLayoutConstraint.activate([
            pickupWarningTintedView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: padding / 2),
            pickupWarningTintedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding / 2.5),
            pickupWarningTintedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding / 2.5),
            pickupWarningTintedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding * 0.5)
        ])
    }
    
    func set(with item: CalculationResultItem, presentedVC: UIViewController, pickedLogisticsType: FLCLogisticsType) {
        let attributedText = item.title.makeAttributed(icon: Icons.infoSign, tint: .flcCalculationResultCellMain, size: (0, -4, 22, 21), placeIcon: .beforeText)
        
        item.isShimmering ? addShimmerAnimation() : removeShimmerAnimation()
        
        self.type = item.type
        self.titleTextView.text = item.title
        self.presentedVC = presentedVC
        self.calculationResultItem = item
        self.pickedLogisticsType = pickedLogisticsType
        
        switch type {
        case .russianDelivery:
            CalculationCellUIHelper.configureRussianDelivery(cell: self, with: item, and: attributedText)
        case .insurance:
            CalculationCellUIHelper.configureInsurance(cell: self, with: item, and: attributedText, pickedLogisticsType: pickedLogisticsType)
        case .deliveryFromWarehouse:
            CalculationCellUIHelper.configureDeliveryFromWarehouse(cell: self, with: item, and: attributedText, pickedLogisticsType: pickedLogisticsType)
        case .cargoHandling:
            CalculationCellUIHelper.configureCargoHandling(cell: self, with: item, and: attributedText, pickedLogisticsType: pickedLogisticsType)
        case .customsClearancePrice:
            CalculationCellUIHelper.configureCustomsClearance(cell: self, with: item, and: attributedText)
        case .customsWarehouseServices:
            CalculationCellUIHelper.configureCustomsWarehouseServices(cell: self, with: item, and: attributedText)
        case .deliveryToWarehouse:
            CalculationCellUIHelper.configureDeliveryToWarehouse(logisticsType: pickedLogisticsType, cell: self, with: item, and: attributedText)
        case .groupageDocs:
            CalculationCellUIHelper.configureGroupageDocs(cell: self, with: item, and: attributedText)
        }
        self.titleTextView.setStyle(color: .flcCalculationResultCellMain, textAlignment: .left, fontWeight: .bold, fontSize: 20)
        self.daysTextView.setStyle(color: .flcCalculationResultCellSecondary, textAlignment: .right, fontWeight: .bold, fontSize: 19)
    }
    
    func addShimmerAnimation() {
        configureGradient()
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.isShimmering = false
            self.gradientLayer.removeAnimation(forKey: "shimmer")
            
            self.gradientLayer.colors = nil
            self.gradientLayer.locations = nil
            self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        }
    }
    
    private func setupGradientLayerAnimation() {
        if type != .russianDelivery || (type == .russianDelivery && calculationResultItem?.hasPrice == true) {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradientLayer.frame = containerView.bounds
            CATransaction.commit()
        } else {
            containerView.layoutIfNeeded()
            gradientLayer.frame = containerView.bounds
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
            popover.showPopoverOnMainThread(withText: CalculationCellUIHelper.configurePopoverMessage(in: self, iconType: iconType, pickedLogisticsType: pickedLogisticsType), in: parentVC, target: textView, characterRange: characterRange, presentedVC: presentedVC)
            return false
        }
        return true
    }
}

extension CalculationResultCell: FLCTintedButtonDelegate {
    func didTapButton(_ button: FLCTintedButton) {
        
        switch button {
        case failedPriceCalcRetryButton:
            failedPriceCalcRetryButton.imageView?.addRotationAnimation()
            failedPriceCalcRetryButton.isUserInteractionEnabled = false
            delegate?.didPressRetryButton(cell: self)
        default:
            break
        }
    }
}
