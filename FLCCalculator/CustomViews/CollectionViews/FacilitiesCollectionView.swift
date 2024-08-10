import UIKit

protocol FacilitiesCollectionViewDelegate: AnyObject {
    func didSwipeToFacility(facility: FLCFacility)
    func didTapActionButton(ofType: FLCRoundButtonType, facility: FLCFacility)
    func didStartSwipingCards()
}

final class FacilitiesCollectionView: FLCCollectionView {
    
    private var facilities = [FLCFacility]()
    private let inset: CGFloat = 15
    private var currentIndex = 0
    
    var facilitiesDelegate: FacilitiesCollectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() { decelerationRate = .fast }
    
    private func registerCell() {
        register(FacilityCell.self, forCellWithReuseIdentifier: FacilityCell.reuseID)
    }
    
    func setFacilities(facilities: [FLCFacility]) { self.facilities = facilities }
}

// MARK: Delegate
extension FacilitiesCollectionView: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = DeviceTypes.isiPhoneSE3rdGen ? 270 : 240
        return CGSize(width: UIScreen.main.bounds.width * 0.9, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.9)) / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            self.createActionMenu(with: indexPaths)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        facilitiesDelegate?.didStartSwipingCards()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = UIScreen.main.bounds.width * 0.9
        let targetXContentOffset = targetContentOffset.pointee.x
        let newPage = round(targetXContentOffset / pageWidth)
        let newOffset = newPage * pageWidth + (newPage * inset) - inset / 3
        targetContentOffset.pointee.x = newOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = UIScreen.main.bounds.width * 0.9 + inset
        let newIndex = Int((scrollView.contentOffset.x + (pageWidth / 2)) / pageWidth)
        
        if currentIndex != newIndex {
            facilitiesDelegate?.didSwipeToFacility(facility: facilities[newIndex])
            currentIndex = newIndex
        }
    }
    
    private func createActionMenu(with indexPaths: [IndexPath]) -> UIMenu {
        let copyAction = UIAction(title: ContactsVCStrings.copyAction, image: FLCIcon.copyIcon.icon) { _ in
            let pickedFacility = self.facilities[indexPaths.first?.row ?? 0]
            let addressString = "\(pickedFacility.name) \n\n \(pickedFacility.address) \n\n \(pickedFacility.workingHours) \n\n \(pickedFacility.phoneNumber) \n \(pickedFacility.email ?? "")"
            UIPasteboard.general.string = addressString
        }
        return UIMenu(title: "", children: [copyAction])
    }
}

// MARK: DataSource
extension FacilitiesCollectionView {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        facilities.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FacilityCell.reuseID, for: indexPath) as? FacilityCell else { return UICollectionViewCell() }
        cell.set(with: facilities[indexPath.item])
        cell.delegate = self
        return cell
    }
}

extension FacilitiesCollectionView: FacilityCellDelegate {
    func didTapActionButton(ofType: FLCRoundButtonType, facility: FLCFacility) {
        facilitiesDelegate?.didTapActionButton(ofType: ofType, facility: facility)
    }
}
