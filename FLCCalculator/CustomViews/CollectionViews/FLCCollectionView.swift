import UIKit

class FLCCollectionView: UICollectionView {
    
    private let optionsLayout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: optionsLayout)
        configure()
        setupOptionsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        dataSource = self
        delegate = self
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
    
    private func setupOptionsLayout() {
        optionsLayout.minimumInteritemSpacing = 3
        optionsLayout.scrollDirection = .horizontal
        //optionsLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
}

extension FLCCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension FLCCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 0 }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { return UICollectionViewCell() }
}
