import UIKit
import SwiftUI

class CalculationResultVC: UIViewController {
    
    private let tableView = UITableView()
    private var showingTipView = FLCTipView()
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
        let russianDeliveryItem = CalculationResultItem(type: .russianDelivery, calculationData: calculationData, title: "Доставка по России", subtitle: "Подольск - \(calculationData.toLocation)")
        let insuranceItem = CalculationResultItem(type: .insurance, calculationData: calculationData, title: "Страхование", subtitle: "")
        calculationResultItems.append(contentsOf: [russianDeliveryItem, insuranceItem])
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
    
    @objc func closeButtonPressed() { navigationController?.popViewController(animated: true) }
}

extension CalculationResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calculationResultItems.count
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if showingTipView.isShowing { showingTipView.hideTipOnMainThread() }
    }
}

extension CalculationResultVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let imageName = textAttachment.image, imageName.description.contains("info.circle") {
            HapticManager.addHaptic(style: .light)
            
            let tipView = FLCTipView()
            if showingTipView.isShowing != tipView.isShowing { showingTipView.hideTipOnMainThread() }
            showingTipView = tipView
            
            guard let cell = textView.superview?.superview?.superview as? CalculationResultCell else { return false }
            let iconPosition = textView.getIconAttachmentPosition(for: characterRange)
            
            tipView.showTipOnMainThread(withText: configureTipMessage(in: cell), in: self.view, target: textView, trianglePosition: iconPosition)
            return false
        }
        return true
    }
    
    private func configureTipMessage(in cell: CalculationResultCell) -> String {
        switch cell.type {
        case .russianDelivery:
            return "Наш партнёр по доставке - ПЭК. Груз будет доставлен для Вас согласно высочайшим стандартам компании."
        case .insurance:
            return "Наш многолетний партнёр по страхованию - компания СК Пари. Страховка от полной стоимости инвойса."
        }
    }
}

//struct ViewControllerProvider: PreviewProvider {
//  static var previews: some View { CalculationResultVC().showPreview() }
//}
