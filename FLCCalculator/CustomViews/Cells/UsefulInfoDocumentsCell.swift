import UIKit

class UsefulInfoDocumentsCell: UITableViewCell {
    
    static let reuseID = "UsefulInfoDocumentsCell"
    
    private let documentsCollectionView = DocumentsCollectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureDocumentsCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(documentsCollectionView)
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }
    private func configureDocumentsCollectionView() { documentsCollectionView.pinToEdges(of: contentView) }
    
    func setDocuments(documents: [Document], canRemoveShimmer: Bool) {
        documentsCollectionView.setDocuments(documents: documents, canRemoveShimmer: canRemoveShimmer)
    }
}
