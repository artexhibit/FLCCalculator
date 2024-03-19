import UIKit

extension String {
    func createDouble() -> Double {
        let string = self.replacingOccurrences(of: " ", with: "")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter.number(from: string)?.doubleValue ?? 0.0
    }
    
    func makeAttributed(icon: UIImage, size: (x: Int, y: Int, w: Int, h: Int), imagePlace: FLCTextViewLabelImagePlacing) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let tintedImage = icon.withRenderingMode(.alwaysTemplate)
        let tintedImageView = UIImageView(image: tintedImage)
        
        let icon = NSTextAttachment()
        icon.image = tintedImageView.image
        icon.bounds = CGRect(x: size.x, y: size.y, width: size.w, height: size.h)
        
        let padding = NSTextAttachment()
        padding.image = UIImage()
        padding.bounds = CGRect(x: 0, y: 0, width: 5, height: 1)
        
        switch imagePlace {
        case .afterText:
            attributedString.append(NSAttributedString(string: self))
            attributedString.append(NSAttributedString(attachment: padding))
            attributedString.append(NSAttributedString(attachment: icon))
        case .beforeText:
            attributedString.append(NSAttributedString(attachment: icon))
            attributedString.append(NSAttributedString(attachment: padding))
            attributedString.append(NSAttributedString(string: self))
        }
        return attributedString
    }
    
    func getFirstCharacters(_ amount: Int) -> String { String(self.prefix(amount)) }
    func removeFirstCharacters(_ amount: Int) -> String { String(self.dropFirst(amount)) }
}
