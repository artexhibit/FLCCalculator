import Foundation
import MapKit

struct MapsManager {
    static func createPinOnTheMap(map: MKMapView, facility: FLCFacility, animated: Bool = false) {
        let eurasiaRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: 60.0), latitudinalMeters: 15000000, longitudinalMeters: 15000000)
        
        map.removeAnnotations(map.annotations)
        DispatchQueue.main.async {
            zoomOutToContinent(map: map, continent: eurasiaRegion, animated: animated) {
                let deviceLanguageCode = LanguageManager.shared.currentDeviceLanguage.rawValue
                let coordinate = CLLocationCoordinate2D(latitude: facility.latitude, longitude: facility.longitude)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = facility.localisationData?[deviceLanguageCode]?.name
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

    static func openInYandexMaps(latitude: Double, longitude: Double) {
        guard let appURL = URL(string: "yandexmaps://maps.yandex.ru/?rtext=~\(latitude),\(longitude)&rtt=auto") else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantOpenMaps, style: .error)
            return
        }
        guard let webURL = URL(string: "https://maps.yandex.ru/?rtext=~\(latitude),\(longitude)&rtt=auto") else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantOpenMaps, style: .error)
            return
        }
        
        let url = UIApplication.shared.canOpenURL(appURL) ? appURL : webURL
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func openInGoogleMaps(latitude: Double, longitude: Double) {
        guard let appURL = URL(string: "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving") else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantOpenMaps, style: .error)
            return
        }
        guard let webURL = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(latitude),\(longitude)&travelmode=driving") else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantOpenMaps, style: .error)
            return
        }
        
        let url = UIApplication.shared.canOpenURL(appURL) ? appURL : webURL
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
