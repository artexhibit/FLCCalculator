import UIKit

class TotalPriceVC: UIViewController {
    
    private var titleLayerContainerView = UIView()
    private let titleLayer = FLCTextLayer(fontSize: 25, fontWeight: .bold, color: .label, alignment: .left)
    private let padding: CGFloat = 15
    var amountOfCells = 0
    
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
        
        titleLayerContainerViewHeightConstraint = titleLayerContainerView.heightAnchor.constraint(equalToConstant: titleLayer.fontSize + 5)
        
        NSLayoutConstraint.activate([
            titleLayerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding * 1.5),
            titleLayerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 1.5),
            titleLayerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLayerContainerViewHeightConstraint
        ])
    }
    
    private func configureTitleLayer() {
        titleLayer.string = "Итого"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLayer.frame = titleLayerContainerView.bounds
    }
}

extension TotalPriceVC: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        
        switch sheetPresentationController.selectedDetentIdentifier {
        case .customSizeDetent:
            titleLayer.animateFont(toSize: 35, key: "increase")
            titleLayerContainerViewHeightConstraint.constant = titleLayer.fontSize + 5
            
        case .smallDetent:
            titleLayer.animateFont(toSize: 25, key: "decrease")
            titleLayerContainerViewHeightConstraint.constant = titleLayer.fontSize + 5
        case .none, .some(_):
            break
        }
    }
}
