import UIKit

extension UIButton.Configuration {
    mutating func setupCustomFont(ofSize: CGFloat) {
        self.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { old in
            var new = old
            new.font = UIFont.systemFont(ofSize: ofSize, weight: .bold)
            return new
        }
    }
    
    mutating func addInsets(_ insets: (top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat)) {
        self.contentInsets = NSDirectionalEdgeInsets(top: insets.top, leading: insets.leading, bottom: insets.bottom, trailing: insets.trailing)
    }
}
