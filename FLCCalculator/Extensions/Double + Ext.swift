import Foundation

extension Double {
    
    func add(markup: FLCMarkupType) -> Double {
        let result = self * markup.rawValue
        return Double(String(format: "%.2f", result)) ?? 0.0
    }
    
    func formatIntoCurrency(symbol: FLCCurrencySymbol) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        
        let result = formatter.string(from: NSNumber(value: self)) ?? ""
        return "\(result) \(symbol.rawValue)"
    }
}

