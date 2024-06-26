import UIKit

struct TotalPriceVCUIHelper {
    static func increaseSizeOf(spinner: UIActivityIndicatorView, in view: UIView, with padding: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            spinner.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            spinner.center.y += padding / 1.3
            view.layoutIfNeeded()
        }
    }
    
    static func returnToIdentitySizeOf(spinner: UIActivityIndicatorView, in view: UIView, with padding: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            spinner.transform = .identity
            spinner.center.y -= padding / 1.3
            view.layoutIfNeeded()
        }
    }
    
    static func removeLoading(spinner: UIActivityIndicatorView, spinnerMessage: CATextLayer) {
        spinner.stopAnimating()
        spinnerMessage.opacity = 0
    }
    
    static func turnOnLoading(spinner: UIActivityIndicatorView, spinnerMessage: CATextLayer, button: FLCTintedButton, customDetentContent: [UIView], smallDetentContent: [FLCTextLayer]) {
        button.hide()
        customDetentContent.forEach { $0.hide() }
        smallDetentContent.forEach { $0.opacity = 0 }
        spinner.startAnimating()
        spinnerMessage.opacity = 1
    }
    
    static func showDetent(in vc: UIViewController, type: UISheetPresentationController.Detent.Identifier, completion: (() -> Void)? = nil) {
        if let sheet = vc.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = type
                completion?()
            }
        }
    }
    
    static func setPriceForTextView(view: FLCTextViewLabel, data: CalculationData?, totalAmount: FLCTextLayer, type: FLCTotalType) {
        let totalPriceString = (totalAmount.string as? String) ?? ""
        let totalPrice = totalPriceString.contains("*") ? totalPriceString.filter { $0 != "*" } : totalPriceString
        var targetType: FLCTotalType
        
        switch type {
        case .perKG: targetType = .perKG
        case .asOneCurrency: targetType = .asOneCurrency
        }

        view.attributedText = PriceCalculationManager.getPrice(totalPrice: totalPrice, data: data, type: targetType).result.makeAttributed(icon: Icons.dots, tint: .gray, size: (0, -4, 22, 21), placeIcon: .afterText)
        view.setStyle(color: .lightGray, textAlignment: .left, fontWeight: .medium, fontSize: 17)
    }
    
    static private func getTotal(data: CalculationData?, totalAmount: FLCTextLayer, type: FLCTotalType) -> String {
        let priceData = PriceCalculationManager.getPrice(totalPrice: totalAmount.string as? String, data: data, type: type)
        
        let currencyTotal = priceData.currencyValue + (priceData.rubleValue / priceData.exchangeRate).formatDecimalsTo(amount: 2)
        
        let currencyString = "в \(priceData.currency.symbol): \(priceData.currencyValue.formatAsCurrency(symbol: priceData.currency)) + \((priceData.rubleValue / priceData.exchangeRate).formatDecimalsTo(amount: 2).formatAsCurrency(symbol: priceData.currency)) (\(priceData.rubleValue.formatAsCurrency(symbol: priceData.secondCurrency)) по курсу \(priceData.exchangeRate)) = \((priceData.currencyValue + (priceData.rubleValue / priceData.exchangeRate).formatDecimalsTo(amount: 2)).formatAsCurrency(symbol: priceData.currency))"
        
        let rubleString = "в \(priceData.secondCurrency.symbol): \(currencyTotal.formatAsCurrency(symbol: priceData.currency)) по курсу \(priceData.exchangeRate) = \((currencyTotal * priceData.exchangeRate).formatDecimalsTo(amount: 2).formatAsCurrency(symbol: priceData.secondCurrency))"
        
        switch type {
        case .perKG:
            return currencyString + "\n\n" + rubleString + "\n\n" + "Сумма разделена на вес \(data?.weight ?? 0) кг"
        case .asOneCurrency:
            return currencyString + "\n\n" + rubleString
        }
    }
    
    static func setTitleStyleBasedOnPriceFetchResult(prices: [String], layer: FLCTextLayer) {
        if prices.contains(where: { $0.isEmpty }) {
            layer.string = CalculationHelper.calculateTotalPrice(prices: prices) + "*"
            layer.foregroundColor = UIColor.red.makeLighter(delta: 0.4).cgColor
        } else {
            layer.string = CalculationHelper.calculateTotalPrice(prices: prices)
            layer.foregroundColor = UIColor.flcGray.cgColor
        }
    }
    
    static func textWillWrap(text: String, font: UIFont, width: CGFloat) -> Bool {
        let tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        tempLabel.numberOfLines = 0
        tempLabel.font = font
        tempLabel.text = text
        tempLabel.sizeToFit()
        return Int(floor(tempLabel.frame.size.height / font.lineHeight)) > 1
    }
    
    static func setPopoverMessage(in textView: UITextView, priceAsOneCurrency: UITextView, pricePerKg: UITextView, invoiceIssue: UITextView, with data: CalculationData?, and totalAmount: FLCTextLayer) -> String {
        
        switch textView.text {
        case priceAsOneCurrency.text:
            return getTotal(data: data, totalAmount: totalAmount, type: .asOneCurrency)
        case pricePerKg.text:
            return getTotal(data: data, totalAmount: totalAmount, type: .perKG)
        case invoiceIssue.text:
            return "3% только к валютной части из-за колебаний курса, поскольку расчёты с контрагентами у нас в валюте."
        case .none, .some(_):
            return ""
        }
    }
}
