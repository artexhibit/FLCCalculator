import UIKit

class FLCPersonalManagerView: UIView {
    
    private let backgroundView = FLCTintedView(color: .secondarySystemBackground, alpha: 1)
    private let managerPhotoView = FLCImageView(image: UIImage(resource: .personPlaceholder))
    private let managerContactsContainerView = UIView()
    private let managerNameLabel = FLCTitleLabel(color: .label, textAlignment: .left, size: 23)
    private let managerContactsLabel = FLCSubtitleLabel(color: .lightGray, textAlignment: .left)
    private let roundButtonsStackView = UIStackView()
    private var roundButtons = [FLCRoundButton]()
    private let phoneButton = FLCRoundButton(image: Icons.phone, tint: .flcOrange)
    private let emailButton = FLCRoundButton(image: Icons.envelope, tint: .flcOrange)
    private let telegramButton = FLCRoundButton(image: Icons.telegram, tint: .systemBlue)
    private let whatsappButton = FLCRoundButton(image: Icons.whatsapp, tint: .green)
    private var salesManager: FLCSalesManager = .igorVolkov
    
    private var padding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureBackgroundView()
        configureManagerPhotoView()
        configureManagerContactsContainerView()
        configureManagerNameLabel()
        configureManagerContactsLabel()
        configureRoundButtons()
        configureRoundButtonsStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // managerPositionLabel.addShimmerAnimation()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubviews(backgroundView)
        roundButtons.append(contentsOf: [phoneButton, emailButton, telegramButton, whatsappButton])
    }
    
    private func configureBackgroundView() {
        backgroundView.pinToEdges(of: self)
        backgroundView.addSubviews(managerPhotoView, managerContactsContainerView, roundButtonsStackView)
    }
    
    private func configureManagerPhotoView() {
        managerPhotoView.layer.borderWidth = 1
        managerPhotoView.layer.borderColor = UIColor.flcGray.cgColor
        
        NSLayoutConstraint.activate([
            managerPhotoView.centerYAnchor.constraint(equalTo: managerContactsContainerView.centerYAnchor),
            managerPhotoView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: padding * 1.5),
            managerPhotoView.widthAnchor.constraint(equalToConstant: 70),
            managerPhotoView.heightAnchor.constraint(equalTo: managerPhotoView.widthAnchor)
        ])
        layoutIfNeeded()
        managerPhotoView.layer.cornerRadius = managerPhotoView.bounds.height / 2
        managerPhotoView.clipsToBounds = true
    }
    
    private func configureManagerContactsContainerView() {
        managerContactsContainerView.translatesAutoresizingMaskIntoConstraints = false
        managerContactsContainerView.addSubviews(managerNameLabel, managerContactsLabel)
        
        NSLayoutConstraint.activate([
            managerContactsContainerView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: padding * 1.5),
            managerContactsContainerView.leadingAnchor.constraint(equalTo: managerPhotoView.trailingAnchor, constant: padding * 1.5),
            managerContactsContainerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -padding * 1.5),
        ])
    }
    
    private func configureManagerNameLabel() {
        managerNameLabel.text = salesManager.rawValue
        
        NSLayoutConstraint.activate([
            managerNameLabel.topAnchor.constraint(equalTo: managerContactsContainerView.topAnchor),
            managerNameLabel.leadingAnchor.constraint(equalTo: managerContactsContainerView.leadingAnchor),
            managerNameLabel.trailingAnchor.constraint(equalTo: managerContactsContainerView.trailingAnchor),
        ])
    }
    
    private func configureManagerContactsLabel() {
        managerContactsLabel.text = "i.volkov@free-lines.ru \n+7 (980)-800-21-24"
        
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
    
    func setPersonalManagerInfo(manager: FLCSalesManager) {
        self.salesManager = manager
    }
}

extension FLCPersonalManagerView: FLCRoundButtonDelegate {
    func didTapButton(_ button: FLCRoundButton) {
        switch button {
        case phoneButton: break
        case emailButton: break
        case telegramButton: break
        case whatsappButton: break
        default: break
        }
    }
}
