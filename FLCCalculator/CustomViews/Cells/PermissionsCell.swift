import UIKit

protocol PermissionsCellDelegate: AnyObject {
    func didTapPermissionButton(_ type: FLCPermissionType)
}

class PermissionsCell: UITableViewCell {
    
    static let reuseID = String(describing: PermissionsCell.self)
    
    private let padding: CGFloat = 18
    
    private let headlineLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 18, weight: .medium)
    private let permissionsStackView = UIStackView()
    private let footerLabel = FLCSubtitleLabel(color: .flcGray, textAlignment: .left, textStyle: .callout)
    
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
        contentView.addSubviews(headlineLabel, permissionsStackView)
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
        permissionsStackView.distribution = .fillEqually
        permissionsStackView.spacing = 0
        permissionsStackView.alignment = .center
        
        permissions.forEach { permissionItem in
            let permissionView = PermissionView(item: permissionItem)
            permissionView.delegate = self
            permissionsStackView.addArrangedSubview(permissionView)
            
            NSLayoutConstraint.activate([
                permissionView.widthAnchor.constraint(equalTo: permissionsStackView.widthAnchor)
            ])
        }
        permissionsStackView.addArrangedSubview(footerLabel)
        
        NSLayoutConstraint.activate([
            permissionsStackView.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: padding),
            permissionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            permissionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            permissionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureFooterLabel() {
        footerLabel.text = PermissionsStrings.footerLabel
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
