import UIKit

class CalculationResultVC: UIViewController {
    
    private let tableView = UITableView()
    var showingPopover = FLCPopoverVC()
    private var dataSource: UITableViewDiffableDataSource<FLCSection, CalculationResultItem>!
    var calculationResultItems = [CalculationResultItem]()
    private var totalPriceVC = TotalPriceVC()
    
    var calculationData: CalculationData!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureInitialData()
        configureDataSource()
        updateDataSource(on: calculationResultItems)
        CalculationUIHelper.showTotalPrice(vc: totalPriceVC, from: self)
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        configureTapGesture(selector: #selector(viewTapped))
        
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
        let russianDeliveryItem = CalculationResultItem(type: .russianDelivery, calculationData: calculationData, title: "Доставка по России", itemCellPriceCurrency: .RUB)
        let insuranceItem = CalculationResultItem(type: .insurance, calculationData: calculationData, title: "Страхование", itemCellPriceCurrency: .USD)
        let deliveryFromWarehouseItem = CalculationResultItem(type: .deliveryFromWarehouse, calculationData: calculationData, title: "Перевозка Сборного Груза", itemCellPriceCurrency: .USD)
        let cargoHandling = CalculationResultItem(type: .cargoHandling, calculationData: calculationData, title: "Погрузо-разгрузочные работы", itemCellPriceCurrency: .USD)
        let customsClearancePriceItem = CalculationResultItem(type: .customsClearancePrice, calculationData: calculationData, title: "Услуги по Таможенному Оформлению", itemCellPriceCurrency: .RUB)
        let customsWarehouseServicesItem = CalculationResultItem(type: .customsWarehouseServices, calculationData: calculationData, title: "Услуги СВХ", itemCellPriceCurrency: .RUB)
        let deliveryToWarehouseItem = CalculationResultItem(type: .deliveryToWarehouse, calculationData: calculationData, title: "Доставка до Склада Консолидации", itemCellPriceCurrency: .USD)
        
        calculationResultItems.append(contentsOf: [russianDeliveryItem, insuranceItem, deliveryFromWarehouseItem, cargoHandling, customsClearancePriceItem, customsWarehouseServicesItem, deliveryToWarehouseItem])
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) in
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculationResultCell.reuseID, for: indexPath) as! CalculationResultCell
            cell.set(with: self.calculationResultItems[indexPath.row], in: self, presentedVC: self.totalPriceVC)
            return cell
        })
    }
    
    private func updateDataSource(on calculationResultItems: [CalculationResultItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<FLCSection, CalculationResultItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(calculationResultItems)
        
        dataSource.apply(snapshot, animatingDifferences: true)
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
