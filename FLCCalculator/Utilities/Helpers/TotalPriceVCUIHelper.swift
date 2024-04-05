import UIKit

struct TotalPriceVCUIHelper {
    static func increaseSizeOf(spinner: UIActivityIndicatorView, in view: UIView, with padding: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            spinner.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            spinner.center.y += padding / 1.3
            view.layoutIfNeeded()
        }
    }
    
    static func returnToIdentitySizeOf(spinner: UIActivityIndicatorView, in view: UIView, with padding: CGFloat, messageLayer: CATextLayer, titleLayer: CATextLayer, container: UIView) {
        UIView.animate(withDuration: 0.2) {
            spinner.transform = .identity
            spinner.center.y -= padding / 1.3
            
            messageLayer.frame = CGRect(x: spinner.frame.maxX + (padding / 2), y: titleLayer.frame.maxY - 3, width: container.bounds.width - spinner.frame.width, height: messageLayer.fontSize + 5)
            view.layoutIfNeeded()
        }
    }
    
    static func removeLoading(spinner: UIActivityIndicatorView, spinnerMessage: CATextLayer) {
        spinner.stopAnimating()
        spinnerMessage.opacity = 0
    }
    
    static func showCustomSizeDetent(in vc: UIViewController, and button: FLCTintedButton) {
        if let sheet = vc.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .customSizeDetent
                button.hide()
            }
        }
    }
}
