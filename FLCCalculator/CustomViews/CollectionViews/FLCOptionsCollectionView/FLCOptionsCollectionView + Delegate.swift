import UIKit

extension FLCOptionsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        guard let selectedLogisticsType = FLCLogisticsType(logisticsName: options[indexPath.item].title, country: pickedCountry ?? .china) else { return }
        optionsDelegate?.didChangeLogisticsType(type: selectedLogisticsType)
    }
}
