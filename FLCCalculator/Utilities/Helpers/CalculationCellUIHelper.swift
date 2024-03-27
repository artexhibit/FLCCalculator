import UIKit

struct CalculationCellUIHelper {
    static func configureRussianDelivery(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = item.subtitle.makeAttributed(icon: Icons.truck, size: (0, -3, 24, 17), placeIcon: .beforeText)
        
        Task {
            do {
                let data = try await NetworkManager.shared.getRussianDelivery(for: item)
                let price = data.getPrice().add(markup: .russianDelivery).formatAsCurrency(symbol: item.itemCellPriceCurrency)
                
                DispatchQueue.main.async {
                    cell.priceLabel.text = price
                    cell.daysLabel.text = "\(data.getDays() ?? "?") дн."
                    cell.removeShimmerAnimation()
                }
            }
        }
    }
    
    static func configureInsurance(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        let currencyCode = FLCCurrency(currencyCode: item.calculationData.invoiceCurrency) ?? .USD
        let ratio = PriceCalculationManager.getRatioBetween(item.itemCellPriceCurrency, and: currencyCode)
        
        cell.titleTextView.attributedText = attributedText
        cell.priceLabel.text = PriceCalculationManager.calculateInsurance(for: .chinaTruck, invoiceAmount: item.calculationData.invoiceAmount, cellPriceCurrency: item.itemCellPriceCurrency, invoiceCurrency: currencyCode).formatAsCurrency(symbol: item.itemCellPriceCurrency)
        cell.subtitle.text = "\(PriceCalculationManager.getInsurancePersentage(for: .chinaTruck))% от стоимости инвойса (\(item.calculationData.invoiceAmount.formatAsCurrency(symbol: currencyCode))) \n1 \(item.itemCellPriceCurrency.symbol) ~ \(ratio) \(currencyCode.symbol)"
        
        removeDaysContent(in: cell)
        cell.removeShimmerAnimation()
    }
    
    private static func removeDaysContent(in cell: CalculationResultCell) {
        cell.daysLabelHeightConstraint.constant = 0.1
        cell.subtitleBottomConstraint.constant = -cell.padding
    }
}
