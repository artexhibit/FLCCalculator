import UIKit

struct FLCCountryPhonesData {
    let countryName: String
    let phoneCode: String
    let phoneMask: String
    let icon: UIImage
    let country: FLCUserCountry
    let countryCode: String
    
    
    func convertToPickerItem() -> FLCPickerItem {
        let userSystemCountryCode = Locale.current.region?.identifier ?? "RU"
        let shoulDisplayOnTop = countryCode == userSystemCountryCode ? true : false
        return FLCPickerItem(title: countryName, subtitle: phoneCode, image: icon, shouldDisplayOnTop: shoulDisplayOnTop)
    }
}
