import UIKit

protocol PermissionsCellDelegate: AnyObject {
    func didTapPermissionButton(_ type: FLCPermissionType)
}

class PermissionsCell: UITableViewCell {
    
    static let reuseID = String(describing: PermissionsCell.self)
    
    private let padding: CGFloat = 18
    
    private let headlineLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 18, weight: .medium)
    private let permissionsStackView = UIStackView()
    private let footerLabel = FLCSubtitleLabel(color: .flcGray, textAlignment: .left, textStyle: .caption1)
    
    weak var delegate: PermissionsCellDelegate?
    
    private let permissions: [PermissionItem] = [
        PermissionItem(type: .notifications, icon: FLCIcon.bellBadge.icon, iconBackgroundColor: .systemRed, title: PermissionsStrings.notifications, subtitle: PermissionsStrings.notificationsSubtitle)
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
        headlineLabel.text = PermissionsStrings.configureHeadlineLabel
        
        NSLayoutConstraint.activate([
            headlineLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            headlineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            headlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configurePermissionsStackView() {
        permissionsStackView.translatesAutoresizingMaskIntoConstraints = false
        permissionsStackView.axis = .vertical
        permissionsStackView.distribution = .fill
        permissionsStackView.spacing = 5
        permissionsStackView.alignment = .center
        
        permissions.forEach { permissionItem in
            let permissionView = PermissionView(item: permissionItem)
            permissionView.delegate = self
            permissionsStackView.addArrangedSubview(permissionView)
            
            NSLayoutConstraint.activate([
                permissionView.widthAnchor.constraint(equalTo: permissionsStackView.widthAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            permissionsStackView.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: padding),
            permissionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            permissionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureFooterLabel() {
        footerLabel.text = PermissionsStrings.footerLabel
        
        NSLayoutConstraint.activate([
            footerLabel.topAnchor.constraint(equalTo: permissionsStackView.bottomAnchor, constant: padding / 2),
            footerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding * 1.2),
            footerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            footerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension PermissionsCell: PermissionViewDelegate {
    func didTapPermissionButton(_ type: FLCPermissionType) { delegate?.didTapPermissionButton(type) }
}

extension PermissionsCell: PermissionsVCDelegate {
    func shouldUpdatePermissionButtonWithStatus(status: Bool, type: FLCPermissionType) {
        DispatchQueue.main.async {
            self.permissionsStackView.arrangedSubviews
                .compactMap({ $0 as? PermissionView })
                .filter({ $0.getType() == type })
                .forEach({ $0.updatePermissionButtonUI(with: status) })
        }
    }
}
