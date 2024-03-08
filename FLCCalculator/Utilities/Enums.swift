import Foundation

enum FLCPopupViewStyle { case error, normal }
enum FLCPopupViewPosition { case top, bottom }
enum ProgressViewOption { case increase, decrease }

enum FLCListPickerContentType {
    case withSubtitle([(title: String, subtitle: String)])
    case onlyTitle([String])
}

enum FLCCountryOption: String {
    case china = "Китай"
    case turkey = "Турция"
}
