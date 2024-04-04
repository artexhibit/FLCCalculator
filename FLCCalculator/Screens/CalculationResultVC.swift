import UIKit

protocol CalculationResultVCDelegate: AnyObject {
    func didEndCalculation(result: String, title: String)
}

class CalculationResultVC: UIViewController {
    
    private let tableView = UITableView()
    var showingPopover = FLCPopoverVC()
    private var dataSource: UITableViewDiffableDataSource<FLCSection, CalculationResultItem>!
    var calculationResultItems = [CalculationResultItem]()
    private var totalPriceVC = TotalPriceVC()
    
    var calculationData: CalculationData!
    private var delegate: CalculationResultVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureInitialData()
        configureDataSource()
        updateDataSource(on: calculationResultItems)
        performCalculations()
        CalculationUIHelper.showTotalPrice(vc: totalPriceVC, from: self)
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        configureTapGesture(selector: #selector(viewTapped))
        self.delegate = totalPriceVC
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setHidesBackButton(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "\(calculationData.goodsType)"
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.register(CalculationResultCell.self, forCellReuseIdentifier: CalculationResultCell.reuseID)
    }
    
    private func configureInitialData() {
        let russianDeliveryItem = CalculationResultItem(type: .russianDelivery, calculationData: calculationData, title: "Доставка по России", currency: .RUB)
        let insuranceItem = CalculationResultItem(type: .insurance, calculationData: calculationData, title: "Страхование", currency: .USD)
        let deliveryFromWarehouseItem = CalculationResultItem(type: .deliveryFromWarehouse, calculationData: calculationData, title: "Перевозка Сборного Груза", currency: .USD)
        let cargoHandling = CalculationResultItem(type: .cargoHandling, calculationData: calculationData, title: "Погрузо-разгрузочные работы", currency: .USD)
        let customsClearancePriceItem = CalculationResultItem(type: .customsClearancePrice, calculationData: calculationData, title: "Услуги по Таможенному Оформлению", currency: .RUB)
        let customsWarehouseServicesItem = CalculationResultItem(type: .customsWarehouseServices, calculationData: calculationData, title: "Услуги СВХ", currency: .RUB)
        let deliveryToWarehouseItem = CalculationResultItem(type: .deliveryToWarehouse, calculationData: calculationData, title: "Доставка до Склада Консолидации", currency: .USD)
        
        calculationResultItems.append(contentsOf: [russianDeliveryItem, insuranceItem, deliveryFromWarehouseItem, cargoHandling, customsClearancePriceItem, customsWarehouseServicesItem, deliveryToWarehouseItem])
    }
    
    func performCalculations() {
        for (index, item) in calculationResultItems.enumerated() {
            switch item.type {
            case .russianDelivery:
                CalculationResultHelper.getRussianDeliveryPrice(item: item) { [weak self] result in
                    guard let self else { return }
                    
                    DispatchQueue.main.async {
                        self.calculationResultItems[index].price = result.price
                        self.calculationResultItems[index].daysAmount = result.days
                        self.updateDataSource(on: self.calculationResultItems)
                        self.delegate?.didEndCalculation(result: result.price, title: item.title)
                    }
                }
            case .insurance:
                DispatchQueue.main.async {
                    let result = CalculationResultHelper.getInsurancePrice(item: item).price
                    self.calculationResultItems[index].price = result
                    self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    self.delegate?.didEndCalculation(result: result, title: item.title)
                }
            case .deliveryFromWarehouse:
                DispatchQueue.main.async {
                    let result = CalculationResultHelper.getDeliveryFromWarehousePrice(item: item)
                    self.calculationResultItems[index].price = result
                    self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    self.delegate?.didEndCalculation(result: result, title: item.title)
                }
            case .cargoHandling:
                DispatchQueue.main.async {
                    let result = CalculationResultHelper.getCargoHandlingPrice(item: item)
                    self.calculationResultItems[index].price = result
                    self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    self.delegate?.didEndCalculation(result: result, title: item.title)
                }
            case .customsClearancePrice:
                DispatchQueue.main.async {
                    let result = CalculationResultHelper.getCustomsClearancePrice(item: item)
                    self.calculationResultItems[index].price = result
                    self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    self.delegate?.didEndCalculation(result: result, title: item.title)
                }
            case .customsWarehouseServices:
                DispatchQueue.main.async {
                    let result = CalculationResultHelper.getCustomsWarehouseServicesPrice(item: item)
                    self.calculationResultItems[index].price = result
                    self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    self.delegate?.didEndCalculation(result: result, title: item.title)
                }
            case .deliveryToWarehouse:
                DispatchQueue.main.async {
                    let result = CalculationResultHelper.getDeliveryToWarehousePrice(item: item).price
                    self.calculationResultItems[index].price = result
                    self.calculationResultItems[index].daysAmount = CalculationResultHelper.getDeliveryToWarehousePrice(item: item).days
                    self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    self.delegate?.didEndCalculation(result: result, title: item.title)
                }
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) in
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculationResultCell.reuseID, for: indexPath) as! CalculationResultCell
            cell.set(with: self.calculationResultItems[indexPath.row], presentedVC: self.totalPriceVC)
            return cell
        })
    }
    
    private func updateDataSource(on calculationResultItems: [CalculationResultItem], animateChanges: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<FLCSection, CalculationResultItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(calculationResultItems)
        
        dataSource.apply(snapshot, animatingDifferences: animateChanges)
    }
    
    @objc private func viewTapped(_ gesture: UITapGestureRecognizer) {
        if showingPopover.isShowing { showingPopover.hidePopoverFromMainThread() }
       let detected = CalculationUIHelper.detectCloseButtonPressed(with: gesture, in: navigationController ?? UINavigationController())
        if detected { closeButtonPressed() }
    }
    @objc func closeButtonPressed() { navigationController?.popViewController(animated: true) }
}

extension CalculationResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calculationResultItems.count
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if showingPopover.isShowing { showingPopover.hidePopoverFromMainThread() }
    }
}

extension CalculationResultVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
