import UIKit
import CoreData

class CalculationsVC: UIViewController {
    
    enum Section { case main }
    
    private let tableView = UITableView()
    private var emptyStateView = FLCEmptyStateView()
    private var calculations: [Calculation] = []
    private var dataSource: UITableViewDiffableDataSource<Section, Calculation>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI(with: calculations)
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonPressed() {
        let calc = Calculation(context: Persistence.shared.container.viewContext)
        calculations.append(calc)
        updateUI(with: calculations)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        
        tableView.register(CalculationCell.self, forCellReuseIdentifier: CalculationCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) in
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculationCell.reuseID, for: indexPath) as! CalculationCell
            cell.set(calculation: self.calculations[indexPath.row])
            return cell
        })
    }
    
    private func updateDataSource(on calculations: [Calculation]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Calculation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(calculations)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func showEmptyStateView(withTitle: String, andSubtitle: String) {
        emptyStateView = FLCEmptyStateView(titleText: withTitle, subtitleText: andSubtitle, delegate: self)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    private func updateUI(with calculations: [Calculation]) {
        if calculations.isEmpty {
            showEmptyStateView(withTitle: "Пока нет расчётов", andSubtitle: "Нажмите на + в правом верхнем углу или кнопку ниже, чтобы начать")
        } else {
            self.calculations = calculations
            
            DispatchQueue.main.async {
                self.view.bringSubviewToFront(self.tableView)
                self.emptyStateView.removeFromSuperview()
            }
            updateDataSource(on: self.calculations)
        }
    }
}

extension CalculationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calculations.count
    }
}

extension CalculationsVC: FLCEmptyStateViewDelegate {
    func didTapActionButton() {
        let calc = Calculation(context: Persistence.shared.container.viewContext)
        calculations.append(calc)
        updateUI(with: calculations)
    }
}
