import UIKit

class SheetPickerCell: UITableViewCell {
    
    static let reuseID = "SheetPickerCell"
    
    private let title = FLCBodyLabel(color: .label, textAlignment: .left)
    private let subtitle = FLCSubtitleLabel(color: .gray, textAlignment: .left, textStyle: .caption1)
    private let iconImageView = FLCImageView()
    private let checkmarkImageView = FLCImageView()
    
    private let padding: CGFloat = 10
    private var iconImageViewWidthConstraint: NSLayoutConstraint!
    private var iconImageViewLeadingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(pickerItem: FLCPickerItem, buttonTitle: String) {
        self.title.text = pickerItem.title
        self.subtitle.text = pickerItem.subtitle
        self.iconImageView.image = pickerItem.image != nil ? pickerItem.image : nil
        self.iconImageViewWidthConstraint.constant = pickerItem.image != nil ? 30 : 0.01
        if subtitle.text == "" { self.iconImageViewWidthConstraint.constant = 25 }
        self.iconImageViewLeadingConstraint.constant = pickerItem.image != nil ? padding * 2 : padding
        self.checkmarkImageView.image = title.text == buttonTitle ? UIImage(systemName: "checkmark") : nil
    }
    
    private func configure() {
        contentView.addSubviews(iconImageView, checkmarkImageView, title, subtitle)
        configureIconImageView()
        configureCheckmarkImageView()
        configureTitle()
        configureSubtitle()
    }
    
    private func configureIconImageView() {
        iconImageViewWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 30)
        iconImageViewLeadingConstraint = iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding * 2.5)
        
        NSLayoutConstraint.activate([
            iconImageViewLeadingConstraint,
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageViewWidthConstraint,
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ])
    }
    
    private func configureCheckmarkImageView() {        
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding * 1.5),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 25),
            checkmarkImageView.heightAnchor.constraint(equalTo: checkmarkImageView.widthAnchor)
        ])
    }
    
    private func configureTitle() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            title.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: padding),
            title.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -padding)
        ])
    }
    
    private func configureSubtitle() {
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 1),
            subtitle.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: padding),
            subtitle.trailingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: -padding),
            subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
