import UIKit

enum Icons {
    static let questionMark = UIImage(systemName: "questionmark.circle.fill") ?? UIImage()
    static let infoSign = UIImage(systemName: "info.circle.fill") ?? UIImage()
    static let truck = UIImage(systemName: "truck.box") ?? UIImage()
    static let xmark = UIImage(systemName: "xmark") ?? UIImage()
    static let warehouse = UIImage(systemName: "door.garage.closed") ?? UIImage()
}

enum Keys {
    static let tariffs = "tariffs"
    static let currencyData = "currencyData"
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    static let isiPhoneSE1stGen = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhoneSE3rdGen = idiom == .phone && ScreenSize.maxLength == 667.0
}
