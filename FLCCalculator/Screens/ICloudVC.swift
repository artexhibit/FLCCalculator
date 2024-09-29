import UIKit

class ICloudVC: UIViewController {
    
    private let cloudImageView = FLCImageView()
    private let enableICloudContainerSV = UIStackView()
    private let enableICloudSwitch = UISwitch()
    private let enableICloudTitle = FLCTitleLabel(color: .flcGray, textAlignment: .center, size: 23, weight: .semibold)
    
    private let padding: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCloudImageView()
        configureEnableICloudContainerSV()
        configureEnableICloudTitle()
        configureEnableICloudSwitch()
    }
    
    private func configureVC() {
        view.addSubviews(cloudImageView, enableICloudContainerSV)
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
            cloudImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -padding * 12),
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
    
    @objc private func enableICloudSwitchValueChanged(_ sender: UISwitch) {
        ICloudVCUIHelper.configureICloudSwitch(iCloudSwitch: sender)
    }

    @objc func closeButtonPressed() { dismiss(animated: true) }
}
