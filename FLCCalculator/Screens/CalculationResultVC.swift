import UIKit

protocol CalculationResultVCDelegate: AnyObject {
    func didEndCalculation(price: String, days: String?, cellType: FLCCalculationResultCellType)
    func didReceiveCellsAmount(amount: Int, calculationData: CalculationData?)
    func didPressRetryButton(in cell: CalculationResultCell)
    func didChangeLogisticsType()
}

class CalculationResultVC: UIViewController {
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<FLCSection, CalculationResultItem>!
    private var calculationResultItems = [CalculationResultItem]()
    private var totalPriceVC = TotalPriceVC()
    private var availableLogisticsTypes = [FLCLogisticsType]()
    private var totalPriceDataItems = [TotalPriceData]()
    private var pickedLogisticsType: FLCLogisticsType = .chinaTruck
    private var pickedTotalPriceData: TotalPriceData?
    private let emptyStateView = FLCEmptyStateView(withButton: false, yValue: -100)
    
    var showingPopover = FLCPopoverVC()
    private var maxWeight: Double { CalculationResultHelper.getMaxWeight(for: pickedLogisticsType) }
    private var calculationData: CalculationData? {
        didSet {
            guard let calculationData = calculationData else { return }
            pickedLogisticsType = FLCLogisticsType.firstCase(for: calculationData.countryFrom) ?? .chinaTruck
            availableLogisticsTypes = CalculationResultHelper.getAvailableLogisticsTypes(for: calculationData.countryFrom, and: calculationData)
            calculationResultItems = CalculationResultHelper.configureInitialData(with: calculationData, pickedLogisticsType: pickedLogisticsType)
     
            Task {
                totalPriceDataItems = await CalculationResultHelper.getAllCalculationsFor(allLogisticsTypes: availableLogisticsTypes, calculationData: calculationData)
                await CalculationResultHelper.manageCalculationDocument(with: calculationData, and: totalPriceDataItems)
            }
            if calculationData.isConfirmed {
                pickedLogisticsType = CalculationResultHelper.getConfirmedLogisticsType(calcData: calculationData)
            }
        }
    }
    
    private weak var delegate: CalculationResultVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureDataSource()
        performCalculations(pickedLogisticsType: pickedLogisticsType)
        updateEmptyStateView(with: pickedLogisticsType)
        CalculationHelper.showTotalPrice(vc: totalPriceVC, from: self)
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        configureTapGesture(selector: #selector(viewTapped))
        delegate = totalPriceVC
        totalPriceVC.delegate = self
        
        navigationController?.configNavBarAppearance()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setHidesBackButton(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "\(calculationData?.goodsType.localizedDescription.title ?? "")"
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.register(CalculationResultCell.self, forCellReuseIdentifier: CalculationResultCell.reuseID)
        tableView.register(OptionsTableViewHeader.self, forHeaderFooterViewReuseIdentifier: OptionsTableViewHeader.reuseID)
    }
    
    private func configureEmptyStateView() {
        UIView.performWithoutAnimation {
            view.addSubview(emptyStateView)
            emptyStateView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                emptyStateView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 85),
                emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        view.layoutIfNeeded()
    }
    
    private func updateEmptyStateView(with pickedLogisticsType: FLCLogisticsType) {
        let smallSize = DeviceTypes.isiPhoneSE3rdGen ? 0.21 : CalculationResultHelper.totalPriceScreenHeightMultiplier
        
        if calculationData?.weight ?? 0 > maxWeight && FLCLogisticsType.airLogisticsTypes.contains(pickedLogisticsType) {
            if emptyStateView.superview == nil {
                configureEmptyStateView()
                
                switch pickedLogisticsType {
                case .chinaTruck, .chinaRailway, .turkeyTruckByFerry, .turkeyNovorossiyskBySea: break
                case .chinaAir, .turkeyAirSVO, .turkeyAirVKO:
                    emptyStateView.setup(titleText: CalculationResultVCStrings.cantCalculateAviaLabel, subtitleText: "\(CalculationResultVCStrings.cantCalculateAviaLabelStart) - \(maxWeight) \(CommonStrings.currencyStringKg). \(CalculationResultVCStrings.cantCalculateAviaLabelEnd) - \(calculationData?.weight ?? 0) \(CommonStrings.currencyStringKg)")
                }
            }
            CalculationHelper.updateTotalPriceSmallDetentHeight(to: -50, in: totalPriceVC, from: self)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { self.emptyStateView.removeFromSuperview() }
            CalculationHelper.updateTotalPriceSmallDetentHeight(to: smallSize, in: totalPriceVC, from: self)
        }
    }
    
    func performCalculations(for cell: CalculationResultCell? = nil, pickedLogisticsType: FLCLogisticsType) {
        guard let calculationData = calculationData else { return }
        delegate?.didReceiveCellsAmount(amount: calculationResultItems.count, calculationData: calculationData)
        
        self.pickedTotalPriceData = CalculationResultHelper.getPickedTotalPriceData(with: calculationData, pickedLogisticsType: pickedLogisticsType)
        
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
                        let result = await CalculationResultHelper.getResultForRussianDelivery(calcData: calculationData, pickedTotalPriceData: self.pickedTotalPriceData, item: item)
                        
                        switch result {
                        case .success(let items):
                            let price = items.price.createDouble(removeSymbols: true).formatAsCurrency(symbol: item.currency)
                            let delay = calculationData.isFromCoreData ? 0.5 : 0.0
                            let canAnimateChanges = calculationData.isFromCoreData ? false : true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                self.calculationResultItems[index].price = price
                                self.calculationResultItems[index].daysAmount = items.days
                                self.calculationResultItems[index].hasError = false
                                self.calculationResultItems[index].hasPrice = true
                                self.calculationResultItems[index].isShimmering = false
                                
                                self.updateDataSource(on: self.calculationResultItems, animateChanges: canAnimateChanges)
                                self.delegate?.didEndCalculation(price: price, days: items.days, cellType: item.type)
                                cell?.failedPriceCalcContainer.hide()
                                
                                CalculationResultHelper.saveRefetchedRussianDelivery(calcData: calculationData, pickedTotalPriceData: self.pickedTotalPriceData, items: items)
                            }
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
                        let result = calculationData.isFromCoreData ? self.pickedTotalPriceData?.insurance?.createDouble(removeSymbols: true).formatAsCurrency(symbol: item.currency) ?? "" : CalculationResultHelper.getInsurancePrice(item: item, pickedLogisticsType: pickedLogisticsType).price
                        
                        self.calculationResultItems[index].price = result
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result, days: nil, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .deliveryFromWarehouse:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = CalculationResultHelper.getResultForDeliveryFromWarehouse(calcData: calculationData, pickedTotalPriceData: self.pickedTotalPriceData, item: item, pickedLogisticsType: pickedLogisticsType)
                        let daysAmount = calculationData.isFromCoreData ? self.pickedTotalPriceData?.deliveryFromWarehouseTime : result.days
                        
                        self.calculationResultItems[index].price = result.price
                        self.calculationResultItems[index].daysAmount = daysAmount
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result.price, days: result.days, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .cargoHandling:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = calculationData.isFromCoreData ? self.pickedTotalPriceData?.cargoHandling?.createDouble(removeSymbols: true).formatAsCurrency(symbol: item.currency) ?? "" : CalculationResultHelper.getCargoHandlingPrice(item: item, pickedLogisticsType: pickedLogisticsType)
                        
                        self.calculationResultItems[index].price = result
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result, days: nil, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .customsClearancePrice:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = calculationData.isFromCoreData ? self.pickedTotalPriceData?.customsClearance?.createDouble(removeSymbols: true).formatAsCurrency(symbol: item.currency) ?? "" : CalculationResultHelper.getCustomsClearancePrice(item: item, pickedLogisticsType: pickedLogisticsType)
                        
                        self.calculationResultItems[index].price = result
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result, days: nil, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .customsWarehouseServices:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = calculationData.isFromCoreData ? self.pickedTotalPriceData?.customsWarehousePrice?.createDouble(removeSymbols: true).formatAsCurrency(symbol: item.currency) ?? "" : CalculationResultHelper.getCustomsWarehouseServicesPrice(item: item, pickedLogisticsType: pickedLogisticsType)
                        
                        self.calculationResultItems[index].price = result
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result, days: nil, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .deliveryToWarehouse:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = CalculationResultHelper.getResultForDeliveryToWarehouse(calcData: calculationData, pickedTotalPriceData: self.pickedTotalPriceData, item: item, logisticsType: pickedLogisticsType)
                        let daysAmount = calculationData.isFromCoreData ? self.pickedTotalPriceData?.deliveryToWarehouseTime : result.days
        
                        self.calculationResultItems[index].price = result.price
                        self.calculationResultItems[index].daysAmount = daysAmount
                        self.calculationResultItems[index].isShimmering = false
                        self.delegate?.didEndCalculation(price: result.price, days: result.days, cellType: item.type)
                        self.updateDataSource(on: self.calculationResultItems, animateChanges: false)
                    }
                case .groupageDocs:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let result = calculationData.isFromCoreData ? self.pickedTotalPriceData?.groupageDocs?.createDouble(removeSymbols: true).formatAsCurrency(symbol: item.currency) ?? "" : CalculationResultHelper.getGroupageDocs(item: item, pickedLogisticsType: pickedLogisticsType)
                        
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
    @objc func closeButtonPressed() {
        navigationController?.popViewController(animated: true)
        totalPriceVC.dismiss(animated: true)
    }
}

extension CalculationResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calculationResultItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        DeviceTypes.isiPhoneSE3rdGen ? view.frame.height * 0.23 : view.frame.height * CalculationResultHelper.totalPriceScreenHeightMultiplier
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 65 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { UIView() }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: OptionsTableViewHeader.reuseID) as! OptionsTableViewHeader
        headerView.optionsCollectionView.optionsDelegate = self
        headerView.optionsCollectionView.setPickedCountry(country: calculationData?.countryFrom)
        headerView.optionsCollectionView.setOptions(options: CalculationResultHelper.getOptions(basedOn: availableLogisticsTypes), pickedLogisticsType: pickedLogisticsType)
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
        
        guard let calculationData = calculationData else { return }
        Task { totalPriceDataItems = await CalculationResultHelper.getAllCalculationsFor(allLogisticsTypes: availableLogisticsTypes, calculationData: calculationData) }
    }
}

extension CalculationResultVC: OptionsCollectionViewDelegate {
    func didChangeLogisticsType(type: FLCLogisticsType) {
        delegate?.didChangeLogisticsType()
        pickedLogisticsType = type
        
        guard let calculationData = calculationData else { return }
        let newItems = CalculationResultHelper.configureInitialData(with: calculationData, pickedLogisticsType: pickedLogisticsType)
        calculationResultItems = CalculationResultHelper.saveNetworkingData(oldItems: calculationResultItems, newItems: newItems)
        performCalculations(pickedLogisticsType: pickedLogisticsType)
        updateEmptyStateView(with: pickedLogisticsType)
    }
}

extension CalculationResultVC: TotalPriceVCDelegate {
    func didPressCloseButton() { closeButtonPressed() }
    
    func didPressSaveButton() {
        CalculationResultHelper.saveCalculationInCoreData(totalPriceDataItems: totalPriceDataItems, pickedLogisticsType: pickedLogisticsType, calcData: calculationData)
        ICloudManager.shared.manageCalculationFromCloud(action: .create)
        closeButtonPressed()
    }
    
    func didPressConfirmButton() {
        guard let calculationData = calculationData, let calculation = CoreDataManager.getCalculation(withID: calculationData.id) else { return }
        guard NetworkStatusManager.shared.isDeviceOnline else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.cantConfirmOrder, style: .error)
            return
        }
        
        if calculationData.isFromCoreData {
            CalculationResultHelper.saveConfirmedStatusForRefetchedResult(calcData: calculationData, pickedLogisticsType: pickedLogisticsType)
            ICloudManager.shared.manageCalculationFromCloud(with: calculation.cloudID, action: .update)

        } else {
            CalculationResultHelper.saveCalculationInCoreData(totalPriceDataItems: totalPriceDataItems, pickedLogisticsType: pickedLogisticsType, calcData: calculationData, isConfirmed: true)
            ICloudManager.shared.manageCalculationFromCloud(action: .create)
        }
        
        CalculationResultHelper.sendCalculationDataToAMOCRM(calculationData: calculationData)
        CalculationResultHelper.createConfirmOrderVC(data: calculationData, in: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { self.navigationController?.removeVCFromStack(vc: self) }
        Task { await FirebaseManager.updateCalculationRecordInFirebase(with: calculationData, and: totalPriceDataItems) }
    }
}
