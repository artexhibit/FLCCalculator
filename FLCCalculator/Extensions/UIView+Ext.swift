import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) { for view in views { addSubview(view) } }
    func addSublayers(_ layers: CALayer...) { for layer in layers { self.layer.addSublayer(layer) } }
    
    func pinToEdges(of superview: UIView, withPadding padding: CGFloat = 0, paddingType: FLCPaddingType = .all) {
        translatesAutoresizingMaskIntoConstraints = false
        var sidesPadding: (top: CGFloat, leading: CGFloat, trailing: CGFloat, bottom: CGFloat) = (0,0,0,0)
        
        switch paddingType {
        case .horizontal:
            sidesPadding = (0, padding, padding, 0)
        case .vertical:
            sidesPadding = (padding, 0, 0, padding)
        case .all:
            sidesPadding = (padding, padding, padding, padding)
        }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: sidesPadding.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: sidesPadding.leading),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -sidesPadding.trailing),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -sidesPadding.bottom)
        ])
    }
    
    func pinToSafeArea(of view: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    func hide(withAnimationDuration duration: Double = 0.1) {
        UIView.animate(withDuration: duration) { self.alpha = 0 }
        self.isUserInteractionEnabled = false
    }
    
    func show(withAnimationDuration duration: Double = 0.1) {
        UIView.animate(withDuration: duration) { self.alpha = 1 }
        self.isUserInteractionEnabled = true
    }
    
    func makeViewCanBeTapableAnimation(whenTouchesBegan: Bool) {
        let transform = whenTouchesBegan ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform.identity
        UIView.animate(withDuration: 0.2) { self.transform = transform }
    }
}
