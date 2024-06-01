import UIKit

struct FLCUIHelper {
    static func move(view: UIView, constraint: NSLayoutConstraint?, vc: UIViewController, direction: FLCGoToViewDirections, times: CGFloat = 1, duration: Double = 0.3) {
        switch direction {
        case .forward:
            constraint?.constant = -(view.frame.width * times)
        case .backward:
            constraint?.constant = 0
        }
        UIView.animate(withDuration: duration) { vc.view.layoutIfNeeded() }
    }
}
