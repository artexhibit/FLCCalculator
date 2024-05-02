import UIKit

class ListPickerCell: UITableViewCell {
    
    static let reuseID = "ListPickerCell"
    
    private let title = FLCBodyLabel(color: .label, textAlignment: .left)
    private let subtitle = FLCSubtitleLabel(color: .gray, textAlignment: .left)
    private let padding: CGFloat = 15

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with item: FLCPickerItem) {
        self.title.text = item.title
        self.subtitle.text = item.subtitle
    }
    
    private func configure() {
        contentView.addSubviews(title, subtitle)
        configureTitle()
        configureSubtitle()
    }
    
    private func configureTitle() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding * 1.5),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureSubtitle() {
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 1),
            subtitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding * 1.5),
            subtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
