import UIKit
import SwiftUI

class CalculationResultVC: UIViewController {
    
    private let tableView = UITableView()
    private var showingPopover = FLCPopoverVC()
    private var dataSource: UITableViewDiffableDataSource<FLCSection, CalculationResultItem>!
    private var calculationResultItems = [CalculationResultItem]()
    
    var calculationData: CalculationData!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureInitialData()
        configureDataSource()
        updateDataSource(on: calculationResultItems)
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.configureTapGesture(selector: #selector(self.viewTapped))
        
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
        calculationResultItems.append(contentsOf: [russianDeliveryItem, insuranceItem, deliveryFromWarehouseItem, cargoHandling, customsClearancePriceItem, customsWarehouseServicesItem])
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) in
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculationResultCell.reuseID, for: indexPath) as! CalculationResultCell
            cell.set(with: self.calculationResultItems[indexPath.row], in: self)
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
        if showingPopover.isShowing {  showingPopover.hidePopoverFromMainThread() }
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

extension CalculationResultVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let imageName = textAttachment.image, imageName.description.contains("info.circle") {
            HapticManager.addHaptic(style: .light)
            
            let popover = FLCPopoverVC()
            if showingPopover.isShowing != popover.isShowing { showingPopover.hidePopoverFromMainThread() }
            showingPopover = popover
            
            guard let cell = textView.superview?.superview?.superview as? CalculationResultCell else { return false }
            popover.showPopoverOnMainThread(withText: configureTipMessage(in: cell), in: self, target: textView, characterRange: characterRange)
            return false
        }
        return true
    }
    
    private func configureTipMessage(in cell: CalculationResultCell) -> String {
        switch cell.type {
        case .russianDelivery:
             "Наш партнёр по доставке - ПЭК. Груз будет доставлен для Вас согласно высочайшим стандартам компании."
        case .insurance:
             "Наш многолетний партнёр по страхованию - компания СК Пари. Страховка от полной стоимости инвойса."
        case .deliveryFromWarehouse:
             "Отправляемся из Шанхая каждые вторник и пятницу. Выезд из Гуанчжоу каждую пятницу под выход из Шанхая во вторник."
        case .cargoHandling:
             "Включены все операции по загрузке и выгрузке Вашего груза от склада отправления до склада назначения."
        case .customsClearancePrice:
            "В стоимость входит подача Таможенной Декларации, услуги брокера и ЭЦП брокера."
        case .customsWarehouseServices:
            "Услуги таможенного Склада Временного Хранения на время оформления груза. Дополнительные услуги по погрузке, разгрузке, хранению сверх норматива оплачиваются по тарифу с СВХ отдельно."
        }
    }
}

extension CalculationResultVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
