import UIKit

extension UISheetPresentationController {
    
    func getFLCSheetPresentationController(in view: UIView, size: CGFloat) {
        self.preferredCornerRadius = 25
        self.prefersGrabberVisible = true
        
        let fraction = UISheetPresentationController.Detent.custom { context in
            return DeviceTypes.isiPhoneSE3rdGen ? view.frame.height * 0.7 : view.frame.height * size
        }
        
        self.detents = [fraction]
    }
}
