import UIKit
import SwiftUI

class CalculationResultVC: UIViewController {
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<FLCSection, CalculationResultItem>!
    private var calculationResultItems = [CalculationResultItem]()
    
    var calculationData: CalculationData?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureInitialData()
        configureDataSource()
        updateDataSource(on: calculationResultItems)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            guard let index = self.calculationResultItems.firstIndex(where: { $0.id == 1 }) else { return }
//            self.calculationResultItems[index].price = "2 998,44 $"
//            self.calculationResultItems[index].daysAmount = "4-5 дней"
//            guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CalculationResultCell else { return }
//                    cell.updateData(with: self.calculationResultItems[index])
//        }
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setHidesBackButton(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "\(calculationData?.goodsType ?? "")"
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
        let deliveryItem = CalculationResultItem(id: 1, title: "Доставка по России", subtitle: "Подольск - \(calculationData?.toLocation ?? "")")
        calculationResultItems.append(deliveryItem)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) in
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculationResultCell.reuseID, for: indexPath) as! CalculationResultCell
            cell.set(with: self.calculationResultItems[indexPath.row])
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
}

struct ViewControllerProvider: PreviewProvider {
  static var previews: some View { CalculationResultVC().showPreview() }
}
