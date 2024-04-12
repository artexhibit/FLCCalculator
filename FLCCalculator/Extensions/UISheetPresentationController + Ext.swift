import UIKit

extension UISheetPresentationController {
    
    func getFLCSheetPresentationController(in view: UIView, size: CGFloat, dimmed: Bool = true, cornerRadius: CGFloat = 25, addSmallDetent: Bool = false) {
        self.preferredCornerRadius = cornerRadius
        self.prefersGrabberVisible = true
                
        let smallDetent = UISheetPresentationController.Detent.custom(identifier: .smallDetent) { context in
            return DeviceTypes.isiPhoneSE3rdGen ? view.frame.height * 0.23 : view.frame.height * 0.13
        }
        let customSizeDetent = UISheetPresentationController.Detent.custom(identifier: .customSizeDetent) { context in
            return DeviceTypes.isiPhoneSE3rdGen ? view.frame.height * 0.85 : view.frame.height * size
        }
        
        if !dimmed { self.largestUndimmedDetentIdentifier = .customSizeDetent }
        self.detents = addSmallDetent ? [smallDetent, customSizeDetent] : [customSizeDetent]
    }
}

extension UISheetPresentationController.Detent.Identifier {
    static let customSizeDetent = UISheetPresentationController.Detent.Identifier("customSizeDetent")
    static let smallDetent = UISheetPresentationController.Detent.Identifier("smallDetent")
}
