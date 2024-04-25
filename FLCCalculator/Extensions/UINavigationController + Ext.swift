import Foundation
import UIKit

extension UINavigationController {
    func removeVCFromStack(vc: UIViewController) {
        let navigationArray = self.viewControllers
        let filteredArray = navigationArray.filter { $0 != vc }
        self.viewControllers = filteredArray
    }
    
    func removeBottomBorder() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        self.navigationBar.standardAppearance = appearance
    }
}
