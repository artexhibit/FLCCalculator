import Foundation

struct CalculationResultItem: Hashable {
    let id: Int
    let title: String
    let subtitle: String
    var daysAmount: String = ""
    var price: String = "0"
}
