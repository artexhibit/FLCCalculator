import UIKit

final class SettingsLabelCell: FLCContentCell {
    
    static let reuseID = String(describing: SettingsLabelCell.self)
    
    private var contentType: FLCSettingsContentType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        accessoryType = .disclosureIndicator
    }
    
    private func configureTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding / 3)
        ])
    }
}

extension SettingsLabelCell: FLCConfigurableCell {
    func configureSettingsCell(with content: SettingsCellContent) {
        iconView.set(image: content.image, backgroundColor: content.backgroundColor)
        titleLabel.text = content.title
        contentType = content.contentType
    }
}
