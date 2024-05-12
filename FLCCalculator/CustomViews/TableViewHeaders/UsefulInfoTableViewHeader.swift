import UIKit

class UsefulInfoTableViewHeader: UITableViewHeaderFooterView {

    static let reuseID = "usefulInfoTableViewHeader"
    
    private let titleLabel = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 20)
    
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
        titleLabel.pinToEdges(of: contentView, withPadding: 10, paddingType: .vertical)
    }
}
