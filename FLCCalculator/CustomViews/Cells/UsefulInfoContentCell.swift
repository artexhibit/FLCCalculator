import UIKit

class UsefulInfoContentCell: UITableViewCell {
    
    static let reuseID = "UsefulInfoContentCell"
    private let padding: CGFloat = 14
    
    private let iconBackgroundView = UIView()
    private var iconImageView = UIImageView()
    private let titleLabel = FLCBodyLabel(color: .label, textAlignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureIconBackgroundView()
        configureIconImageView()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with content: UsefulInfoContent) {
        iconImageView.image = content.image
        iconBackgroundView.backgroundColor = content.color
        titleLabel.text = content.title
    }
    
    private func configure() {
        contentView.addSubviews(iconBackgroundView, titleLabel)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
    
    private func configureIconBackgroundView() {
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        iconBackgroundView.addSubview(iconImageView)
        iconBackgroundView.layer.cornerRadius = 7
        
        NSLayoutConstraint.activate([
            iconBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            iconBackgroundView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 30),
            iconBackgroundView.heightAnchor.constraint(equalTo: iconBackgroundView.widthAnchor)
        ])
    }
    
    private func configureIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ])
    }
    
    private func configureTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding / 2),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
