import UIKit

class TotalPriceVC: UIViewController {
    
    private var smallDetentContainerView = UIView()
    private let titleLayer = FLCTextLayer(fontSize: 25, fontWeight: .heavy, color: .accent, alignment: .left)
    private let totalAmountLayer = FLCTextLayer(fontSize: 20, fontWeight: .semibold, color: .label, alignment: .left)
    private var spinner = UIActivityIndicatorView()
    private let spinnerMessageLayer = FLCTextLayer(fontSize: 20, fontWeight: .semibold, color: .label, alignment: .left)
    private let padding: CGFloat = 15
    
    var amountOfCells = 0
    private var calculatedCells: Int = 0
    private var calculationTitles = [String]()
    private var calculationResults = [String]()
        
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
        smallDetentContainerView.addSublayers(titleLayer, totalAmountLayer, spinnerMessageLayer)
        smallDetentContainerView.addSubviews(spinner)
        
        NSLayoutConstraint.activate([
            smallDetentContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding * 1.5),
            smallDetentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 1.5),
            smallDetentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            smallDetentContainerView.heightAnchor.constraint(equalToConstant: titleLayer.fontSize + totalAmountLayer.fontSize + (padding / 2) + 5)
        ])
    }
    
    private func configureTitleLayer() {
        titleLayer.string = "Итого"
        titleLayer.frame = CGRect(x: 0, y: 0, width: smallDetentContainerView.bounds.width, height: titleLayer.fontSize + 5)
    }
    
    private func configureTotalAmountLayer() {
        let totalAmountLayerY = titleLayer.frame.maxY + (padding / 2)
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
    
        spinnerMessageLayer.frame = CGRect(x: spinner.frame.maxX + (padding / 2), y: spinnerMessageLayerY, width: smallDetentContainerView.bounds.width - spinner.frame.width, height: spinnerMessageLayer.fontSize + 5)
    }
}

extension TotalPriceVC: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        
        switch sheetPresentationController.selectedDetentIdentifier {
        case .customSizeDetent:
            titleLayer.animateFont(toSize: 35, key: "increase")
            totalAmountLayer.animateFont(toSize: 26, key: "increase")
            spinnerMessageLayer.animateFont(toSize: 24, key: "increase")
            
            UIView.animate(withDuration: 0.2) {
                self.spinner.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                self.spinner.center.y += self.padding / 1.1
                self.view.layoutIfNeeded()
            }
            
        case .smallDetent:
            titleLayer.animateFont(toSize: 25, key: "decrease")
            totalAmountLayer.animateFont(toSize: 20, key: "decrease")
            spinnerMessageLayer.animateFont(toSize: 20, key: "decrease")
            
            UIView.animate(withDuration: 0.2) {
                self.spinner.transform = .identity
                self.spinner.center.y -= self.padding / 1.1
                
                self.spinnerMessageLayer.frame = CGRect(x: self.spinner.frame.maxX + (self.padding / 2), y: self.titleLayer.frame.maxY - 3, width: self.smallDetentContainerView.bounds.width - self.spinner.frame.width, height: self.spinnerMessageLayer.fontSize + 5)
                self.view.layoutIfNeeded()
            }
            
        case .none, .some(_):
            break
        }
    }
}

extension TotalPriceVC: CalculationResultVCDelegate {
    func didEndCalculation(result: String, title: String) {
        calculatedCells += 1
        
        if !calculationTitles.contains(title) {
            calculationTitles.append(title)
            calculationResults.append(result)
        }
        if calculatedCells == amountOfCells {
            spinner.stopAnimating()
            spinnerMessageLayer.opacity = 0
            
            totalAmountLayer.string = CalculationUIHelper.calculateTotalPrice(calculationResults: calculationResults)
        }
    }
}
