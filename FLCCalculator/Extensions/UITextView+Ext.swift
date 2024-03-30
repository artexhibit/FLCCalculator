import UIKit

extension UITextView {
    func getIconAttachmentPosition(for range: NSRange) -> (x: CGFloat, y: CGFloat) {
        let glyphRange = self.layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        let glyphRect = self.layoutManager.boundingRect(forGlyphRange: glyphRange, in: self.textContainer)
        return (glyphRect.midX, glyphRect.midY)
    }
}
