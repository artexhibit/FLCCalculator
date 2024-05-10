import UIKit

protocol FLCOptionsCollectionViewDelegate: AnyObject {
    func didChangeLogisticsType(type: FLCLogisticsType)
}

final class FLCOptionsCollectionView: UICollectionView {
    
    private let optionsLayout = UICollectionViewFlowLayout()
    var options = [FLCLogisticsOption]()
    var pickedCountry: FLCCountryOption?
    
    var optionsDelegate: FLCOptionsCollectionViewDelegate?

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
    
    func setOptions(options: [FLCLogisticsOption], pickedLogisticsType: FLCLogisticsType) {
        self.options = options
        
        guard let index = self.options.firstIndex(where: { $0.type == pickedLogisticsType }) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
}
