import UIKit

class SettingsProfileCell: UITableViewCell {
    
    static let reuseID = "SettingsProfileCell"
    private let padding: CGFloat = 14
    
    private var personIcon = FLCTintedButton(color: .flcOrange, systemImageName: "person", cornerStyle: .capsule)
    private let labelsContainer = UIView()
    private let titleLabel = FLCTitleLabel(color: .flcOrange, textAlignment: .left, size: 19, weight: .semibold)
    private let subtitleLabel = FLCSubtitleLabel(color: .flcGray, textAlignment: .left, textStyle: .body)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configurePersonIcon()
        configureLabelsContainer()
        configureTitleLabel()
        configureSubtitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with user: FLCUser?) {
        titleLabel.text = user?.name ?? ""
        subtitleLabel.text = user?.mobilePhone ?? ""
    }
    
    private func configure() {
        contentView.addSubviews(personIcon, labelsContainer)
        contentView.backgroundColor = .clear
        accessoryType = .disclosureIndicator
    }
    
    private func configurePersonIcon() {
        personIcon.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            personIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            personIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            personIcon.widthAnchor.constraint(equalToConstant: 60),
            personIcon.heightAnchor.constraint(greaterThanOrEqualTo: personIcon.widthAnchor),
            personIcon.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureLabelsContainer() {
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubviews(titleLabel, subtitleLabel)
        
        NSLayoutConstraint.activate([
            labelsContainer.centerYAnchor.constraint(equalTo: personIcon.centerYAnchor),
            labelsContainer.leadingAnchor.constraint(equalTo: personIcon.trailingAnchor, constant: padding),
            labelsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: padding),
        ])
    }
    
    private func configureTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
        ])
    }
    
    private func configureSubtitleLabel() {
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor)
        ])
    }
}
