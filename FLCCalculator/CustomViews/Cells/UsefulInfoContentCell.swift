import UIKit

final class UsefulInfoContentCell: FLCContentCell {
    
    static let reuseID = "UsefulInfoContentCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
    
    private func configureTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding / 2)
        ])
    }
    
    func set(with content: UsefulInfoContent) {
        iconView.set(image: content.image, backgroundColor: content.color)
        titleLabel.text = content.title
    }
}
