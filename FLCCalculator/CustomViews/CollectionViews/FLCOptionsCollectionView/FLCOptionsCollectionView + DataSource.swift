import UIKit

extension FLCOptionsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FLCOptionsCollectionViewCell.reuseID, for: indexPath) as? FLCOptionsCollectionViewCell else { return UICollectionViewCell() }
        cell.set(with: options[indexPath.row])
        return cell
    }
}
