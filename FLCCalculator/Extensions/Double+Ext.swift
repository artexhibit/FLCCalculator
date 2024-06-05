import Foundation

extension Double {
    
    func add(markup: FLCMarkupType) -> Double { return (self * markup.rawValue).formatDecimalsTo(amount: 2) }
    
    func formatAsCurrency(symbol: FLCCurrency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        
        let result = formatter.string(from: NSNumber(value: self)) ?? ""
        return "\(result) \(symbol.symbol)"
    }
    
    func formatDecimalsTo(amount: Int) -> Double {
        let divisor = pow(10.0, Double(amount))
        return (self * divisor).rounded() / divisor
    }
}

