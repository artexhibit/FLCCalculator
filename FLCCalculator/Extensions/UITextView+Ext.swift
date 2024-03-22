import UIKit

extension UITextView {
    func getIconAttachmentPosition(for range: NSRange) -> CGFloat {
        let glyphRange = self.layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        let glyphRect = self.layoutManager.boundingRect(forGlyphRange: glyphRange, in: self.textContainer)
        let textViewRelativePoint = CGPoint(x: glyphRect.origin.x, y: glyphRect.origin.y)
        return self.convert(textViewRelativePoint, to: UIScreen.main.coordinateSpace).x
    }
}
