import UIKit

extension UIColor {
    private func makeColor(delta: CGFloat = 0.1) -> UIColor {
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: add(delta, toComponent: red), green: add(delta, toComponent: green), blue: add(delta, toComponent: blue), alpha: alpha)
    }
    
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
    
    func makeDarker(delta: CGFloat = 0.1) -> UIColor { makeColor(delta: -1*delta) }
    func makeLighter(delta: CGFloat = 0.1) -> UIColor { makeColor(delta: delta) }
}
