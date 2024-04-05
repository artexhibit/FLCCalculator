import UIKit

class TotalPriceVC: UIViewController {
    
    private var smallDetentContainerView = UIView()
    private let titleLayer = FLCTextLayer(fontSize: 25, fontWeight: .heavy, color: .accent, alignment: .left)
    private let totalDaysLayer = FLCTextLayer(fontSize: 17, fontWeight: .bold, color: .gray, alignment: .left)
    private let totalAmountLayer = FLCTextLayer(fontSize: 20, fontWeight: .semibold, color: .label, alignment: .left)
    private var spinner = UIActivityIndicatorView()
    private let spinnerMessageLayer = FLCTextLayer(fontSize: 20, fontWeight: .semibold, color: .label, alignment: .left)
    private let padding: CGFloat = 15
    
    var amountOfCells = 0
    private var calculatedCells: Int = 0
    private var calculationTitles = [String]()
    private var prices = [String]()
    private var days = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureSmallDetentContainerView()
        configureTitleLayer()
        configureSpinner()
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
        view.addSubview(smallDetentContainerView)
        sheetPresentationController?.delegate = self
    }
    
    private func configureSmallDetentContainerView() {
        smallDetentContainerView.translatesAutoresizingMaskIntoConstraints = false
        smallDetentContainerView.addSublayers(titleLayer, totalDaysLayer, totalAmountLayer, spinnerMessageLayer)
        smallDetentContainerView.addSubviews(spinner)
        
        NSLayoutConstraint.activate([
            smallDetentContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding * 1.5),
            smallDetentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 1.5),
            smallDetentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            smallDetentContainerView.heightAnchor.constraint(equalToConstant: titleLayer.fontSize + totalDaysLayer.fontSize + (padding / 2) + totalAmountLayer.fontSize + 5)
        ])
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
    
    private func configureSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .medium
        spinner.startAnimating()
        
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
}

extension TotalPriceVC: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        
        switch sheetPresentationController.selectedDetentIdentifier {
        case .customSizeDetent:
            titleLayer.animateFont(toSize: 35, key: "increase")
            totalDaysLayer.animateFont(toSize: 22, key: "increase")
            totalAmountLayer.animateFont(toSize: 26, key: "increase")
            spinnerMessageLayer.animateFont(toSize: 24, key: "increase")
            TotalPriceVCUIHelper.increaseSizeOf(spinner: spinner, in: self.view, with: padding)
            
        case .smallDetent:
            titleLayer.animateFont(toSize: 25, key: "decrease")
            totalDaysLayer.animateFont(toSize: 17, key: "decrease")
            totalAmountLayer.animateFont(toSize: 20, key: "decrease")
            spinnerMessageLayer.animateFont(toSize: 20, key: "decrease")
            TotalPriceVCUIHelper.returnToIdentitySizeOf(spinner: spinner, in: self.view, with: padding, messageLayer: spinnerMessageLayer, titleLayer: titleLayer, container: smallDetentContainerView)
            
        case .none, .some(_):
            break
        }
    }
}

extension TotalPriceVC: CalculationResultVCDelegate {
    func didEndCalculation(price: String, days: String?, title: String) {
        calculatedCells += 1
        
        if !calculationTitles.contains(title) {
            calculationTitles.append(title)
            prices.append(price)
            if days != nil { self.days.append(days ?? "") }
        }
        if calculatedCells == amountOfCells {
            TotalPriceVCUIHelper.removeLoading(spinner: spinner, spinnerMessage: spinnerMessageLayer)
            totalDaysLayer.string = CalculationUIHelper.calculateTotalDays(days: self.days)
            totalAmountLayer.string = CalculationUIHelper.calculateTotalPrice(prices: prices)
        }
    }
}
