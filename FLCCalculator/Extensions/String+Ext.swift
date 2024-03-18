import UIKit

extension String {
    func createDouble() -> Double {
        let string = self.replacingOccurrences(of: " ", with: "")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter.number(from: string)?.doubleValue ?? 0.0
    }
    
    func makeAttributed(imageName: String, width: Int, height: Int, paddingAfter: Int) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let tintedImage = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        let tintedImageView = UIImageView(image: tintedImage)
        
        let icon = NSTextAttachment()
        icon.image = tintedImageView.image
        icon.bounds = CGRect(x: 0, y: -3, width: width, height: height)
        attributedString.append(NSAttributedString(attachment: icon))
        
        let padding = NSTextAttachment()
        padding.image = UIImage()
        padding.bounds = CGRect(x: 0, y: 0, width: paddingAfter, height: 1)
        attributedString.append(NSAttributedString(attachment: padding))
        
        attributedString.append(NSAttributedString(string: self))
        return attributedString
    }
    
    func getFirstCharacters(_ amount: Int) -> String { String(self.prefix(amount)) }
    func removeFirstCharacters(_ amount: Int) -> String { String(self.dropFirst(amount)) }
}
