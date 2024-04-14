import Foundation
import UIKit

extension UINavigationController {
    func removeVCFromStack(numberInStack: Int) {
        var navigationArray = self.viewControllers
        navigationArray.remove(at: navigationArray.count - numberInStack)
        self.viewControllers = navigationArray
    }
    
    func removeBottomBorder() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        self.navigationBar.standardAppearance = appearance
    }
}
