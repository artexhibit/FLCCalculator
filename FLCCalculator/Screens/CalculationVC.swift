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
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonPressed))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func configureScrollView() {
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
}

extension CalculationVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        
        switch button {
        case cargoParametersView.nextButton:
            showNextView()
        default:
            break
        }
    }
}
