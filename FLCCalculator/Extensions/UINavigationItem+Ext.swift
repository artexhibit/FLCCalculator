import UIKit

extension UINavigationItem {
    func createCloseButton(in view: UIViewController, with action: Selector) {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: view, action: action)
        self.rightBarButtonItem = closeButton
    }
}
