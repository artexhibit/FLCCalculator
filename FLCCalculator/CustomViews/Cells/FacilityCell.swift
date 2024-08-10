import UIKit

protocol FacilityCellDelegate: AnyObject {
    func didTapActionButton(ofType: FLCRoundButtonType, facility: FLCFacility)
}

final class FacilityCell: UICollectionViewCell {
    
    static let reuseID = String(describing: FacilityCell.self)
    
    private let containerView = UIView()
    
    private let facilityNameLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 20)
    private let facilityAddressLabel = FLCSubtitleLabel(color: .flcGray, textAlignment: .left, textStyle: .callout)
    private let facilityWorkingHoursLabel = FLCSubtitleLabel(color: .flcGray, textAlignment: .left, textStyle: .body)
    private let roundButtonsStackView = UIStackView()
    private let phoneButton = FLCRoundButton(image: FLCIcon.phone.icon, tint: .flcOrange, title: ContactsVCStrings.phoneButton, type: .phone)
    private let emailButton = FLCRoundButton(image: FLCIcon.envelope.icon, tint: .flcOrange, title: ContactsVCStrings.emailButton, type: .email)
    private let routeButton = FLCRoundButton(image: FLCIcon.walkingPerson.icon, tint: .flcOrange, title: ContactsVCStrings.routeButton, type: .route)
    private let detailsButton = FLCRoundButton(image: FLCIcon.dots.icon, tint: .flcOrange, title: ContactsVCStrings.detailsButton, type: .details)
    
    private let padding: CGFloat = 15
    private var facility: FLCFacility = CalculationInfo.defaultFacility
    weak var delegate: FacilityCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with facility: FLCFacility) {
        let deviceLanguageCode = LanguageManager.shared.currentDeviceLanguage.rawValue
        self.facility = facility
        
        facilityNameLabel.text = facility.localisationData?[deviceLanguageCode]?.name ?? facility.name
        facilityAddressLabel.attributedText = (facility.localisationData?[deviceLanguageCode]?.address ?? facility.address).makeAttributed(icon: FLCIcon.map.icon, tint: .flcGray, size: (0, -2, 22, 16), placeIcon: .beforeText)
        facilityWorkingHoursLabel.attributedText = (facility.localisationData?[deviceLanguageCode]?.workingHours ?? facility.workingHours).makeAttributed(icon: FLCIcon.clock.icon, tint: .flcGray, size: (0, -2, 18, 17), placeIcon: .beforeText)
        configureEmailButton(with: facility)
    }
    
    private func configure() {
        contentView.addSubviews(containerView)
        configureContainerView()
        configureFacilityNameLabel()
        configureFacilityAddressLabel()
        configureFacilityWorkingHoursLabel()
        configureRoundButtonsStackView()
        configureRoundButtons()
    }
    
    private func configureContainerView() {
        containerView.addSubviews(facilityNameLabel, facilityAddressLabel, facilityWorkingHoursLabel, roundButtonsStackView)
        containerView.pinToEdges(of: contentView)
        
        containerView.layer.cornerRadius = 13
        containerView.backgroundColor = .systemBackground
    }
    
    private func configureFacilityNameLabel() {
        NSLayoutConstraint.activate([
            facilityNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            facilityNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            facilityNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -padding / 1.1)
        ])
    }
    
    private func configureFacilityAddressLabel() {
        NSLayoutConstraint.activate([
            facilityAddressLabel.topAnchor.constraint(equalTo: facilityNameLabel.bottomAnchor, constant: padding),
            facilityAddressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            facilityAddressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding / 1.1)
        ])
    }
    
    private func configureFacilityWorkingHoursLabel() {
        NSLayoutConstraint.activate([
            facilityWorkingHoursLabel.topAnchor.constraint(equalTo: facilityAddressLabel.bottomAnchor, constant: padding / 2),
            facilityWorkingHoursLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            facilityWorkingHoursLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding / 1.1)
        ])
    }
    
    private func configureRoundButtonsStackView() {
        roundButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        roundButtonsStackView.addArrangedSubview(phoneButton)
        roundButtonsStackView.addArrangedSubview(routeButton)
        roundButtonsStackView.addArrangedSubview(detailsButton)
        
        roundButtonsStackView.spacing = 7
        roundButtonsStackView.alignment = .fill
        roundButtonsStackView.distribution = .fill
        roundButtonsStackView.axis = .horizontal
        
        NSLayoutConstraint.activate([
            roundButtonsStackView.topAnchor.constraint(equalTo: facilityWorkingHoursLabel.bottomAnchor, constant: padding * 2),
            roundButtonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            roundButtonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding / 1.1),
            roundButtonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureRoundButtons() {
        phoneButton.delegate = self
        emailButton.delegate = self
        routeButton.delegate = self
        detailsButton.delegate = self
        
        routeButton.menu = ContactsVCHelper.showRoutesOptions(for: facility)
        routeButton.showsMenuAsPrimaryAction = true
    }
    
    private func configureEmailButton(with facility: FLCFacility) {
        emailButton.layer.opacity = facility.email != nil ? 1 : 0
        
        if facility.email == nil {
            roundButtonsStackView.addArrangedSubview(emailButton)
        } else {
            roundButtonsStackView.insertArrangedSubview(emailButton, at: 1)
        }
    }
}

extension FacilityCell: FLCRoundButtonDelegate {
    func didTapButton(_ button: FLCRoundButton) {
        delegate?.didTapActionButton(ofType: button.getType(), facility: facility)
    }
}
