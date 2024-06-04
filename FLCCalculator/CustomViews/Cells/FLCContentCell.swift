import UIKit

class FLCContentCell: UITableViewCell {

    let iconBackgroundView = UIView()
    var iconImageView = UIImageView()
    let titleLabel = FLCBodyLabel(color: .label, textAlignment: .left)
    
    let padding: CGFloat = 14
    
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
    
    private func configure() {
        contentView.addSubviews(iconBackgroundView, titleLabel)
        contentView.backgroundColor = .clear
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
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
