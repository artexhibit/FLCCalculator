import UIKit

protocol CalculationVCDelegate: AnyObject {
    func scrollViewDidScroll()
    func closeButtonPressed()
}

class CalculationVC: UIViewController {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let progressView = FLCProgressView()
    let cargoView = FLCCargoParametersView()
    let transportView = FLCTransportParametersView()
    
    private var pickedDestinationCode: String = ""
    private var departureAirport: String = ""
    private var leadingConstraint: NSLayoutConstraint!
    
    var delegate: CalculationVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureScrollView()
        configureContainerView()
        configureCargoParametersView()
        configureTransportParametersView()
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
        configureTapGesture(selector: #selector(viewTapped))
        
        view.addSubview(scrollView)
        view.backgroundColor = .systemBackground
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
    
    private func moveView(direction: FLCGoToViewDirections, times: CGFloat = 1, duration: Double = 0.3) {
        
        switch direction {
        case .forward:
            leadingConstraint.constant = -(cargoView.frame.width * times)
        case .backward:
            leadingConstraint.constant = 0
        }
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    private func getCities(target button: FLCListPickerButton) {
        Task {
            do {
                let items = try await NetworkManager.shared.getPecCities()
                CalculationHelper.presentListPickerVC(from: button, listener: transportView, items: items, sort: .bySubtitle, searchType: .onlyByTitle, in: self)
                FLCPopupView.removeFromMainThread()
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
    
    @objc private func viewTapped(_ gesture: UITapGestureRecognizer) {
        let detected = CalculationHelper.detectCloseButtonPressed(with: gesture, in: navigationController ?? UINavigationController())
        if detected { closeButtonPressed() }
        delegate?.closeButtonPressed()
    }
}

extension CalculationVC: FLCCalculationViewDelegate {
    func didTapFLCButton(_ button: FLCButton) {
        
        switch button {
        case cargoView.nextButton:
            if CalculationHelper.confirmDataIsValid(in: cargoView) { moveView(direction: .forward) }
            
        case transportView.calculateButton:
            if CalculationHelper.confirmDataIsValid(in: transportView) {
                let data = CalculationHelper.getCalculationData(transportView: transportView, cargoView: cargoView, pickedDestinationCode: pickedDestinationCode, departureAirport: departureAirport)

                CalculationResultHelper.createCalculationResultVC(data: data, from: self)
                moveView(direction: .forward, times: 2, duration: 0.25)
                navigationController?.removeVCFromStack(vc: self)
            }
            
        default: break
        }
    }
    
    func didTapListPickerButton(_ button: FLCListPickerButton) {
        let pickedCountry = FLCCountryOption(rawValue: transportView.countryPickerButton.showingTitle) ?? .china
        
        if !button.inDisabledState { button.switchToOrangeColors() }
        view.endEditing(true)
        
        switch button {
        case cargoView.cargoTypePickerButton:
            CalculationHelper.presentListPickerVC(from: button, listener: cargoView, items: CalculationInfo.categories, in: self)
            
        case cargoView.invoiceCurrencyPickerButton:
            CalculationHelper.presentSheetPickerVC(items: CalculationInfo.currencyOptions, triggerButton: button, listener: cargoView, in: self)
            
        case transportView.countryPickerButton:
            CalculationHelper.presentSheetPickerVC(items: CalculationInfo.countriesOptions, triggerButton: button, listener: transportView, in: self, size: 0.2)
            transportView.flcListPickerButtons.forEach { if !$0.titleIsEmpty { transportView.listPickerButtonsWithTitle[$0] = true } }
   
        case transportView.deliveryTypePickerButton:
            guard !transportView.countryPickerButton.titleIsEmpty else {
                FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите страну отправления")
                return
            }
            let items = CalculationHelper.getItems(basedOn: pickedCountry, for: button)
            CalculationHelper.presentSheetPickerVC(items: items, triggerButton: button, listener: transportView, in: self, size: 0.45)
            
        case transportView.departurePickerButton:
            guard !transportView.countryPickerButton.titleIsEmpty else {
                FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите страну отправления")
                return
            }
            guard !transportView.deliveryTypePickerButton.titleIsEmpty else {
                FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите условия поставки")
                return
            }
            
            if transportView.deliveryTypePickerButton.showingTitle.contains(FLCDeliveryTypeCodes.FCA.rawValue) && pickedCountry != .turkey {
                button.smallLabelView.moveUpSmallLabel()
                
                switch pickedCountry {
                case .china: button.setTitle(WarehouseStrings.chinaWarehouse, for: .normal)
                case .turkey: button.setTitle(WarehouseStrings.turkeyWarehouse, for: .normal)
                }
                
                CalculationHelper.presentSheetPickerVC(items: CalculationInfo.chinaAirportsOptions, triggerButton: button, listener: transportView, in: self, title: "Выберите аэропорт отправления для расчёта авиа логистики", cantCloseBySwipe: true)
            } else {
                if transportView.departurePickerButton.showingTitle == FLCCities.istanbul.rawValue {
                    CalculationHelper.showIstanbulZones(in: transportView, and: self)
                    return
                }
                let items = CalculationHelper.getItems(basedOn: pickedCountry, for: button)
                CalculationHelper.presentListPickerVC(from: button, listener: transportView, items: items, in: self)
            }
            
        case transportView.destinationPickerButton:
            guard !transportView.deliveryTypePickerButton.titleIsEmpty else {
                FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите условия поставки")
                return
            }
            guard !transportView.deliveryTypePickerButton.showingTitle.contains(WarehouseStrings.russianWarehouseCity) else {
                FLCPopupView.showOnMainThread(systemImage: "hand.draw", title: "Измените условия поставки на клиента")
                return
            }
            FLCPopupView.showOnMainThread(title: "Загружаем города", style: .spinner)
            getCities(target: button)
            
        default: break
        }
    }
    
    func didSelectItem(pickedItem: FLCPickerItem, triggerButton button: FLCListPickerButton) {
        pickedDestinationCode = pickedItem.id
        
        switch button {
        case transportView.countryPickerButton:
            CalculationHelper.enableAll(buttons: transportView.flcListPickerButtons.dropLast())
            
            if transportView.deliveryTypePickerButton.titleIsEmpty {
                transportView.departurePickerButton.resetState(isDisabled: true)
                transportView.destinationPickerButton.resetState(isDisabled: true)
            }
            transportView.removeExtraTopPaddingBetweenFirstButtons()
            transportView.calculateButton.removeShineEffect()
            
        case transportView.deliveryTypePickerButton:
            CalculationHelper.setupTitleFor(buttons: [(transportView.destinationPickerButton, WarehouseStrings.russianWarehouseCity), (transportView.departurePickerButton, "")], basedOn: button)
            
        case transportView.departurePickerButton:
            if transportView.departurePickerButton.showingTitle == FLCCities.istanbul.rawValue {
                CalculationHelper.showIstanbulZones(in: transportView, and: self)
            }
            departureAirport = pickedItem.title
        default: break
        }
        CalculationHelper.adjustProgressView(for: transportView.flcListPickerButtons, in: progressView)
        CalculationHelper.configureShineEffect(for: transportView.calculateButton, basedOn: transportView.flcListPickerButtons)
    }
    
    func didTapFLCTextButton(_ button: FLCTextButton) {
        switch button {
        case transportView.returnToPreviousViewButton: moveView(direction: .backward)
        default: break
        }
    }
    
    func didEnterRequiredInfo() { progressView.setProgress(.increase) }
}

extension CalculationVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        delegate?.scrollViewDidScroll()
    }
}

extension CalculationVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { .none }
}
