import UIKit

class CalculationResultVC: UIViewController {
    
    var calculationData: CalculationData?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureVCNavigation()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureVCNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setHidesBackButton(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "\(calculationData?.goodsType ?? "")"
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    @objc func closeButtonPressed() { navigationController?.popViewController(animated: true) }
}
