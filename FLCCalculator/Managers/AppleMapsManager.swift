import Foundation
import MapKit

struct AppleMapsManager {
    static func createPinOnTheMap(map: MKMapView, facility: FLCFacility, animated: Bool = false) {
        let eurasiaRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: 60.0), latitudinalMeters: 15000000, longitudinalMeters: 15000000)
        
        map.removeAnnotations(map.annotations)
        DispatchQueue.main.async {
            zoomOutToContinent(map: map, continent: eurasiaRegion, animated: animated) {
                let coordinate = CLLocationCoordinate2D(latitude: facility.latitude, longitude: facility.longitude)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = facility.name
                map.addAnnotation(annotation)
                
                let newCenterCoordinate = CLLocationCoordinate2D(latitude: facility.latitude - 0.0020, longitude: facility.longitude)
                let region = MKCoordinateRegion(center: newCenterCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                map.setRegion(region, animated: animated)
            }
        }
    }
    
    static func zoomOutToContinent(map: MKMapView, continent: MKCoordinateRegion, animated: Bool, completion: @escaping () -> Void) {
        if animated {
            map.setRegion(continent, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { completion() }
        } else {
            completion()
        }
    }
    
    static func openInAppleMaps(latitude: Double, longitude: Double, destinationName: String) {
        let destination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        
        mapItem.name = destinationName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
