import UIKit

class PermissionsCell: UITableViewCell {
    
    static let reuseID = "PermissionsCell"
    
    private let padding: CGFloat = 18
    
    private let headlineLabel = FLCBodyLabel(color: .flcGray, textAlignment: .left)
    private let permissionsStackView = UIStackView()
    private let footerLabel = FLCSubtitleLabel(color: .flcGray, textAlignment: .left, textStyle: .callout)
    
    private let permissions: [PermissionItem] = [
        PermissionItem(icon: Icons.bellBadge, iconBackgroundColor: .systemRed, title: "Уведомления", subtitle: "Сможем оповещать об изменениях в тарифах и акциях")
    ]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureHeadlineLabel()
        configurePermissionsStackView()
        configureFooterLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubviews(headlineLabel, permissionsStackView, footerLabel)
        selectionStyle = .none
    }
    
    private func configureHeadlineLabel() {
        headlineLabel.text = "Данные разрешения необходимы для оптимальной работы приложения. Ознакомьтесь с их описанием"
        
        NSLayoutConstraint.activate([
            headlineLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            headlineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            headlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configurePermissionsStackView() {
        permissionsStackView.translatesAutoresizingMaskIntoConstraints = false
        permissionsStackView.axis = .vertical
        permissionsStackView.distribution = .fillEqually
        permissionsStackView.spacing = 0
        permissionsStackView.alignment = .center
        permissionsStackView.layer.cornerRadius = 15
        permissionsStackView.clipsToBounds = true
        
        permissions.forEach { permissionItem in
            let permissionView = PermissionView(item: permissionItem)
            permissionsStackView.addArrangedSubview(permissionView)
        }
        
        NSLayoutConstraint.activate([
            permissionsStackView.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: padding),
            permissionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            permissionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            permissionsStackView.bottomAnchor.constraint(equalTo: footerLabel.topAnchor, constant: -padding / 2)
        ])
    }
    
    private func configureFooterLabel() {
        footerLabel.text = "Без этого приложение может работать нестабильно. Вы всегда можете изменить решение в настройках"
        
        NSLayoutConstraint.activate([
            footerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding * 1.5),
            footerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding * 1.5),
            footerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
