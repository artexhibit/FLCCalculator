import Foundation
import UIKit

extension UINavigationController {
    func removeVCFromStack(vc: UIViewController) {
        let navigationArray = self.viewControllers
        let filteredArray = navigationArray.filter { $0 != vc }
        self.viewControllers = filteredArray
    }
    
    func configNavBarAppearance(removeBottomBorder: Bool = true, setColor color: UIColor = .flcOrange) {
        let appearance = UINavigationBarAppearance()
        if removeBottomBorder { appearance.shadowColor = .clear }
        appearance.titleTextAttributes = [.foregroundColor: color]
        appearance.largeTitleTextAttributes = [.foregroundColor: color]
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
      
    }
}
