import UIKit

extension UIButton.Configuration {
    mutating func setupCustomFont(ofSize: CGFloat) {
        self.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { old in
            var new = old
            new.font = UIFont.systemFont(ofSize: ofSize, weight: .bold)
            return new
        }
    }
}
