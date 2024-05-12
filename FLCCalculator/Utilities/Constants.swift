import UIKit

enum Icons {
    static let questionMark = UIImage(systemName: "questionmark.circle.fill") ?? UIImage()
    static let exclamationMark = UIImage(systemName: "exclamationmark.circle.fill") ?? UIImage()
    static let infoSign = UIImage(systemName: "info.circle.fill") ?? UIImage()
    static let truck = UIImage(systemName: "truck.box") ?? UIImage()
    static let xmark = UIImage(systemName: "xmark") ?? UIImage()
    static let map = UIImage(systemName: "map") ?? UIImage()
    static let document = UIImage(systemName: "doc.plaintext") ?? UIImage()
    static let clock = UIImage(systemName: "clock") ?? UIImage()
    static let dots = UIImage(systemName: "ellipsis.circle.fill") ?? UIImage()
    static let truckFill = UIImage(systemName: "truck.box.fill") ?? UIImage()
    static let train = UIImage(systemName: "train.side.front.car") ?? UIImage()
    static let plane = UIImage(systemName: "airplane") ?? UIImage()
    static let phone = UIImage(systemName: "phone.fill") ?? UIImage()
    static let envelope = UIImage(systemName: "envelope.fill") ?? UIImage()
    static let telegram = UIImage(resource: .telegram)
    static let whatsapp = UIImage(resource: .whatsappFill)
    static let trashBin = UIImage(systemName: "trash") ?? UIImage()
    static let circle = UIImage(systemName: "circle.slash") ?? UIImage()
    static let rubleSign = UIImage(systemName: "rublesign.arrow.circlepath") ?? UIImage()
    static let person = UIImage(systemName: "person") ?? UIImage()
}

enum Keys {
    static let managers = "managers"
    static let tariffs = "tariffs"
    static let chinaPickup = "chinaPickup"
    static let turkeyPickup = "turkeyPickup"
    static let currencyData = "currencyData"
    static let dateWhenDataWasUpdated = "dateWhenDataWasUpdated"
    static let lastCurrencyDataUpdate = "lastCurrencyDataUpdate"
    static let lastCalculationDataUpdate = "lastCalculationDataUpdate"
    static let lastManagerDataUpdate = "lastManagerDataUpdate"
}

enum WarehouseStrings {
    static let russianWarehouseCity = "Склад Подольск"
    static let chinaWarehouse = "Склад Китай"
    static let turkeyWarehouse = "Склад Стамбул"
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

enum Cities {
    static let istanbul = "Istanbul"
}
