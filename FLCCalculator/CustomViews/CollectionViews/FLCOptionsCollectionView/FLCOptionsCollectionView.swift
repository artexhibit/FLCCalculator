import UIKit

final class FLCOptionsCollectionView: UICollectionView {
    
    private let optionsLayout = UICollectionViewFlowLayout()
    var options = [FLCLogisticsOption]()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: optionsLayout)
        configure()
        setupOptionsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        dataSource = self
        delegate = self
        register(FLCOptionsCollectionViewCell.self, forCellWithReuseIdentifier: FLCOptionsCollectionViewCell.reuseID)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        bounces = true
        showsHorizontalScrollIndicator = false
    }
    
    private func setupOptionsLayout() {
        optionsLayout.minimumInteritemSpacing = 3
        optionsLayout.scrollDirection = .horizontal
        optionsLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    func setOptions(options: [FLCLogisticsOption]) {
        self.options = options
        selectItem(at: [0, 0], animated: false, scrollPosition: [])
    }
}
