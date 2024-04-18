import Foundation

struct CalculationResultItem: Hashable {
    let type: FLCCalculationResultCellType
    let calculationData: CalculationData
    let title: String
    var daysAmount: String?
    var price: String?
    let currency: FLCCurrency
    var hasError: Bool = false
    var canDisplay: Bool = true
    var isShimmering: Bool = true
}
