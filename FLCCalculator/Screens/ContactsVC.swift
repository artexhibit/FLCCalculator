import UIKit
import MessageUI
import MapKit

class ContactsVC: UIViewController {
    
    private let mapView = MKMapView()
    private let facilitiesCollectionView = FacilitiesCollectionView()
    private var facilities = CalculationInfo.defaultFacilities
    
    private let padding: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureMapView()
        configureFacilitiesCollectionView()
        configureFacilitiesCollectionViewItems(items: facilities)
        
        AppleMapsManager.createPinOnTheMap(map: mapView, facility: CalculationInfo.defaultFacilities.first!)
    }
    
    private func configure() {
        view.addSubviews(mapView, facilitiesCollectionView)
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.pinToEdges(of: view)
    }
    
    private func configureFacilitiesCollectionView() {
        let height: CGFloat = DeviceTypes.isiPhoneSE3rdGen ? 280 : 250
        facilitiesCollectionView.facilitiesDelegate = self
        
        NSLayoutConstraint.activate([
            facilitiesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            facilitiesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            facilitiesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding * 6),
            facilitiesCollectionView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func configureFacilitiesCollectionViewItems(items: [FLCFacility]) {
        facilitiesCollectionView.setFacilities(facilities: items)
    }
    @objc func closeButtonPressed() { navigationController?.popViewController(animated: true) }
}

extension ContactsVC: FacilitiesCollectionViewDelegate {
    func didTapActionButton(ofType: FLCRoundButtonType, facility: FLCFacility) {
        switch ofType {
        case .phone: CalculatorManager.createPhoneCall(with: facility.phoneNumber)
        case .email: FLCMailComposeVC.sendEmailTo(email: facility.email ?? "", from: self)
        case .route: AppleMapsManager.openInAppleMaps(latitude: facility.latitude, longitude: facility.longitude, destinationName: facility.name)
        case .details:
            let facilityDetailsVC = FacilityDetailsVC(facility: facility)
            self.presentConfigurableVC(vc: facilityDetailsVC)
        case .telegram, .whatsapp, .standard: break
        }
    }
    
    func didSwipeToFacility(facility: FLCFacility) {
        AppleMapsManager.createPinOnTheMap(map: mapView, facility: facility, animated: true)
    }
}

extension ContactsVC: MKMapViewDelegate {}

extension ContactsVC: FLCMailComposeDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        handleMailComposeResult(result)
    }
}
