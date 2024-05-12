import UIKit

final class DocumentsCollectionView: FLCCollectionView {
    
    private var documents = [FLCDocument]()
    
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
    func setDocuments(documents: [FLCDocument]) { self.documents = documents }
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
        cell.set(with: documents[indexPath.row])
        return cell
    }
}
