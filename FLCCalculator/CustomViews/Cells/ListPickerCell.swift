import UIKit

class ListPickerCell: UITableViewCell {
    
    static let reuseID = String(describing: ListPickerCell.self)
    
    private let title = FLCBodyLabel(color: .label, textAlignment: .left)
    private let subtitle = FLCSubtitleLabel(color: .gray, textAlignment: .left)
    private let iconImageView = FLCImageView()
    
    private let padding: CGFloat = 15
    private var iconImageViewWidthConstraint: NSLayoutConstraint!
    private var iconImageViewLeadingConstraint: NSLayoutConstraint!

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
        self.iconImageView.image = item.image != nil ? item.image : nil
        self.iconImageViewWidthConstraint.constant = item.image != nil ? 30 : 0.01
        self.iconImageViewLeadingConstraint.constant = item.image != nil ? padding * 1.2 : padding * 0.8
    }
    
    private func configure() {
        contentView.addSubviews(iconImageView, title, subtitle)
        configureIconImageView()
        configureTitle()
        configureSubtitle()
    }
    
    private func configureIconImageView() {
        iconImageViewWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 30)
        iconImageViewLeadingConstraint = iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding * 1.2)
        
        NSLayoutConstraint.activate([
            iconImageViewLeadingConstraint,
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageViewWidthConstraint,
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ])
    }
    
    private func configureTitle() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            title.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: padding),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureSubtitle() {
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 1),
            subtitle.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: padding),
            subtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
