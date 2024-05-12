import UIKit

class OptionsTableViewHeader: UITableViewHeaderFooterView {

    static let reuseID = "optionsTableViewHeader"
    
    let optionsCollectionView = OptionsCollectionView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        configureOptionsCollectionsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(optionsCollectionView)
    }
    
    private func configureOptionsCollectionsView() {
        optionsCollectionView.pinToEdges(of: contentView, withPadding: 7, paddingType: .horizontal)
    }
}
