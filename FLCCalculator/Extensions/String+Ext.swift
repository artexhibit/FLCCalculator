import Foundation

extension String {
    func createDouble() -> Double {
        let string = self.replacingOccurrences(of: " ", with: "")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter.number(from: string)?.doubleValue ?? 0.0
    }
    
    func getFirstCharacters(_ amount: Int) -> String { String(self.prefix(amount)) }
    func removeFirstCharacters(_ amount: Int) -> String { String(self.dropFirst(amount)) }
}
