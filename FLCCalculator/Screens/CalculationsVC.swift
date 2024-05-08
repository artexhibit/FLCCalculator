import UIKit
import CoreData

class CalculationsVC: UIViewController {
    
    private let tableView = UITableView()
    private var emptyStateView = FLCEmptyStateView()
    private var calculations: [Calculation] = []
    private var dataSource: UITableViewDiffableDataSource<FLCSection, Calculation>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
        getCalculations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCalculations()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Расчёты"
        tabBarController?.tabBar.isHidden = false
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        if navigationItem.rightBarButtonItem == nil { navigationItem.rightBarButtonItem = addButton }
    }
    
    @objc func addButtonPressed() { goToCalculation() }
    
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
        var snapshot = NSDiffableDataSourceSnapshot<FLCSection, Calculation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(calculations)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func showEmptyStateView(withTitle: String, andSubtitle: String) {
        emptyStateView = FLCEmptyStateView(titleText: withTitle, subtitleText: andSubtitle)
        emptyStateView.frame = view.bounds
        emptyStateView.actionButton.delegate = self
        view.addSubview(emptyStateView)
    }
    
    private func updateUI(with calculations: [Calculation]) {
        if calculations.isEmpty {
            showEmptyStateView(withTitle: "Пока нет расчётов", andSubtitle: "Нажмите на + в правом верхнем углу или кнопку ниже, чтобы начать")
        } else {
            self.calculations = calculations
            
            DispatchQueue.main.async {
                self.emptyStateView.removeFromSuperview()
                self.view.bringSubviewToFront(self.tableView)
            }
            updateDataSource(on: self.calculations)
        }
    }
    
    private func getCalculations() {
        calculations = CoreDataManager.loadCalculations() ?? []
        updateUI(with: calculations)
    }
    
    private func goToCalculation() {
        navigationItem.title = ""
        let calculationVC = CalculationVC()
        navigationController?.pushViewController(calculationVC, animated: true)
    }
}

extension CalculationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calculations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pickedCalculation = calculations[indexPath.row]
        let results = pickedCalculation.result as? Set<CalculationResult>
        let calculationData = CalculationsVCHelper.createStoredCalculationData(pickedCalculation: pickedCalculation, results: results)
        
        CalculationResultHelper.createCalculationResultVC(data: calculationData, from: self)
    }
}

extension CalculationsVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        
        switch button {
        case emptyStateView.actionButton: goToCalculation()
        default: break
        }
    }
}
