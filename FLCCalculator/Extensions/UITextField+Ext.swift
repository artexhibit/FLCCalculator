import UIKit

extension UITextField {
    func setCursorAfterTypedNumber() {
        guard let newPosition = self.position(from: self.beginningOfDocument, offset: 1) else { return }
        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
    }
    
    func moveCursorTo(position: Int) {
        guard let newPosition = self.position(from: self.beginningOfDocument, offset: position) else { return }
        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
    }
    
    func getCursorPosition() -> Int {
        guard let selectedRange = self.selectedTextRange else { return 0 }
        return self.offset(from: self.beginningOfDocument, to: selectedRange.start)
    }
}
