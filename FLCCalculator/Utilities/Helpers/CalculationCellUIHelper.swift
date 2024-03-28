import UIKit

struct CalculationCellUIHelper {
    static func configureRussianDelivery(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "Подольск - \(item.calculationData.toLocation)".makeAttributed(icon: Icons.truck, size: (0, -3, 24, 17), placeIcon: .beforeText)
        
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
        cell.subtitle.text = "\(PriceCalculationManager.getInsurancePersentage(for: .chinaTruck))% от стоимости инвойса \n\(item.calculationData.invoiceAmount.formatAsCurrency(symbol: currencyCode)), 1 \(item.itemCellPriceCurrency.symbol) ~ \(ratio) \(currencyCode.symbol)"
        
        removeDaysContent(in: cell)
        cell.removeShimmerAnimation()
    }
    
    static func configureDeliveryFromWarehouse(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = "Шанхай - Подольск".makeAttributed(icon: Icons.warehouse, size: (0, -2, 22, 16), placeIcon: .beforeText)
        cell.priceLabel.text = "\(PriceCalculationManager.calculateDeliveryFromWarehouse(for: .chinaTruck, weight: item.calculationData.weight, volume: item.calculationData.volume).formatAsCurrency(symbol: item.itemCellPriceCurrency))"
        removeDaysContent(in: cell)
        cell.removeShimmerAnimation()
    }
    
    static func configureCargoHandling(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        let handlingData = PriceCalculationManager.getCagoHandlingData(for: .chinaTruck)
        
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.text = "\(handlingData.pricePerKg.formatAsCurrency(symbol: item.itemCellPriceCurrency)) за кг, минимум \(handlingData.minPrice.formatAsCurrency(symbol: item.itemCellPriceCurrency))"
        cell.priceLabel.text = "\(PriceCalculationManager.calculateCargoHandling(for: .chinaTruck, weight: item.calculationData.weight).formatAsCurrency(symbol: item.itemCellPriceCurrency))"
        removeDaysContent(in: cell)
        cell.removeShimmerAnimation()
    }
    
    private static func removeDaysContent(in cell: CalculationResultCell) {
        cell.daysLabelHeightConstraint.constant = 0.1
        cell.subtitleBottomConstraint.constant = -cell.padding
    }
}
