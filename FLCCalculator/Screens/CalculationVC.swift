import UIKit

class CalculationVC: UIViewController {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let progressView = FLCProgressView()
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
        containerView.addSubviews(cargoParametersView, transportParametersView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 700)
        ])
    }
    
    private func configureCargoParametersView() {
        cargoParametersView.delegate = self
        
        leadingConstraint = cargoParametersView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([
            cargoParametersView.topAnchor.constraint(equalTo: containerView.topAnchor),
            leadingConstraint,
            cargoParametersView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            cargoParametersView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func configureTransportParametersView() {
        transportParametersView.delegate = self
        
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
    
    private func presentListPickerVC() {
        let listPickerVC = FLCListPickerVC(title: cargoParametersView.cargoTypePickerButton.smallLabelView.smallLabel.text ?? "", type: .cargo)
        listPickerVC.delegate = cargoParametersView
        let navController = UINavigationController(rootViewController: listPickerVC)
        present(navController, animated: true)
    }
    
    private func checkFilledData() -> Bool {
        if UIHelper.checkIfFilledAll(textFields: cargoParametersView.flcTextFields) && UIHelper.checkIfFilledAll(buttons: cargoParametersView.flcListPickerButtons)  {
            return true
        } else {
            UIHelper.makeRedAll(textFields: cargoParametersView.flcTextFields)
            UIHelper.makeRedAll(buttons: cargoParametersView.flcListPickerButtons)
            FeedbackGeneratorManager.addErrorHaptic()
            FLCPopupView.showOnMainThread(systemImage: "text.insert", title: "Сперва заполните все поля")
            return false
        }
    }
}

extension CalculationVC: FLCCalculationViewDelegate {
    func didTapFLCButton(_ button: FLCButton) {
        switch button {
        case cargoParametersView.nextButton:
            if checkFilledData() { showNextView() }
        default:
            break
        }
    }
    
    func didTapListPickerButton(_ button: FLCListPickerButton) {
        if !button.inDisabledState { button.switchToOrangeColors() }
        view.endEditing(true)
        
        switch button {
        case cargoParametersView.cargoTypePickerButton:
            presentListPickerVC()
        case cargoParametersView.invoiceCurrencyPickerButton:
            if UIHelper.checkIfTitleIsEmpty(in: button) { UIHelper.addProgressTo(progressView) }
        case transportParametersView.countryPickerButton:
            UIHelper.setEnabledAll(buttons: transportParametersView.flcListPickerButtons)
            UIHelper.setDeliveryTypeData(for: transportParametersView.deliveryTypePickerButton, basedOn: button)
        case transportParametersView.deliveryTypePickerButton:
            guard transportParametersView.countryPickerButton.titleLabel?.text == nil else { return }
            FLCPopupView.showOnMainThread(systemImage: "hand.tap", title: "Выберите страну отправления")
        default:
            break
        }
    }
    
    func didEnterRequiredInfo() { UIHelper.addProgressTo(progressView) }
}

extension CalculationVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { view.endEditing(true) }
}
