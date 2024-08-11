import UIKit

struct CalculatorManager {
    static func createPhoneCall(with number: String) {
        var finalNumber = "tel://\(number)"
        
        if number.contains("доб") {
            let extNumber = number.getLastCharacters(3)
            let pauseCharacter = ","
            finalNumber = finalNumber.removeLastCharacters(3)
            finalNumber += pauseCharacter + extNumber
        }
        
        if let url = URL(string: finalNumber) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantMakeCall, style: .error)
        }
    }
}
