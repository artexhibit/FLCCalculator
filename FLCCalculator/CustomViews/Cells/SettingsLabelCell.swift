import UIKit

final class SettingsLabelCell: FLCContentCell {
    
    static let reuseID = "SettingsLabelCell"
    
    private var contentType: FLCSettingsContentType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
}

extension SettingsLabelCell: FLCConfigurableCell {
    func configureSettingsCell(with content: SettingsCellContent) {
        iconView.set(image: content.image, backgroundColor: content.backgroundColor)
        titleLabel.text = content.title
        contentType = content.contentType
    }
}
