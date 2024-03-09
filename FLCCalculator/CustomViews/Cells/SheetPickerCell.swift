import UIKit

class SheetPickerCell: UITableViewCell {
    
    static let reuseID = "SheetPickerCell"
    private let title = FLCBodyLabel(color: .label, textAlignment: .left)
    private let subtitle = FLCSubtitleLabel(color: .gray, textAlignment: .left)
    private let iconImageView = UIImageView()
    private let checkmarkImageView = UIImageView()
    private let padding: CGFloat = 12
    
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
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding * 2.5),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureCheckmarkImageView() {
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding * 2.5),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
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
