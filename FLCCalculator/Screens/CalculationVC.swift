import UIKit

class CalculationVC: UIViewController {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let progressView = FLCProgressView()
    let cargoView = FLCCargoParametersView()
    let transportView = FLCTransportParametersView()
    
    var leadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureVCNavigation()
        configureProgressBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        progressView.removeFromSuperview()
    }
    
    private func configureVC() {
        view.addSubview(containerView)
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureContainerView()
        configureCargoParametersView()
        configureTransportParametersView()
    }
    
    private func configureProgressBar() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            progressView.widthAnchor.constraint(equalTo: navigationBar.widthAnchor, multiplier: 0.5)
        ])
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
        containerView.addSubviews(cargoView, transportView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 700)
        ])
    }
    
    private func configureCargoParametersView() {
        cargoView.delegate = self
        
        leadingConstraint = cargoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([
            cargoView.topAnchor.constraint(equalTo: containerView.topAnchor),
            leadingConstraint,
            cargoView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            cargoView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func configureTransportParametersView() {
        transportView.delegate = self
        
        NSLayoutConstraint.activate([
            transportView.topAnchor.constraint(equalTo: containerView.topAnchor),
            transportView.leadingAnchor.constraint(equalTo: cargoView.trailingAnchor),
            transportView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            transportView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
    }
    
    private func showNextView() {
        leadingConstraint.constant = -(cargoView.frame.width)
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
    
    @objc func closeButtonPressed() {
        if (leadingConstraint.constant == -(cargoView.frame.width)) {
            cargoView.removeFromSuperview()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func handleTapForDeparturePickerButton(_ button: FLCListPickerButton) {
        CalculationUIHelper.confirmCountryIsPicked(in: transportView) { [weak self] country in
            guard let self = self else { return }
            
            switch country {
            case .china:
                CalculationUIHelper.presentListPickerVC(from: button, listener: transportView, type: .onlyTitle(CalculationData.chinaLocations), in: self)
            case .turkey:
                CalculationUIHelper.presentListPickerVC(from: button, listener: transportView, type: .onlyTitle(CalculationData.turkeyLocations), in: self)
            case nil:
                break
            }
        }
    }
}

extension CalculationVC: FLCCalculationViewDelegate {
    func didTapFLCButton(_ button: FLCButton) {
        switch button {
        case cargoView.nextButton:
            if CalculationUIHelper.confirmDataIsValid(in: cargoView) { showNextView() }
        default:
            break
        }
    }
    
    func didTapListPickerButton(_ button: FLCListPickerButton) {
        if !button.inDisabledState { button.switchToOrangeColors() }
        view.endEditing(true)
        
        switch button {
        case cargoView.cargoTypePickerButton:
            CalculationUIHelper.presentListPickerVC(from: button, listener: cargoView, type: .withSubtitle(CalculationData.categories), in: self)
            
        case cargoView.invoiceCurrencyPickerButton:
            if button.titleIsEmpty { progressView.setProgress(.increase) }
            
        case transportView.countryPickerButton:
            CalculationUIHelper.enableAll(buttons: transportView.flcListPickerButtons.dropLast())
            CalculationUIHelper.setDeliveryTypeData(for: transportView.deliveryTypePickerButton, basedOn: button)
            if button.titleIsEmpty { progressView.setProgress(.increase) }
            
            if !transportView.deliveryTypePickerButton.titleIsEmpty {
                transportView.destinationPickerButton.resetState(disable: true)
            }
   
        case transportView.deliveryTypePickerButton:
            CalculationUIHelper.confirmCountryIsPicked(in: transportView) { [weak self] country in
                guard let self, country != nil else { return }
                if button.titleIsEmpty { progressView.setProgress(.increase) }
                let oldTitle = transportView.destinationPickerButton.titleLabel?.text ?? ""
                
                if !button.titleIsEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        let title = CalculationUIHelper.setupDestinationButtonTitle(self.transportView.destinationPickerButton, basedOn: button)
                        
                        if title != oldTitle {
                            let progressType: ProgressViewOption = title != "" ? .increase : .decrease
                            self.progressView.setProgress(progressType)
                        }
                    }
                }
            }
            
        case transportView.departurePickerButton:
            handleTapForDeparturePickerButton(button)
        
        case transportView.destinationPickerButton:
            CalculationUIHelper.confirmCountryIsPicked(in: transportView) {_ in }
        
        default:
            break
        }
    }
    
    func didEnterRequiredInfo() { progressView.setProgress(.increase) }
}

extension CalculationVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { view.endEditing(true) }
}
