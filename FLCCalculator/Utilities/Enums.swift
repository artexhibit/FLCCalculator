import Foundation

enum FLCPopupViewStyle { case error, normal, spinner }
enum FLCPopupViewPosition { case top, bottom }
enum FLCProgressViewOption { case increase, decrease }
enum FLCListPickerSortType { case byTitle, bySubtitle }
enum FLCGoToViewDirections { case forward, backward }
enum FLCSection { case main }

enum FLCCountryOption: String {
    case china = "Китай"
    case turkey = "Турция"
}

enum FLCCalculationResultCellType: Int {
    case russianDelivery = 1
}

enum FLCMarkupType: Double {
    case russianDelivery = 1.17
}

enum FLCCurrencySymbol: String {
    case rub = "₽"
    case usd = "$"
    case eur = "€"
}
