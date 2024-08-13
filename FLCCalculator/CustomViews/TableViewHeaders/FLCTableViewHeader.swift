import UIKit

class FLCTableViewHeader: UITableViewHeaderFooterView {

    static let reuseID = String(describing: FLCTableViewHeader.self)
    
    private let titleLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 20)
    
    private let padding: CGFloat = 10
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) { self.titleLabel.text = title }
    
    private func configure() {
        contentView.addSubview(titleLabel)
    }
    
    private func configureTitleLabel() {
        let bottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        bottomConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            bottomConstraint
        ])
    }
}
