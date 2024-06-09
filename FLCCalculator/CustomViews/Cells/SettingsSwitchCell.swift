import UIKit

protocol SettingsSwitchCellDelegate: AnyObject {
    func switchValueChanged(contentType: FLCSettingsContentType, state: Bool)
}

final class SettingsSwitchCell: FLCContentCell {
    
    static let reuseID = "SettingsSwitchCell"
    
    private let uiSwitch = UISwitch()
    
    private var contentType: FLCSettingsContentType?
    weak var delegate: SettingsSwitchCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureUISwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(uiSwitch)
        selectionStyle = .none
    }
    
    private func configureUISwitch() {
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.onTintColor = .flcOrange
        uiSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        uiSwitch.setOn(SettingsVCHelper.configureSwitchState(for: contentType ?? .haptic), animated: false)
        
        NSLayoutConstraint.activate([
            uiSwitch.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: padding),
            uiSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            uiSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchValueChanged(contentType: contentType ?? .haptic, state: sender.isOn)
    }
}

extension SettingsSwitchCell: FLCConfigurableCell {
    func configureSettingsCell(with content: SettingsCellContent) {
        iconImageView.image = content.image
        iconBackgroundView.backgroundColor = content.backgroundColor
        titleLabel.text = content.title
        contentType = content.contentType
    }
}
