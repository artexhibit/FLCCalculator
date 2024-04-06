import UIKit

class TotalPriceVC: UIViewController {
    
    private var smallDetentContainerView = UIView()
    private var customDetentContainerView = FLCTintedView(color: .clear, alpha: 0)
    private let padding: CGFloat = 15
    
    private var spinner = UIActivityIndicatorView()
    private let spinnerMessageLayer = FLCTextLayer(fontSize: 20, fontWeight: .semibold, color: .label, alignment: .left)
    
    private let titleLayer = FLCTextLayer(fontSize: 25, fontWeight: .heavy, color: .accent, alignment: .left)
    private let totalDaysLayer = FLCTextLayer(fontSize: 17, fontWeight: .bold, color: .gray, alignment: .left)
    private let totalAmountLayer = FLCTextLayer(fontSize: 20, fontWeight: .semibold, color: .label, alignment: .left)
    private let detailsButton = FLCTintedButton(color: .accent, title: "Подробнее", systemImageName: "ellipsis", size: .mini)
    private let pricePerKgTextView = FLCTextViewLabel()
    
    private var customDetentContainerBottomView: NSLayoutConstraint?
    
    private var totalCells = 0
    private var totalCalculatedCells: Int = 0
    private var calculationTitles = [String]()
    private var prices = [String]()
    private var days = [String]()
    
    private var calculationData: CalculationData?
    private var showingPopover = FLCPopoverVC()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureSmallDetentContainerView()
        configureTitleLayer()
        configureSpinner()
        configureDetailsButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTitleLayer()
        configureTotalDaysLayer()
        configureTotalAmountLayer()
        configureSpinnerMessageLayer()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubviews(smallDetentContainerView, customDetentContainerView)
        sheetPresentationController?.delegate = self
        configurePanGesture(selector: #selector(viewDragged))
    }
    
    @objc private func viewDragged(_ gesture: UIPanGestureRecognizer) {
        if showingPopover.isShowing { showingPopover.hidePopoverFromMainThread() }
    }
    
    private func configureSmallDetentContainerView() {
        smallDetentContainerView.translatesAutoresizingMaskIntoConstraints = false
        smallDetentContainerView.addSublayers(titleLayer, totalDaysLayer, totalAmountLayer, spinnerMessageLayer)
        smallDetentContainerView.addSubviews(spinner, detailsButton)
        
        NSLayoutConstraint.activate([
            smallDetentContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding * 1.5),
            smallDetentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 1.5),
            smallDetentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            smallDetentContainerView.heightAnchor.constraint(equalToConstant: titleLayer.fontSize + totalDaysLayer.fontSize + (padding / 2) + totalAmountLayer.fontSize + 5)
        ])
    }
    
    private func configureCustomDetentContainerView() {
        customDetentContainerView.addSubviews(pricePerKgTextView)
        customDetentContainerBottomView = customDetentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding * 2)
        
        NSLayoutConstraint.activate([
            customDetentContainerView.topAnchor.constraint(equalTo: smallDetentContainerView.topAnchor, constant: totalAmountLayer.frame.maxY),
            customDetentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            customDetentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            customDetentContainerBottomView!
        ])
        view.layoutIfNeeded()
        
        if !spinner.isAnimating { configurePricePerKgTextView() }
    }
    
    private func configureTitleLayer() {
        titleLayer.string = "Итого"
        titleLayer.frame = CGRect(x: 0, y: 0, width: smallDetentContainerView.bounds.width, height: titleLayer.fontSize + 5)
    }
    
    private func configureTotalDaysLayer() {
        let totalDaysLayerY = titleLayer.frame.maxY + (padding / 2)
        
        totalDaysLayer.frame = CGRect(x: 0, y: totalDaysLayerY, width: smallDetentContainerView.bounds.width, height: totalDaysLayer.fontSize + 2)
    }
    
    private func configureTotalAmountLayer() {
        let totalAmountLayerY = totalDaysLayer.frame.maxY + 3
        let estimatedTotalHeight = (totalAmountLayer.fontSize * 1.2) * 2
        
        totalAmountLayer.frame = CGRect(x: 0, y: totalAmountLayerY, width: smallDetentContainerView.bounds.width, height: estimatedTotalHeight)
    }
    
    private func configureDetailsButton() {
        detailsButton.delegate = self
        detailsButton.hide()
        
        NSLayoutConstraint.activate([
            detailsButton.trailingAnchor.constraint(equalTo: smallDetentContainerView.trailingAnchor, constant: -padding / 2.5),
            detailsButton.centerYAnchor.constraint(equalTo: smallDetentContainerView.topAnchor, constant: titleLayer.frame.midY + 2)
        ])
    }
    
    private func configurePricePerKgTextView() {
        pricePerKgTextView.delegate = self
        
        NSLayoutConstraint.activate([
            pricePerKgTextView.topAnchor.constraint(equalTo: customDetentContainerView.topAnchor),
            pricePerKgTextView.leadingAnchor.constraint(equalTo: customDetentContainerView.leadingAnchor, constant: padding / 2),
            pricePerKgTextView.trailingAnchor.constraint(equalTo: customDetentContainerView.trailingAnchor)
        ])
    }
    
    private func configureSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .medium
        
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: smallDetentContainerView.topAnchor, constant: titleLayer.frame.maxY + (padding / 1.5)),
            spinner.leadingAnchor.constraint(equalTo: smallDetentContainerView.leadingAnchor)
        ])
    }
    
    private func configureSpinnerMessageLayer() {
        spinnerMessageLayer.string = "Считаем"
        if spinner.isAnimating { spinnerMessageLayer.opacity = 1 }
        
        smallDetentContainerView.layoutIfNeeded()
        let spinnerMessageLayerY = titleLayer.frame.maxY + (padding / 2)
    
        spinnerMessageLayer.frame = CGRect(x: spinner.frame.maxX + (padding / 2.5), y: spinnerMessageLayerY, width: smallDetentContainerView.bounds.width - spinner.frame.width, height: spinnerMessageLayer.fontSize + 5)
    }
    
    private func setupUIForCustomSizeDetent() {
        titleLayer.animateFont(toSize: 35, key: "increase")
        totalDaysLayer.animateFont(toSize: 22, key: "increase")
        totalAmountLayer.animateFont(toSize: 26, key: "increase")
        spinnerMessageLayer.animateFont(toSize: 24, key: "increase")
        pricePerKgTextView.show()
        
        detailsButton.hide()
        TotalPriceVCUIHelper.increaseSizeOf(spinner: spinner, in: view, with: padding)
        if !spinner.isAnimating { configureCustomDetentContainerView() }
    }
    
    func setupUIForSmallDetent() {
        titleLayer.animateFont(toSize: 25, key: "decrease")
        totalDaysLayer.animateFont(toSize: 17, key: "decrease")
        totalAmountLayer.animateFont(toSize: 20, key: "decrease")
        spinnerMessageLayer.animateFont(toSize: 20, key: "decrease")
        pricePerKgTextView.hide()
        
        if !spinner.isAnimating { detailsButton.show() }
        TotalPriceVCUIHelper.returnToIdentitySizeOf(spinner: spinner, in: view, with: padding, messageLayer: spinnerMessageLayer, titleLayer: titleLayer, container: smallDetentContainerView)
        
        if !spinner.isAnimating, let bottomConstraint = customDetentContainerBottomView, bottomConstraint.isActive { customDetentContainerBottomView?.isActive = false }
    }
}

extension TotalPriceVC: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        
        switch sheetPresentationController.selectedDetentIdentifier {
        case .customSizeDetent:
            setupUIForCustomSizeDetent()
            
        case .smallDetent:
            setupUIForSmallDetent()
            
        case .none, .some(_):
            break
        }
  
    }
}

extension TotalPriceVC: CalculationResultVCDelegate {
    func didReceiveCellsAmount(amount: Int, calculationData: CalculationData) {
        if totalCells == 0 { spinner.startAnimating() }
        totalCells = amount
        self.calculationData = calculationData
    }
    
    func didEndCalculation(price: String, days: String?, title: String) {
        totalCalculatedCells += 1
        
        if !calculationTitles.contains(title) {
            calculationTitles.append(title)
            prices.append(price)
            if days != nil { self.days.append(days ?? "") }
        }
    
        if totalCalculatedCells == totalCells {
            TotalPriceVCUIHelper.removeLoading(spinner: spinner, spinnerMessage: spinnerMessageLayer)
            detailsButton.show()
            totalDaysLayer.string = CalculationUIHelper.calculateTotalDays(days: self.days)
            totalAmountLayer.string = CalculationUIHelper.calculateTotalPrice(prices: prices)
            TotalPriceVCUIHelper.setPricePerKgTextView(view: pricePerKgTextView, data: calculationData, totalAmount: totalAmountLayer)
            if sheetPresentationController?.selectedDetentIdentifier == .customSizeDetent { configureCustomDetentContainerView()
            }
        }
    }
}

extension TotalPriceVC: FLCTintedButtonDelegate {
    func didTapButton(_ button: FLCTintedButton) {
        TotalPriceVCUIHelper.showDetent(in: self, type: .customSizeDetent) { [weak self] in
            guard let self else { return }
            detailsButton.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { self.setupUIForCustomSizeDetent() }
        }
    }
}

extension TotalPriceVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let imageName = textAttachment.image, imageName.description.contains("ellipsis.circle.fill") {
            HapticManager.addHaptic(style: .light)

            let popover = FLCPopoverVC()
            if showingPopover.isShowing != popover.isShowing { showingPopover.hidePopoverFromMainThread() }
            showingPopover = popover
            
            guard !popover.isShowing else { return false }
            
            let message = TotalPriceVCUIHelper.setPopoverMessage(in: textView, pricePerKg: pricePerKgTextView, with: calculationData, and: totalAmountLayer)
            popover.showPopoverOnMainThread(withText: message, in: self, target: textView, characterRange: characterRange)
            return false
        }
        return true
    }
}

extension TotalPriceVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

extension TotalPriceVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
