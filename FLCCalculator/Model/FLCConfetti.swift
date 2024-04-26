import UIKit

struct FLCConfetti {
    let color: UIColor
    let shape: FLCConfettiShape
    let position: FLCConfettiPosition
    var name = UUID().uuidString
    
    var image: UIImage {
        var imageRect: CGRect
        
        switch shape {
        case .rectangle:
            imageRect = CGRect(x: 0, y: 0, width: 20, height: 13)
        case .circle:
            imageRect = CGRect(x: 0, y: 0, width: 10, height: 10)
        }
        
        UIGraphicsBeginImageContext(imageRect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        
        switch shape {
        case .rectangle:
            context?.fill(imageRect)
        case .circle:
            context?.fillEllipse(in: imageRect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
