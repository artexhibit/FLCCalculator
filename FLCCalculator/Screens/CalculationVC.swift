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
        let pickedCountry = FLCCountryOption(rawValue: transportView.countryPickerButton.titleLabel?.text ?? "") ?? .china
        
        if !button.inDisabledState { button.switchToOrangeColors() }
        view.endEditing(true)
        
        switch button {
        case cargoView.cargoTypePickerButton:
            CalculationUIHelper.presentListPickerVC(from: button, listener: cargoView, type: .withSubtitle(CalculationData.categories), in: self)
            
        case cargoView.invoiceCurrencyPickerButton:
            CalculationUIHelper.presentSheetPickerVC(items: CalculationData.currencyOptions, triggerButton: button, listener: cargoView, in: self, size: 0.45)
            
        case transportView.countryPickerButton:
            CalculationUIHelper.presentSheetPickerVC(items: CalculationData.countriesOptions, triggerButton: button, listener: transportView, in: self, size: 0.2)
            transportView.listPickerButtons.forEach { if !$0.titleIsEmpty { transportView.listPickerButtonsWithTitle[$0] = true } }
   
        case transportView.deliveryTypePickerButton:
            guard !transportView.countryPickerButton.titleIsEmpty else {
                FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите страну отправления")
                return
            }
            let items: [FLCPickerItem] = CalculationUIHelper.getItems(basedOn: pickedCountry, for: button)
            CalculationUIHelper.presentSheetPickerVC(items: items, triggerButton: button, listener: transportView, in: self)
            
        case transportView.departurePickerButton:
            guard !transportView.countryPickerButton.titleIsEmpty else {
                FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите страну отправления")
                return
            }
            let items: [String] = CalculationUIHelper.getItems(basedOn: pickedCountry, for: button)
            CalculationUIHelper.presentListPickerVC(from: button, listener: transportView, type: .onlyTitle(items), in: self)
            
        case transportView.destinationPickerButton:
            guard !transportView.deliveryTypePickerButton.titleIsEmpty else {
                FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите условия поставки")
                return
            }
            
        default:
            break
        }
    }
    
    func didSelectItem(triggerButton button: FLCListPickerButton) {
        
        switch button {
        case transportView.countryPickerButton:
            CalculationUIHelper.enableAll(buttons: transportView.listPickerButtons.dropLast())
            
            if transportView.deliveryTypePickerButton.titleIsEmpty {
                transportView.destinationPickerButton.resetState(disable: true)
            }
            progressView.setProgress(.decrease, times: CalculationUIHelper.adjustProgressView(in: transportView))
            transportView.removeExtraTopPaddingBetweenFirstButtons()
            
        case transportView.deliveryTypePickerButton:
            CalculationUIHelper.setupDestinationButtonTitle(transportView.destinationPickerButton, basedOn: button)
            guard let progress = CalculationUIHelper.adjustProgressView(basedOn: transportView.destinationPickerButton, and: button) else { return }
            progressView.setProgress(progress)

        default:
            break
        }
    }
    
    func didEnterRequiredInfo() { progressView.setProgress(.increase) }
}

extension CalculationVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { view.endEditing(true) }
}
