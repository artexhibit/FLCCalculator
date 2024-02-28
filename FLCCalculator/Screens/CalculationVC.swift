import UIKit

class CalculationVC: UIViewController {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let cargoParametersView = FLCCargoParametersView()
    let transportParametersView = FLCTransportParametersView()
    
    var leadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureVCNavigation()
    }
    
    private func configureVC() {
        view.addSubview(containerView)
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureContainerView()
        configureCargoParametersView()
        configureTransportParametersView()
    }
    
    private func configureVCNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.setHidesBackButton(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.pinToEdges(of: view)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func configureContainerView() {
        containerView.addSubviews(cargoParametersView, transportParametersView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 700)
        ])
    }
    
    private func configureCargoParametersView() {
        cargoParametersView.nextButton.delegate = self
        cargoParametersView.cargoTypePickerButton.delegate = self
        cargoParametersView.invoiceCurrencyPickerButton.delegate = self
        
        leadingConstraint = cargoParametersView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([
            cargoParametersView.topAnchor.constraint(equalTo: containerView.topAnchor),
            leadingConstraint,
            cargoParametersView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            cargoParametersView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func configureTransportParametersView() {
        NSLayoutConstraint.activate([
            transportParametersView.topAnchor.constraint(equalTo: containerView.topAnchor),
            transportParametersView.leadingAnchor.constraint(equalTo: cargoParametersView.trailingAnchor),
            transportParametersView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            transportParametersView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
    }
    
    private func showNextView() {
        leadingConstraint.constant = -(cargoParametersView.frame.width)
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
    
    @objc func closeButtonPressed() {
        if (leadingConstraint.constant == -(cargoParametersView.frame.width)) {
            cargoParametersView.removeFromSuperview()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkIfAllTextFieldsAreFilled() -> Bool {
        cargoParametersView.flcTextFields.forEach { $0.text?.isEmpty ?? true ? $0.makeRed() : nil }
        return cargoParametersView.flcTextFields.allSatisfy { !($0.text?.isEmpty ?? true) }
    }
}

extension CalculationVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        
        switch button {
        case cargoParametersView.nextButton:
            if checkIfAllTextFieldsAreFilled() { showNextView() }
        default:
            break
        }
    }
}

extension CalculationVC: FLCListPickerButtonDelegate {
    func buttonTapped(_ button: FLCListPickerButton) {
        
        switch button {
        case cargoParametersView.cargoTypePickerButton:
            let listPickerVC = FLCListPickerVC(title: cargoParametersView.cargoTypePickerButton.smallLabelView.smallLabel.text ?? "", type: .cargo)
            listPickerVC.delegate = cargoParametersView
            let navController = UINavigationController(rootViewController: listPickerVC)
            present(navController, animated: true)
        case cargoParametersView.invoiceCurrencyPickerButton:
            break
        default:
            break
        }
    }
}

extension CalculationVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { view.endEditing(true) }
}