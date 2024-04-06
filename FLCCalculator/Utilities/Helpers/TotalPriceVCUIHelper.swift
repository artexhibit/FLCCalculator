import UIKit

struct TotalPriceVCUIHelper {
    static func increaseSizeOf(spinner: UIActivityIndicatorView, in view: UIView, with padding: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            spinner.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            spinner.center.y += padding / 1.3
            view.layoutIfNeeded()
        }
    }
    
    static func returnToIdentitySizeOf(spinner: UIActivityIndicatorView, in view: UIView, with padding: CGFloat, messageLayer: CATextLayer, titleLayer: CATextLayer, container: UIView) {
        UIView.animate(withDuration: 0.2) {
            spinner.transform = .identity
            spinner.center.y -= padding / 1.3
            
            messageLayer.frame = CGRect(x: spinner.frame.maxX + (padding / 2), y: titleLayer.frame.maxY - 3, width: container.bounds.width - spinner.frame.width, height: messageLayer.fontSize + 5)
            view.layoutIfNeeded()
        }
    }
    
    static func removeLoading(spinner: UIActivityIndicatorView, spinnerMessage: CATextLayer) {
        spinner.stopAnimating()
        spinnerMessage.opacity = 0
    }
    
    static func showDetent(in vc: UIViewController, type: UISheetPresentationController.Detent.Identifier, completion: (() -> Void)? = nil) {
        if let sheet = vc.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = type
                completion?()
            }
        }
    }
    
    static func setPricePerKgTextView(view: FLCTextViewLabel, data: CalculationData?, totalAmount: FLCTextLayer) {
        let priceValue = PriceCalculationManager.getPricePerKg(totalPrice: totalAmount.string as? String, weight: data?.weight ?? 0).result.makeAttributed(icon: Icons.dots, tint: .gray, size: (0, -4, 22, 21), placeIcon: .afterText)
        view.attributedText = priceValue
        view.setStyle(color: .lightGray, textAlignment: .left, fontWeight: .medium, fontSize: 17)
    }
    
    static private func getPopoverMessage(data: CalculationData?, totalAmount: FLCTextLayer) -> String {
        let dataPerKg = PriceCalculationManager.getPricePerKg(totalPrice: totalAmount.string as? String, weight: data?.weight ?? 0)
        let currencyTotal = dataPerKg.currencyValue + (dataPerKg.rubleValue / dataPerKg.exchangeRate).formatDecimalsTo(amount: 2)
        
        let currencyString = "в \(dataPerKg.currency.symbol): \(dataPerKg.currencyValue.formatAsCurrency(symbol: dataPerKg.currency)) + \((dataPerKg.rubleValue / dataPerKg.exchangeRate).formatDecimalsTo(amount: 2).formatAsCurrency(symbol: dataPerKg.currency)) (\(dataPerKg.rubleValue.formatAsCurrency(symbol: dataPerKg.secondCurrency)) по курсу \(dataPerKg.exchangeRate)) = \((dataPerKg.currencyValue + (dataPerKg.rubleValue / dataPerKg.exchangeRate).formatDecimalsTo(amount: 2)).formatAsCurrency(symbol: dataPerKg.currency))"
        
        let rubleString = "в \(dataPerKg.secondCurrency.symbol): \(currencyTotal.formatAsCurrency(symbol: dataPerKg.currency)) по курсу \(dataPerKg.exchangeRate) = \((currencyTotal * dataPerKg.exchangeRate).formatDecimalsTo(amount: 2).formatAsCurrency(symbol: dataPerKg.secondCurrency))"
        
        return currencyString + "\n\n" + rubleString + "\n\n" + "Сумма разделена на вес \(data?.weight ?? 0) кг"
    }
    
    static func setPopoverMessage(in textView: UITextView, pricePerKg: UITextView, with data: CalculationData?, and totalAmount: FLCTextLayer) -> String {
        
        switch textView.text {
        case pricePerKg.text:
            return getPopoverMessage(data: data, totalAmount: totalAmount)
        case .none, .some(_):
            return ""
        }
    }
}
