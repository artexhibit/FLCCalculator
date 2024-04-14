import UIKit

class FLCOptionsTableViewHeader: UITableViewHeaderFooterView {

    static let reuseID = "optionsTableViewHeader"
    
    let optionsCollectionView = FLCOptionsCollectionView()
    
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
        optionsCollectionView.pinToEdges(of: contentView, withPadding: 10, paddingType: .horizontal)
    }
}
