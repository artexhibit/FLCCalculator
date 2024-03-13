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
    
    private func getCities(target button: FLCListPickerButton) {
        Task {
            do {
                let items = try await NetworkManager.shared.getPecCities()
                CalculationUIHelper.presentListPickerVC(from: button, listener: transportView, items: items, sort: .bySubtitle, in: self)
                FLCPopupView.removePopupFromMainThread()
            } catch  {
                if let error = error as? URLError, error.code == .timedOut {
                    FLCPopupView.showOnMainThread(systemImage: "exclamationmark.icloud", title: "Плохое соединение. Попробуйте позже", style: .error)
                }
                FLCPopupView.showOnMainThread(systemImage: "exclamationmark.icloud", title: "Ошибка при загрузке городов", style: .error)
            }
        }
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
        case transportView.calculateButton:
            if CalculationUIHelper.confirmDataIsValid(in: transportView) { }
        default:
            break
        }
    }
    
    func didTapListPickerButton(_ button: FLCListPickerButton) {
        let pickedCountry = FLCCountryOption(rawValue: transportView.countryPickerButton.showingTitle) ?? .china
        
        if !button.inDisabledState { button.switchToOrangeColors() }
        view.endEditing(true)
        
        switch button {
        case cargoView.cargoTypePickerButton:
            CalculationUIHelper.presentListPickerVC(from: button, listener: cargoView, items: CalculationData.categories, in: self)
            
        case cargoView.invoiceCurrencyPickerButton:
            CalculationUIHelper.presentSheetPickerVC(items: CalculationData.currencyOptions, triggerButton: button, listener: cargoView, in: self)
            
        case transportView.countryPickerButton:
            CalculationUIHelper.presentSheetPickerVC(items: CalculationData.countriesOptions, triggerButton: button, listener: transportView, in: self, size: 0.2)
            transportView.flcListPickerButtons.forEach { if !$0.titleIsEmpty { transportView.listPickerButtonsWithTitle[$0] = true } }
   
        case transportView.deliveryTypePickerButton:
            guard !transportView.countryPickerButton.titleIsEmpty else {
                FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите страну отправления")
                return
            }
            let items = CalculationUIHelper.getItems(basedOn: pickedCountry, for: button)
            CalculationUIHelper.presentSheetPickerVC(items: items, triggerButton: button, listener: transportView, in: self, size: 0.45)
            
        case transportView.departurePickerButton:
            guard !transportView.countryPickerButton.titleIsEmpty else {
                FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите страну отправления")
                return
            }
            let items = CalculationUIHelper.getItems(basedOn: pickedCountry, for: button)
            CalculationUIHelper.presentListPickerVC(from: button, listener: transportView, items: items, in: self)
            
        case transportView.destinationPickerButton:
            guard !transportView.deliveryTypePickerButton.titleIsEmpty else {
                FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите условия поставки")
                return
            }
            guard !transportView.deliveryTypePickerButton.showingTitle.contains(CalculationData.russianWarehouseCity) else {
                FLCPopupView.showOnMainThread(systemImage: "hand.draw", title: "Измените условия поставки на клиента")
                return
            }
            FLCPopupView.showOnMainThread(title: "Загружаем города", style: .spinner)
            getCities(target: button)
            
        default:
            break
        }
    }
    
    func didSelectItem(triggerButton button: FLCListPickerButton) {
        
        switch button {
        case transportView.countryPickerButton:
            CalculationUIHelper.enableAll(buttons: transportView.flcListPickerButtons.dropLast())
            
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
