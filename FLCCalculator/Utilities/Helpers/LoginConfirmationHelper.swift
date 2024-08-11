import UIKit

struct LoginConfirmationHelper {
    static func isTypedVerificationCodeMatch(in textFields: [UITextField], verificationCode: String) -> Bool {
        let typedCode = textFields.compactMap({ $0.text }).joined()
        
        if typedCode == verificationCode { return true }
        
        if typedCode.count == 4  {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.wrongCode, style: .error, position: .top)
        }
        return false
    }
}
