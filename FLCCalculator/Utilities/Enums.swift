import Foundation

enum FLCPopupViewStyle { case error, normal, spinner }
enum FLCPopupViewPosition { case top, bottom }
enum FLCProgressViewOption { case increase, decrease }
enum FLCListPickerSortType { case byTitle, bySubtitle }
enum FLCListPickerSearchType { case onlyByTitle, onlyBySubtitle, both }
enum FLCGoToViewDirections { case forward, backward }
enum FLCSection { case main }
enum FLCTextViewLabelImagePlacing { case afterText, beforeText }

enum FLCCountryOption: String {
    case china = "Китай"
    case turkey = "Турция"
}

enum FLCCalculationResultCellType: Int {
    case russianDelivery = 1
    case insurance = 2
    case deliveryFromWarehouse = 3
    case cargoHandling = 4
}

enum FLCMarkupType: Double {
    case russianDelivery = 1.17
}

enum FLCCurrency: String {
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

enum FLCLogisticsType: String {
    case chinaTruck = "chinaTruck"
    case chinaRailway = "chinaRailway"
    case chinaAir = "chinaAir"
    case turkeyTruck = "turkeyTruck"
}
