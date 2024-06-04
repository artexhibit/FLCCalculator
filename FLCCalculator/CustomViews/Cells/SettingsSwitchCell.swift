import UIKit

final class SettingsSwitchCell: FLCContentCell {
    
    static let reuseID = "SettingsSwitchCell"
    
    private let uiSwitch = UISwitch()
    
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
        
        NSLayoutConstraint.activate([
            uiSwitch.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: padding),
            uiSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            uiSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
    }
    
    func set(with content: FLCContent) {
        iconImageView.image = content.image
        iconBackgroundView.backgroundColor = content.color
        titleLabel.text = content.title
    }
}
