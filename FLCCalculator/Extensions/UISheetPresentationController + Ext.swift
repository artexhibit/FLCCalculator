import UIKit

extension UISheetPresentationController {
    private func getDetents(for view: UIView, of sizes: (small: CGFloat, custom: CGFloat)) -> [ UISheetPresentationController.Detent] {
        let smallDetent = UISheetPresentationController.Detent.custom(identifier: .smallDetent) { context in
            view.frame.height * sizes.small
        }
        let customSizeDetent = UISheetPresentationController.Detent.custom(identifier: .customSizeDetent) { context in
            view.frame.height * sizes.custom
        }
        return [smallDetent, customSizeDetent]
    }
    
    func getFLCSheetPresentationController(in view: UIView, size: CGFloat, dimmed: Bool = true, cornerRadius: CGFloat = 25, addSmallDetent: Bool = false) {
        self.preferredCornerRadius = cornerRadius
        self.prefersGrabberVisible = true
        let smallSize = DeviceTypes.isiPhoneSE3rdGen ? 0.21 : 0.13
        let customSize = DeviceTypes.isiPhoneSE3rdGen ? 0.85 : size
        let detents = getDetents(for: view, of: (smallSize, customSize))
        
        if !dimmed { self.largestUndimmedDetentIdentifier = .customSizeDetent }
        self.detents = addSmallDetent ? detents : [detents[1]]
    }
    
    func updateDetentsHeight(to sizes: (small: CGFloat, custom: CGFloat), dimmed: Bool = true, view: UIView, addSmallDetent: Bool = false) {
        let detents = getDetents(for: view, of: (sizes.small, sizes.custom))
        
        if !dimmed { self.largestUndimmedDetentIdentifier = .customSizeDetent }
        self.animateChanges { self.detents = addSmallDetent ? detents : [detents[1]] }
    }
}

extension UISheetPresentationController.Detent.Identifier {
    static let customSizeDetent = UISheetPresentationController.Detent.Identifier("customSizeDetent")
    static let smallDetent = UISheetPresentationController.Detent.Identifier("smallDetent")
}
