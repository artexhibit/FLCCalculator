import UIKit

protocol CalculationResultVCDelegate: AnyObject {
    func didEndCalculation(price: String, days: String?, cellType: FLCCalculationResultCellType)
    func didReceiveCellsAmount(amount: Int, calculationData: CalculationData)
    func didPressRetryButton(in cell: CalculationResultCell)
    func didChangeLogisticsType()
}

class CalculationResultVC: UIViewController {
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<FLCSection, CalculationResultItem>!
    private var calculationResultItems = [CalculationResultItem]()
    private var totalPriceVC = TotalPriceVC()
    private var allLogisticsTypes = [FLCLogisticsType]()
    private var totalPriceDataItems = [TotalPriceData]()
    private var pickedLogisticsType: FLCLogisticsType = .chinaTruck
    private var pickedTotalPriceData: TotalPriceData?
    
    var showingPopover = FLCPopoverVC()
    private var calculationData: CalculationData! {
        didSet {
            let country = FLCCountryOption(rawValue: calculationData.countryFrom)
            pickedLogisticsType = FLCLogisticsType.firstCase(for: country ?? .china) ?? .chinaTruck
            allLogisticsTypes = FLCLogisticsType.logisticsTypes(for: country ?? .china)
        }
    }
    
    private weak var delegate: CalculationResultVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureDataSource()
        calculationResultItems = CalculationResultHelper.configureInitialData(with: calculationData, pickedLogisticsType: pickedLogisticsType)
        performCalculations(pickedLogisticsType: pickedLogisticsType)
        
        Task { totalPriceDataItems = await CalculationResultHelper.getAllCalculationsFor(allLogisticsTypes: allLogisticsTypes, calculationData: calculationData) }
        CalculationHelper.showTotalPrice(vc: totalPriceVC, from: self)
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        configureTapGesture(selector: #selector(viewTapped))
        self.delegate = totalPriceVC
        totalPriceVC.delegate = self
        
        navigationController?.removeBottomBorder()
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
        tableView.register(FLCOptionsTableViewHeader.self, forHeaderFooterViewReuseIdentifier: FLCOptionsTableViewHeader.reuseID)
    }
    
    func performCalculations(for cell: CalculationResultCell? = nil, pickedLogisticsType: FLCLogisticsType) {
        delegate?.didReceiveCellsAmount(amount: calculationResultItems.count, calculationData: calculationData)
        
        DispatchQueue.main.async {
            if cell == nil {
                for i in self.calculationResultItems.indices {
                    if !self.calculationResultItems[i].hasError { self.calculationResultItems[i].isShimmering = true }
                }
                self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
            }
            
            for (index, item) in self.calculationResultItems.enumerated() {
                if let cell = cell, item.type != cell.type { continue }
                
                switch item.type {
                case .russianDelivery:
                    
                    guard !item.hasPrice else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.calculationResultItems[index].isShimmering = false
                            self.delegate?.didEndCalculation(price: item.price ?? "", days: item.daysAmount ?? "", cellType: item.type)
                            self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                        }
                        continue
                    }
                    Task {
                        let result = await CalculationResultHelper.getRussianDeliveryPrice(item: item)
                        
                        switch result {
                        case .success(let items):
                            self.calculationResultItems[index].price = items.price
                            self.calculationResultItems[index].daysAmount = items.days
                            self.calculationResultItems[index].hasError = false
                            self.calculationResultItems[index].hasPrice = true
                            self.calculationResultItems[index].isShimmering = false
                            
                            self.updateDataSource(on: self.calculationResultItems)
                            self.delegate?.didEndCalculation(price: items.price, days: items.days, cellType: item.type)
                            cell?.failedPriceCalcContainer.hide()
                            
                        case .failure(_):
                            self.calculationResultItems[index].hasError = true
                            self.calculationResultItems[index].isShimmering = false
                            
                            self.updateDataSource(on: self.calculationResultItems, animateChanges:  false)
                            self.delegate?.didEndCalculation(price: "", days: "0", cellType: item.type)
                            cell?.failedPriceCalcRetryButton.isUserInteractionEnabled = true
                        }
                        cell?.failedPriceCalcRetryButton.imageView?.stopRotationAnimation()
                    }
                case .insurance:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = CalculationResultHelper.getInsurancePrice(item: item, pickedLogisticsType: pickedLogisticsType).price
                        self.calculationResultItems[index].price = result
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result, days: nil, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .deliveryFromWarehouse:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = CalculationResultHelper.getDeliveryFromWarehousePrice(item: item, pickedLogisticsType: pickedLogisticsType)
                        self.calculationResultItems[index].price = result.price
                        self.calculationResultItems[index].daysAmount = result.days
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result.price, days: result.days, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .cargoHandling:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = CalculationResultHelper.getCargoHandlingPrice(item: item, pickedLogisticsType: pickedLogisticsType)
                        self.calculationResultItems[index].price = result
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result, days: nil, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .customsClearancePrice:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = CalculationResultHelper.getCustomsClearancePrice(item: item, pickedLogisticsType: pickedLogisticsType)
                        self.calculationResultItems[index].price = result
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result, days: nil, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .customsWarehouseServices:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = CalculationResultHelper.getCustomsWarehouseServicesPrice(item: item, pickedLogisticsType: pickedLogisticsType)
                        self.calculationResultItems[index].price = result
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result, days: nil, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .deliveryToWarehouse:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = CalculationResultHelper.getDeliveryToWarehousePrice(item: item)
                        self.calculationResultItems[index].price = result.price
                        self.calculationResultItems[index].daysAmount = CalculationResultHelper.getDeliveryToWarehousePrice(item: item).days
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result.price, days: result.days, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .groupageDocs:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = CalculationResultHelper.getGroupageDocs(item: item, pickedLogisticsType: pickedLogisticsType)
                        self.calculationResultItems[index].price = result
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result, days: nil, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                }
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) in
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculationResultCell.reuseID, for: indexPath) as! CalculationResultCell
            cell.delegate = self
            cell.set(with: self.calculationResultItems[indexPath.row], presentedVC: self.totalPriceVC, pickedLogisticsType: self.pickedLogisticsType)
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
        let detected = CalculationHelper.detectCloseButtonPressed(with: gesture, in: navigationController ?? UINavigationController())
        if detected { closeButtonPressed() }
    }
    func setCalculationData(data: CalculationData) { self.calculationData = data }
    @objc func closeButtonPressed() { navigationController?.popViewController(animated: true) }
}

extension CalculationResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calculationResultItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        DeviceTypes.isiPhoneSE3rdGen ? view.frame.height * 0.23 : view.frame.height * 0.13
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 65 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { UIView() }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FLCOptionsTableViewHeader.reuseID) as! FLCOptionsTableViewHeader
        headerView.optionsCollectionView.optionsDelegate = self
        headerView.optionsCollectionView.pickedCountry = FLCCountryOption(rawValue: calculationData.countryFrom)
        headerView.optionsCollectionView.setOptions(options: CalculationResultHelper.getOptions(basedOn: calculationData))
        return headerView
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

extension CalculationResultVC: CalculationResultCellDelegate {
    func didPressRetryButton(cell: CalculationResultCell) {
        delegate?.didPressRetryButton(in: cell)
        performCalculations(for: cell, pickedLogisticsType: pickedLogisticsType)
        Task { totalPriceDataItems = await CalculationResultHelper.getAllCalculationsFor(allLogisticsTypes: allLogisticsTypes, calculationData: calculationData) }
    }
}

extension CalculationResultVC: FLCOptionsCollectionViewDelegate {
    func didChangeLogisticsType(type: FLCLogisticsType) {
        delegate?.didChangeLogisticsType()
        pickedLogisticsType = type
        
        let newItems = CalculationResultHelper.configureInitialData(with: calculationData, pickedLogisticsType: pickedLogisticsType)
        calculationResultItems = CalculationResultHelper.saveNetworkingData(oldItems: calculationResultItems, newItems: newItems)
        performCalculations(pickedLogisticsType: type)
    }
}

extension CalculationResultVC: TotalPriceVCDelegate {
    func didPressSaveButton() {
        totalPriceDataItems = CalculationResultHelper.setFavouriteLogisticsType(totalPriceDataItems: totalPriceDataItems, pickedLogisticsType: pickedLogisticsType)
        CoreDataManager.createCalculationRecord(with: calculationData, totalPriceData: totalPriceDataItems)
        closeButtonPressed()
    }
    
    func didPressConfirmButton() {
        let confirmOrderVC = ConfirmOrderVC()
        navigationController?.pushViewController(confirmOrderVC, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.navigationController?.removeVCFromStack(vc: self)
        }
    }
}
