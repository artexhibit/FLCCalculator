import UIKit

final class DocumentsCollectionView: FLCCollectionView {
    
    private var documents = [Document]()
    private var canRemoveShimmer = false
    private var storedDocuments: [Document]? { get { PersistenceManager.retrieveItemsFromUserDefaults() } }
    private var documentsDownloadProgress: [IndexPath: Int] = [:]
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registerCell()
        setupInsets()
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
    private func setupInsets() { contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) }
}

// MARK: Delegate
extension DocumentsCollectionView: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let doc = documents[indexPath.item]
        
        if FileSystemManager.isHavingDocument(with: doc.fileName) {
            guard let url = FileSystemManager.getLocalFileURL(for: doc.fileName) else { return }
            FileSystemManager.openDocument(with: url, in: self)
        } else {
            self.documentsDownloadProgress.removeValue(forKey: indexPath)
            
            FirebaseManager.downloadDocument(doc: doc) { result in
                guard let progress = result.progress, let url = result.url else { return }
                
                if self.documentsDownloadProgress[indexPath] != 100 {
                    self.documentsDownloadProgress[indexPath] = progress
                    
                    DispatchQueue.main.async {
                        UIView.performWithoutAnimation { self.reloadItems(at: [indexPath]) }
                    }
                    if progress == 100 {
                        HapticManager.addSuccessHaptic()
                        FileSystemManager.openDocument(with: url, in: self)
                    }
                }
            }
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 150)
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
        cell.setupDownloadPercentageLabel(with: documentsDownloadProgress[indexPath])
        cell.setupDownloadedDocumentIcon(with: documents[indexPath.row], progress: documentsDownloadProgress[indexPath])
        if storedDocuments == nil { cell.addShimmerAnimation() }
        return cell
    }
}

extension DocumentsCollectionView: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.findParentViewController() ?? UIViewController()
    }
}
