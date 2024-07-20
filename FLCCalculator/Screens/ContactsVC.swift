import UIKit
import MapKit

class ContactsVC: UIViewController {
    
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureMapView()
        
        DispatchQueue.main.async {
            let latitude: CLLocationDegrees = 55.712170
            let longitude: CLLocationDegrees = 37.657890

            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Центральный офис"
            self.mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            self.mapView.setRegion(region, animated: false)
        }
    }
    
    private func configure() {
        view.addSubviews(mapView)
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    private func configureMapView() {
        mapView.pinToEdges(of: view)
    }
    @objc func closeButtonPressed() { navigationController?.popViewController(animated: true) }
}
