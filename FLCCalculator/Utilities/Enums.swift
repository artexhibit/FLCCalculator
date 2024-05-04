import Foundation

enum FLCPopupViewStyle { case error, normal, spinner }
enum FLCPopupViewPosition { case top, bottom }
enum FLCProgressViewOption { case increase, decrease }
enum FLCListPickerSortType { case byTitle, bySubtitle }
enum FLCListPickerSearchType { case onlyByTitle, onlyBySubtitle, both }
enum FLCGoToViewDirections { case forward, backward }
enum FLCSection { case main }
enum FLCTextViewLabelImagePlacing { case afterText, beforeText }
enum FLCPopoverPosition { case top, bottom }
enum FLCTotalType { case perKG, asOneCurrency }
enum FLCPaddingType { case horizontal, vertical, all }
enum FLCConfettiShape { case rectangle, circle }
enum FLCConfettiPosition { case foreground, background }
enum FLCUsefulInfoSections { case managerContacts, usefulInfo }
enum FLCNetworkingAvailabilityStatus { case connected, noConnection, requiresConnection, unknown }

enum FLCBackgroundFetchId: String {
    case updateCurrencyDataTaskId = "ru.igorcodes.FLCCalculator.updateCurrencyData"
    case updateCalculationData = "ru.igorcodes.FLCCalculator.updateCalculationData"
    case updateManagerData = "ru.igorcodes.FLCCalculator.updateManagerData"
}

enum FLCCountryOption: String {
    case china = "Китай"
    case turkey = "Турция"
    
    var engName: String {
        switch self {
        case .china: return "china"
        case .turkey: return "turkey"
        }
    }
    var shortCode: String {
        switch self {
        case .china: return "CNY"
        case .turkey: return "TRY"
        }
    }
}

enum FLCWarehouse: String, CaseIterable {
    case guangzhou = "Guangzhou"
    case shanghai = "Shanghai"
    case istanbul = "Istanbul"
    
    var rusName: String {
        switch self {
        case .guangzhou: return "Гуанчжоу"
        case .shanghai: return "Шанхай"
        case .istanbul: return "Стамбул"
        }
    }
}

enum FLCCalculationResultCellType: Int {
    case russianDelivery = 1
    case insurance = 2
    case deliveryFromWarehouse = 3
    case cargoHandling = 4
    case customsClearancePrice = 5
    case customsWarehouseServices = 6
    case deliveryToWarehouse = 7
    case groupageDocs = 8
}

enum FLCMarkupType: Double {
    case seventeenPercents = 1.17
}

enum FLCCurrency: String, CaseIterable {
    case RUB = "RUB"
    case USD = "USD"
    case EUR = "EUR"
    case TRY = "TRY"
    case CNY = "CNY"
    
    var symbol: String {
        switch self {
        case .RUB: return "₽"
        case .USD: return "$"
        case .EUR: return "€"
        case .TRY: return "₺"
        case .CNY: return "¥"
        }
    }
    
    init?(currencyCode: String) {
        switch currencyCode {
        case "RUB": self = .RUB
        case "USD": self = .USD
        case "EUR": self = .EUR
        case "TRY": self = .TRY
        case "CNY": self = .CNY
        default: return nil
        }
    }
}

enum FLCSalesManager: String, CaseIterable {
    case igorVolkov = "Игорь Волков"
}

enum FLCLogisticsType: String, CaseIterable {
    case chinaTruck = "chinaTruck"
    case chinaRailway = "chinaRailway"
    case chinaAir = "chinaAir"
    case turkeyTruck = "turkeyTruck"
    
    static func firstCase(for country: FLCCountryOption) -> FLCLogisticsType? {
        switch country {
        case .china:
            return .chinaTruck
        case .turkey:
            return .turkeyTruck
        }
    }
    
    init?(logisticsName: String, country: FLCCountryOption) {
        switch country {
        case .china:
            switch logisticsName {
            case "Авто": self = .chinaTruck
            case "ЖД": self = .chinaRailway
            case "Авиа": self = .chinaAir
            default: return nil
            }
        case .turkey:
            switch logisticsName {
            case "Авто+Паром": self = .turkeyTruck
            default: return nil
            }
        }
    }
}

enum FLCDateFormat: String {
    case dashYMD = "yyyy-MM-dd"
    case dotDMY = "dd.MM.yyyy"
    case slashYMD = "yyyy/MM/dd"
    case slashDMY = "dd/MM/yyyy"
}
