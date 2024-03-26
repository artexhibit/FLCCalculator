import UIKit

struct CalculationCellUIHelper {
    static func configureRussianDelivery(cell: CalculationResultCell, with item: CalculationResultItem, and attributedText: NSMutableAttributedString) {
        cell.titleTextView.attributedText = attributedText
        cell.subtitle.attributedText = item.subtitle.makeAttributed(icon: Icons.truck, size: (0, -3, 24, 17), placeIcon: .beforeText)
        
        Task {
            do {
                let data = try await NetworkManager.shared.getRussianDelivery(for: item)
                let price = data.getPrice().add(markup: .russianDelivery).formatAsCurrency(symbol: .RUB)
                
                DispatchQueue.main.async {
                    cell.priceLabel.text = price
                    cell.daysLabel.text = "\(data.getDays() ?? "?") дн."
                    cell.removeShimmerAnimation()
                }
            }
        }
    }
}
