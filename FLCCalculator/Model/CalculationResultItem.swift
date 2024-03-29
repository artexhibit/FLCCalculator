import Foundation

struct CalculationResultItem: Hashable {
    let type: FLCCalculationResultCellType
    let calculationData: CalculationData
    let title: String
    var daysAmount: String = "0"
    var price: String = "0"
    var itemCellPriceCurrency: FLCCurrency
}
