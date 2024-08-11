import Foundation
import MapKit

struct ContactsVCHelper {
    static func getFacilities() async -> [FLCFacility] {
        do {
            if let storedFacilities: [FLCFacility] = CoreDataManager.retrieveItemsFromCoreData() {
                return storedFacilities
            } else {
                let facilities: [FLCFacility] = try await FirebaseManager.getDataFromFirebase() ?? [CalculationInfo.defaultFacility]
                let _ = CoreDataManager.updateItemsInCoreData(items: facilities)
                return facilities
            }
        } catch {
            return []
        }
    }
    
    @MainActor
    static func updateFacilitiesUI(in collectionView: FacilitiesCollectionView, map: MKMapView) {
        FLCPopupView.showOnMainThread(title: FLCPopupMessages.downloadData, style: .spinner, position: .top)
        collectionView.layer.opacity = 0
        
        Task {
            let facilities = await ContactsVCHelper.getFacilities()
            configureFacilitiesCollectionViewItems(items: facilities, in: collectionView)
            collectionView.layer.opacity = 1
            MapsManager.createPinOnTheMap(map: map, facility: facilities.first ?? CalculationInfo.defaultFacility)
            FLCPopupView.removeFromMainThread()
        }
    }
    
    private static func configureFacilitiesCollectionViewItems(items: [FLCFacility], in collectionView: FacilitiesCollectionView) {
        collectionView.setFacilities(facilities: items)
        collectionView.reloadData()
    }
    
    static func showRoutesOptions(for facility: FLCFacility) -> UIMenu {
        let appleMapsAction = UIAction(title: ContactsVCStrings.appleMaps, image: FLCIcon.location.icon) { _ in
            MapsManager.openInAppleMaps(latitude: facility.latitude, longitude: facility.longitude, destinationName: facility.name)
        }
        let yandexMapsAction = UIAction(title: ContactsVCStrings.yandexMaps, image: FLCIcon.location.icon) { _ in
            MapsManager.openInYandexMaps(latitude: facility.latitude, longitude: facility.longitude)
        }
        let googleMapsAction = UIAction(title: ContactsVCStrings.googleMaps, image: FLCIcon.location.icon) { _ in
            MapsManager.openInGoogleMaps(latitude: facility.latitude, longitude: facility.longitude)
        }
        return UIMenu(title: "", children: [appleMapsAction, yandexMapsAction, googleMapsAction])
    }
    
    private static func popoverWasShown() -> Bool {
        UserDefaultsManager.onboardingPopovers[OnboardingDictKeys.contactsVCPopoverWasShown] ?? false
    }
    
    static func setupOnboardingPopover(in vc: UIViewController, target: UICollectionView) {
        if !popoverWasShown() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                FLCPopoverVC().showPopoverOnMainThread(withText: PopoverMessages.switchCardsBySwipe, in: vc, target: target)
                UserDefaultsManager.onboardingPopovers[OnboardingDictKeys.contactsVCPopoverWasShown] = true
            }
        } else {
            guard let popoverVC = vc.findViewController(ofType: FLCPopoverVC.self) else { return }
            popoverVC.hidePopoverFromMainThread()
        }
    }
}
