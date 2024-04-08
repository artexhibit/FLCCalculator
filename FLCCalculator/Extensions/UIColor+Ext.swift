import UIKit

extension UIColor {
    private func makeColor(componentDelta: CGFloat = 0.1) -> UIColor {
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: add(componentDelta, toComponent: red), green: add(componentDelta, toComponent: green), blue: add(componentDelta, toComponent: blue), alpha: alpha)
    }
    
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
    
    func makeDarker(componentDelta: CGFloat = 0.1) -> UIColor { makeColor(componentDelta: -1*componentDelta) }
    func makeLighter(componentDelta: CGFloat = 0.1) -> UIColor { makeColor(componentDelta: componentDelta) }
}
