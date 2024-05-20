import UIKit

protocol OptionsCollectionViewDelegate: AnyObject {
    func didChangeLogisticsType(type: FLCLogisticsType)
}

final class OptionsCollectionView: FLCCollectionView {
    
    private var options = [FLCLogisticsOption]()
    private var pickedCountry: FLCCountryOption?
    
    var optionsDelegate: OptionsCollectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registerCell()
        setupOptionsLayout()
        setupInsets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerCell() { register(OptionsCell.self, forCellWithReuseIdentifier: OptionsCell.reuseID) }
    
    override func setupOptionsLayout() {
        super.setupOptionsLayout()
        
        let layout = getLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    func setOptions(options: [FLCLogisticsOption], pickedLogisticsType: FLCLogisticsType) {
        self.options = options
        
        guard let index = self.options.firstIndex(where: { $0.type == pickedLogisticsType }) else { return }
        selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: [])
    }
    private func setupInsets() { contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18) }
    func setPickedCountry(country: FLCCountryOption?) { self.pickedCountry = country }
}

// MARK: Delegate
extension OptionsCollectionView {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        guard let selectedLogisticsType = FLCLogisticsType(logisticsName: options[indexPath.item].title, country: pickedCountry ?? .china) else { return }
        optionsDelegate?.didChangeLogisticsType(type: selectedLogisticsType)
    }
}

// MARK: DataSource
extension OptionsCollectionView {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        options.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionsCell.reuseID, for: indexPath) as? OptionsCell else { return UICollectionViewCell() }
        cell.set(with: options[indexPath.row])
        return cell
    }
}
