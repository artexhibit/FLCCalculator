import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) { for view in views { addSubview(view) } }
    func addSublayers(_ layers: CALayer...) { for layer in layers { self.layer.addSublayer(layer) } }
    
    func pinToEdges(of superview: UIView, withPadding padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding)
        ])
    }
    
    func findParentViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findParentViewController()
        } else {
            return nil
        }
    }
    
    func configureTapGesture(selector: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        self.addGestureRecognizer(tapGesture)
    }
    
    func hide() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
            self.isUserInteractionEnabled = false
        }
    }
    
    func show() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
            self.isUserInteractionEnabled = true
        }
    }
}
