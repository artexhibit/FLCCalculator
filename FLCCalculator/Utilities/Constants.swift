import UIKit

enum Icons {
    static let questionMark = UIImage(systemName: "questionmark.circle.fill") ?? UIImage()
    static let exclamationMark = UIImage(systemName: "exclamationmark.circle.fill") ?? UIImage()
    static let checkmark = UIImage(systemName: "checkmark") ?? UIImage()
    static let infoSign = UIImage(systemName: "info.circle.fill") ?? UIImage()
    static let truck = UIImage(systemName: "truck.box") ?? UIImage()
    static let ship = UIImage(systemName: "ferry.fill") ?? UIImage()
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
    static let hapticPhone = UIImage(systemName: "iphone.gen3.radiowaves.left.and.right") ?? UIImage()
    static let chevronUpDown = UIImage(systemName: "chevron.up.chevron.down") ?? UIImage()
    static let circleHalfRight = UIImage(systemName: "circle.righthalf.filled.inverse") ?? UIImage()
    static let bellBadge = UIImage(systemName: "bell.badge.fill") ?? UIImage()
    static let key = UIImage(systemName: "key.horizontal") ?? UIImage()
}

enum Keys {
    static let isUserLoggedIn = "isUserLoggedIn"
    static let permissionsScreenWasShown = "permissionsScreenWasShown"
    static let isHapticTurnedOn = "isHapticTurnedOn"
    static let isFirstLaunch = "isFirstLaunch"
    static let appTheme = "appTheme"
    static let managers = "managers"
    static let tariffs = "tariffs"
    static let pickups = "pickups"
    static let documents = "documents"
    static let availableLogisticsTypes = "availableLogisticsTypes"
    static let logisticsTypes = "logisticsTypes"
    static let chinaTruckTariff = "chinaTruckTariff"
    static let chinaTruckPickup = "chinaTruckPickup"
    static let chinaRailwayPickup = "chinaRailwayPickup"
    static let chinaAirPickup = "chinaAirPickup"
    static let turkeyAirVKOPickup = "turkeyAirVKOPickup"
    static let turkeyAirSVOPickup = "turkeyAirSVOPickup"
    static let turkeyTruckByFerryPickup = "turkeyTruckByFerryPickup"
    static let turkeyNovorossiyskBySeaTariff = "turkeyNovorossiyskBySeaTariff"
    static let turkeyNovorossiyskBySeaPickup = "turkeyNovorossiyskBySeaPickup"
    static let chinaRailwayTariff = "chinaRailwayTariff"
    static let chinaAirTariff = "chinaAirTariff"
    static let turkeyAirVKOTariff = "turkeyAirVKOTariff"
    static let turkeyAirSVOTariff = "turkeyAirSVOTariff"
    static let turkeyTruckByFerryTariff = "turkeyTruckByFerryTariff"
    static let dateWhenDataWasUpdated = "dateWhenDataWasUpdated"
    static let calculations = "calculations"
    static let lastCurrencyDataUpdate = "lastCurrencyDataUpdate"
    static let lastCalculationDataUpdate = "lastCalculationDataUpdate"
    static let lastManagerDataUpdate = "lastManagerDataUpdate"
    static let lastDocumentsDataUpdate = "lastDocumentsDataUpdate"
    static let lastAvailableLogisticsTypesDataUpdate = "lastAvailableLogisticsTypesDataUpdate"
    static let smsCounter = "smsCounter"
    static let flcUser = "flcUser"
    static let calculationDataFirebaseRecord = "calculationDataFirebaseRecord"
    static let cdDataAttribute = "data"
    static let cdDocuments = "CDDocuments"
    static let cdAvailableLogisticsTypes = "CDAvailableLogisticsTypes"
    static let cdManagers = "CDManagers"
    static let cdChinaTruckTariff = "CDChinaTruckTariff"
    static let cdChinaRailwayTariff = "CDChinaRailwayTariff"
    static let cdChinaAirTariff = "CDChinaAirTariff"
    static let cdTurkeyAirVKOTariff = "CDTurkeyAirVKOTariff"
    static let cdTurkeyAirSVOTariff = "CDTurkeyAirSVOTariff"
    static let cdTurkeyTruckByFerryTariff = "CDTurkeyTruckByFerryTariff"
    static let cdTurkeyNovorossiyskBySeaTariff = "CDTurkeyNovorossiyskBySeaTariff"
    static let cdChinaTruckPickup = "CDChinaTruckPickup"
    static let cdChinaRailwayPickup = "CDChinaRailwayPickup"
    static let cdChinaAirPickup = "CDChinaAirPickup"
    static let cdTurkeyAirVKOPickup = "CDTurkeyAirVKOPickup"
    static let cdTurkeyAirSVOPickup = "CDTurkeyAirSVOPickup"
    static let cdTurkeyTruckByFerryPickup = "CDTurkeyTruckByFerryPickup"
    static let cdTurkeyNovorossiyskBySeaPickup = "CDTurkeyNovorossiyskBySeaPickup"
    static let cdCurrencyData = "CDCurrencyData"
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

enum ProfileSettingsTextFieldsNames {
    static let fio = "ФИО"
    static let dateOfBirth = "Дата рождения"
    static let phoneNumber = "Номер телефона"
    static let email = "Email"
    static let companyName = "Название юр. лица"
    static let inn = "ИНН"
    static let dtCount = "Количество оформленных ДТ за год"
}

enum FLCBubbleUserDataKeys {
    static let bday = "bday"
    static let company = "company"
    static let dtCount = "dt_count"
    static let fio = "fio"
    static let inn = "inn"
    static let phone =  "phone"
    static let email =  "email_user"
}
