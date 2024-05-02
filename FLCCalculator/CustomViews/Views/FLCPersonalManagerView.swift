import UIKit

class FLCPersonalManagerView: UIView {
    
    private let backgroundView = FLCTintedView(color: .secondarySystemBackground, alpha: 1)
    private let managerAvatarView = FLCImageView()
    private let managerContactsContainerView = UIView()
    private let managerNameLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 23)
    private let managerContactsLabel = FLCSubtitleLabel(color: .lightGray, textAlignment: .left, textStyle: .footnote)
    private let roundButtonsStackView = UIStackView()
    private var roundButtons = [FLCRoundButton]()
    private let phoneButton = FLCRoundButton(image: Icons.phone, tint: .flcOrange)
    private let emailButton = FLCRoundButton(image: Icons.envelope, tint: .flcOrange)
    private let telegramButton = FLCRoundButton(image: Icons.telegram, tint: .systemBlue)
    private let whatsappButton = FLCRoundButton(image: Icons.whatsapp, tint: .green)
    
    private var manager: FLCManager?
    private var padding: CGFloat = 10
    private var backgroundViewColor: UIColor = .secondarySystemBackground
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureBackgroundView()
        configureManagerAvatarView()
        configureManagerContactsContainerView()
        configureManagerNameLabel()
        configureManagerContactsLabel()
        configureRoundButtons()
        configureRoundButtonsStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundViewColor = backgroundColor
        self.backgroundView.updateColor(to: backgroundViewColor)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.backgroundView.updateColor(to: backgroundViewColor)
        }
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubviews(backgroundView)
        roundButtons.append(contentsOf: [phoneButton, emailButton, telegramButton, whatsappButton])
    }
    
    private func configureBackgroundView() {
        backgroundView.pinToEdges(of: self)
        backgroundView.addSubviews(managerAvatarView, managerContactsContainerView, roundButtonsStackView)
    }
    
    private func configureManagerAvatarView() {
        managerAvatarView.layer.borderWidth = 1
        managerAvatarView.layer.borderColor = UIColor.clear.cgColor
        managerAvatarView.image = UIImage(resource: .personPlaceholder)
        
        NSLayoutConstraint.activate([
            managerAvatarView.centerYAnchor.constraint(equalTo: managerContactsContainerView.centerYAnchor),
            managerAvatarView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: padding * 1.5),
            managerAvatarView.widthAnchor.constraint(equalToConstant: 70),
            managerAvatarView.heightAnchor.constraint(equalTo: managerAvatarView.widthAnchor)
        ])
        layoutIfNeeded()
        managerAvatarView.layer.cornerRadius = managerAvatarView.bounds.height / 2
        managerAvatarView.clipsToBounds = true
    }
    
    private func configureManagerContactsContainerView() {
        managerContactsContainerView.translatesAutoresizingMaskIntoConstraints = false
        managerContactsContainerView.addSubviews(managerNameLabel, managerContactsLabel)
        
        NSLayoutConstraint.activate([
            managerContactsContainerView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: padding * 1.5),
            managerContactsContainerView.leadingAnchor.constraint(equalTo: managerAvatarView.trailingAnchor, constant: padding * 1.5),
            managerContactsContainerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -padding * 1.5),
        ])
    }
    
    private func configureManagerNameLabel() {
        managerNameLabel.text = CalculationInfo.defaultManager.name
        
        NSLayoutConstraint.activate([
            managerNameLabel.topAnchor.constraint(equalTo: managerContactsContainerView.topAnchor),
            managerNameLabel.leadingAnchor.constraint(equalTo: managerContactsContainerView.leadingAnchor),
            managerNameLabel.trailingAnchor.constraint(equalTo: managerContactsContainerView.trailingAnchor),
        ])
    }
    
    private func configureManagerContactsLabel() {
        managerContactsLabel.text = "\(CalculationInfo.defaultManager.email) \n\(CalculationInfo.defaultManager.landlinePhone)"
        
        NSLayoutConstraint.activate([
            managerContactsLabel.topAnchor.constraint(equalTo: managerNameLabel.bottomAnchor, constant: padding / 2),
            managerContactsLabel.leadingAnchor.constraint(equalTo: managerContactsContainerView.leadingAnchor),
            managerContactsLabel.trailingAnchor.constraint(equalTo: managerContactsContainerView.trailingAnchor),
            managerContactsLabel.bottomAnchor.constraint(equalTo: managerContactsContainerView.bottomAnchor)
        ])
    }
    
    private func configureRoundButtons() {
        roundButtons.forEach { button in
            button.delegate = self
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 45),
                button.heightAnchor.constraint(equalToConstant: 45)
            ])
        }
    }
    
    private func configureRoundButtonsStackView() {
        roundButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        roundButtonsStackView.addArrangedSubview(phoneButton)
        roundButtonsStackView.addArrangedSubview(emailButton)
        roundButtonsStackView.addArrangedSubview(telegramButton)
        roundButtonsStackView.addArrangedSubview(whatsappButton)
        
        roundButtonsStackView.spacing = 5
        roundButtonsStackView.alignment = .center
        roundButtonsStackView.distribution = .equalCentering
        roundButtonsStackView.axis = .horizontal
        
        NSLayoutConstraint.activate([
            roundButtonsStackView.topAnchor.constraint(equalTo: managerContactsContainerView.bottomAnchor, constant: padding * 3),
            roundButtonsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: padding * 2.5),
            roundButtonsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -padding * 2.5),
            roundButtonsStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -padding * 1.5)
        ])
    }
    
    func setPersonalManagerInfo(manager: FLCManager) {
        self.manager = manager
        
        FLCPersonalManagerViewUIHelper.configurePhoneButtonMenu(phoneButton: phoneButton, of: manager)
        FLCPersonalManagerViewUIHelper.configureItemsContent(manager: manager, avatarView: managerAvatarView, nameLabel: managerNameLabel, contactsLabel: managerContactsLabel)
        FLCPersonalManagerViewUIHelper.removeShimmerAnimationFromItems(avatarView: managerAvatarView, nameLabel: managerNameLabel, contactsLabel: managerContactsLabel, roundButtons: roundButtons)
    }
    
    func addShimmerAnimationToAllItems() {
        FLCPersonalManagerViewUIHelper.addShimmerAnimationToItems(avatarView: managerAvatarView, nameLabel: managerNameLabel, contactsLabel: managerContactsLabel, roundButtons: roundButtons)
    }
}

extension FLCPersonalManagerView: FLCRoundButtonDelegate {
    func didTapButton(_ button: FLCRoundButton) {
        switch button {
        case emailButton: FLCPersonalManagerViewUIHelper.sendEmail(from: self, manager: manager)
        case telegramButton: FLCPersonalManagerViewUIHelper.goToTelegram(of: manager)
        case whatsappButton: FLCPersonalManagerViewUIHelper.goToWhatsapp(of: manager)
        default: break
        }
    }
}
