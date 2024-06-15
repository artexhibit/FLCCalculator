import UIKit

protocol SettingsMenuCellDelegate: AnyObject {
    func menuButtonPressed(contentType: FLCSettingsContentType)
}

final class SettingsMenuCell: FLCContentCell {
    
    static let reuseID = "SettingsMenuCell"
    
    private let pickedOptionLabel = FLCSubtitleLabel(color: .flcGray, textAlignment: .right, textStyle: .body)
    private let menuIconView = FLCImageView(tint: .flcGray)
    private let showMenuButton = FLCMenuButton()
    
    private var contentType: FLCSettingsContentType?
    weak var delegate: SettingsMenuCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configurePickedOptionLabel()
        configureMenuIconView()
        configureShowMenuButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubviews(pickedOptionLabel, menuIconView, showMenuButton)
    }
    
    private func configurePickedOptionLabel() {
        NSLayoutConstraint.activate([
            pickedOptionLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: padding / 2),
            pickedOptionLabel.trailingAnchor.constraint(equalTo: menuIconView.leadingAnchor, constant: -padding / 2),
            pickedOptionLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
    }
    
    private func configureMenuIconView() {
        menuIconView.image = Icons.chevronUpDown
        
        NSLayoutConstraint.activate([
            menuIconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding / 2),
            menuIconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            menuIconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding / 2),
        ])
    }
    private func configureShowMenuButton() { showMenuButton.pinToEdges(of: contentView) }
    
    private func getMenu() -> UIMenu {
        return SettingsVCHelper.configureUIMenu(for: contentType ?? .theme, updateHandler: { [weak self] in
            guard let self else { return }
            self.showMenuButton.configureMenu(with: getMenu())
            delegate?.menuButtonPressed(contentType: contentType ?? .theme)
        })
    }
}

extension SettingsMenuCell: FLCConfigurableCell {
    func configureSettingsCell(with content: SettingsCellContent) {
        iconView.set(image: content.image, backgroundColor: content.backgroundColor)
        titleLabel.text = content.title
        pickedOptionLabel.text = content.pickedOption
        contentType = content.contentType
        
        showMenuButton.configureMenu(with: getMenu())
    }
}
