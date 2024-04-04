import UIKit

class TotalPriceVC: UIViewController {
    
    private var titleLayerContainerView = UIView()
    private let titleLayer = FLCTextLayer(fontSize: 25, fontWeight: .heavy, color: .accent, alignment: .left)
    private let totalAmountLayer = FLCTextLayer(fontSize: 20, fontWeight: .semibold, color: .label, alignment: .left)
    private let padding: CGFloat = 15
    
    var amountOfCells = 0
    private var calculatedCells: Int = 0
    private var calculationTitles = [String]()
    private var calculationResults = [String]()
    
    var titleLayerContainerViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTitleLayerContainerView()
        configureTitleLayer()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLayerContainerView)
        
        sheetPresentationController?.delegate = self
    }
    
    private func configureTitleLayerContainerView() {
        titleLayerContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleLayerContainerView.layer.addSublayer(titleLayer)
        titleLayerContainerView.layer.addSublayer(totalAmountLayer)
        
        titleLayerContainerViewHeightConstraint = titleLayerContainerView.heightAnchor.constraint(equalToConstant: titleLayer.fontSize + totalAmountLayer.fontSize + (padding / 2) + 5)
        
        NSLayoutConstraint.activate([
            titleLayerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding * 1.5),
            titleLayerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 1.5),
            titleLayerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLayerContainerViewHeightConstraint
        ])
    }
    
    private func configureTitleLayer() {
        titleLayer.string = "Итого"
        titleLayer.frame = CGRect(x: 0, y: 0, width: titleLayerContainerView.bounds.width, height: titleLayer.fontSize + 5)
    }
    
    private func configureTotalAmountLayer() {
        let totalAmountLayerY = titleLayer.frame.maxY + (padding / 2)
        let estimatedTotalHeight = (totalAmountLayer.fontSize * 1.2) * 2
        
        totalAmountLayer.frame = CGRect(x: 0, y: totalAmountLayerY, width: titleLayerContainerView.bounds.width, height: estimatedTotalHeight)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTitleLayer()
        configureTotalAmountLayer()
    }
}

extension TotalPriceVC: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        
        switch sheetPresentationController.selectedDetentIdentifier {
        case .customSizeDetent:
            titleLayer.animateFont(toSize: 35, key: "increase")
            totalAmountLayer.animateFont(toSize: 26, key: "increase")
            titleLayerContainerViewHeightConstraint = titleLayerContainerView.heightAnchor.constraint(equalToConstant: titleLayer.fontSize + totalAmountLayer.fontSize + (padding / 2) + 5)
            
        case .smallDetent:
            titleLayer.animateFont(toSize: 25, key: "decrease")
            totalAmountLayer.animateFont(toSize: 20, key: "increase")
            titleLayerContainerViewHeightConstraint = titleLayerContainerView.heightAnchor.constraint(equalToConstant: titleLayer.fontSize + totalAmountLayer.fontSize + (padding / 2) + 5)
        case .none, .some(_):
            break
        }
    }
}

extension TotalPriceVC: CalculationResultCellDelegate {
    func didEndCalculation(result: String, title: String) {
        calculatedCells += 1
        
        if !calculationTitles.contains(title) {
            calculationTitles.append(title)
            calculationResults.append(result)
        }
        if calculatedCells == amountOfCells {
            totalAmountLayer.string = CalculationUIHelper.calculateTotalPrice(calculationResults: calculationResults)
        }
    }
}
