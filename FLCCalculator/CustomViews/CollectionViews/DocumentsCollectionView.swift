import UIKit

final class DocumentsCollectionView: FLCCollectionView {
    
    private var documents = [Document]()
    private var canRemoveShimmer = false
    private var storedDocuments: [Document]? { get { PersistenceManager.retrieveItemsFromUserDefaults() } }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registerCell()
        configure()
    }
    
    override func configure() {
        super.configure()
        contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerCell() {
        register(DocumentsCell.self, forCellWithReuseIdentifier: DocumentsCell.reuseID)
    }
    
    func setDocuments(documents: [Document], canRemoveShimmer: Bool) {
        self.documents = documents
        self.canRemoveShimmer = canRemoveShimmer
    }
}

// MARK: Delegate
extension DocumentsCollectionView {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: DataSource
extension DocumentsCollectionView {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        documents.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocumentsCell.reuseID, for: indexPath) as? DocumentsCell else { return UICollectionViewCell() }
        cell.set(with: documents[indexPath.row], canRemoveShimmer: canRemoveShimmer)
        if storedDocuments == nil { cell.addShimmerAnimation() }
        return cell
    }
}
