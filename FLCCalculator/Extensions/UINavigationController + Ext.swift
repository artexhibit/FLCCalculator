import Foundation
import UIKit

extension UINavigationController {
    func removeVCFromStack(numberInStack: Int) {
        var navigationArray = self.viewControllers
        navigationArray.remove(at: navigationArray.count - numberInStack)
        self.viewControllers = navigationArray
    }
}
