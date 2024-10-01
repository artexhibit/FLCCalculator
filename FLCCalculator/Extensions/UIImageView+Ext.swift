import UIKit

extension UIImageView {
    func addRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 1.5
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopRotationAnimation() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    func animateSymbolChange(to newSymbol: UIImage, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
                self.image = newSymbol
                self.transform = CGAffineTransform.identity
            }, completion: { _ in
                completion?()
            })
        })
    }
}
