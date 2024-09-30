import UIKit

class ICloudVC: UIViewController {
    
    private let cloudImageView = FLCImageView()
    private let enableICloudContainerSV = UIStackView()
    private let enableICloudSwitch = UISwitch()
    private let enableICloudTitle = FLCTitleLabel(color: .flcGray, textAlignment: .center, size: 23, weight: .semibold)
    private let descriptionLabel = FLCBodyLabel(color: .flcGray, textAlignment: .center)
    private let syncNowTextButton = FLCTextButton(title: ICloudVCStrings.syncNow)
    private let deleteDatabaseTextButton = FLCTextButton(title: ICloudVCStrings.deleteDatabase, titleColor: .red)
    
    private let padding: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCloudImageView()
        configureEnableICloudContainerSV()
        configureEnableICloudTitle()
        configureEnableICloudSwitch()
        configureDescriptionLabel()
        configureSyncNowTextButton()
        configureDeleteDatabaseTextButton()
    }
    
    private func configureVC() {
        view.addSubviews(cloudImageView, enableICloudContainerSV, descriptionLabel, syncNowTextButton, deleteDatabaseTextButton)
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = SettingsVCStrings.iCloud
        setNavBarColor(color: UIColor.flcOrange)
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    private func configureCloudImageView() {
        cloudImageView.image = FLCIcon.iCloud.icon
        
        NSLayoutConstraint.activate([
            cloudImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            cloudImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            cloudImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -padding * 14),
            cloudImageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2)
        ])
    }
    
    private func configureEnableICloudContainerSV() {
        enableICloudContainerSV.axis = .vertical
        enableICloudContainerSV.alignment = .center
        enableICloudContainerSV.distribution = .equalCentering
        enableICloudContainerSV.spacing = padding
        enableICloudContainerSV.translatesAutoresizingMaskIntoConstraints = false
        enableICloudContainerSV.addArrangedSubviews(enableICloudTitle, enableICloudSwitch)
        
        NSLayoutConstraint.activate([
            enableICloudContainerSV.topAnchor.constraint(equalTo: cloudImageView.bottomAnchor, constant: padding * 4),
            enableICloudContainerSV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 2),
            enableICloudContainerSV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 2)
        ])
    }
    
    private func configureEnableICloudSwitch() {
        enableICloudSwitch.translatesAutoresizingMaskIntoConstraints = false
        enableICloudSwitch.onTintColor = .flcOrange
        enableICloudSwitch.setContentHuggingPriority(.required, for: .horizontal)
        enableICloudSwitch.setContentCompressionResistancePriority(.required, for: .horizontal)
        enableICloudSwitch.setOn(UserDefaultsManager.iCloudSyncEnabled, animated: false)
        enableICloudSwitch.addTarget(self, action: #selector(enableICloudSwitchValueChanged), for: .valueChanged)
    }
    
    private func configureEnableICloudTitle() {
        enableICloudTitle.text = ICloudVCStrings.iCloudEnable
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.text = ICloudVCStrings.iCloudDataSync
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: enableICloudContainerSV.bottomAnchor, constant: padding * 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 3),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 3)
        ])
    }
    
    private func configureSyncNowTextButton() {
        syncNowTextButton.delegate = self
        
        NSLayoutConstraint.activate([
            syncNowTextButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding * 3),
            syncNowTextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureDeleteDatabaseTextButton() {
        deleteDatabaseTextButton.delegate = self
        
        NSLayoutConstraint.activate([
            deleteDatabaseTextButton.topAnchor.constraint(equalTo: syncNowTextButton.bottomAnchor),
            deleteDatabaseTextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func enableICloudSwitchValueChanged(_ sender: UISwitch) {
        ICloudVCUIHelper.configureICloudSwitch(iCloudSwitch: sender)
    }

    @objc func closeButtonPressed() { dismiss(animated: true) }
}

extension ICloudVC: FLCTextButtonDelegate {
    func didTapButton(_ button: FLCTextButton) {
        switch button {
        case syncNowTextButton: ICloudVCUIHelper.syncNowTextButtonPressed()
        case deleteDatabaseTextButton: ICloudVCUIHelper.deleteDatabaseTextButtonPressed()
        default: break
        }
    }
}
