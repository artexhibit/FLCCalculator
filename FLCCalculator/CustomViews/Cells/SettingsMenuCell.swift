import UIKit

protocol SettingsMenuCellDelegate: AnyObject {
    func menuButtonPressed(button: FLCButton, contentType: FLCSettingsContentType)
}

final class SettingsMenuCell: FLCContentCell {
    
    static let reuseID = "SettingsMenuCell"
    
    private let pickedOptionLabel = FLCSubtitleLabel(color: .flcGray, textAlignment: .right, textStyle: .body)
    private let menuIconView = FLCImageView(tint: .flcGray)
    private let showMenuButton = FLCButton(color: .clear, title: "")
    
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
    
    private func configureShowMenuButton() {
        showMenuButton.delegate = self
        showMenuButton.showsMenuAsPrimaryAction = true
        showMenuButton.pinToEdges(of: contentView)
    }
}

extension SettingsMenuCell: FLCConfigurableCell {
    func configureSettingsCell(with content: SettingsCellContent) {
        iconImageView.image = content.image
        iconBackgroundView.backgroundColor = content.backgroundColor
        titleLabel.text = content.title
        pickedOptionLabel.text = content.pickedOption
        contentType = content.contentType
    }
}

extension SettingsMenuCell: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        setSelected(true, animated: true)
        setSelected(false, animated: true)
        delegate?.menuButtonPressed(button: showMenuButton, contentType: contentType ?? .theme)
    }
}
