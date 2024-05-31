import Foundation

extension NSMutableAttributedString {
    func combine(strings: NSAttributedString...) -> NSMutableAttributedString {
        let newString = NSMutableAttributedString()
        strings.forEach({ newString.append($0) })
        return newString
    }
}
