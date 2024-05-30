import UIKit

class CalculationsVC: UIViewController {
    
    private let tableView = UITableView()
    private let emptyStateView = FLCEmptyStateView()
    private var calculations: [Calculation] = []
    private var dataSource: UITableViewDiffableDataSource<FLCSection, Calculation>!

    override func viewDidLoad() {
        super.viewDidLoad()
        CalculationsVCHelper.presentRegistrationVC(in: self)

        configureTableView()
        configureDataSource()
        getCalculations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureVC()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { self.getCalculations() }
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        setNavBarColor(color: UIColor.flcOrange)
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
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<FLCSection, Calculation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.calculations)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func showEmptyStateView(withTitle: String, andSubtitle: String) {
        if !emptyStateView.isDescendant(of: view) {
            emptyStateView.frame = view.bounds
            emptyStateView.setup(titleText: withTitle, subtitleText: andSubtitle)
            emptyStateView.setDelegate(for: self)
            view.addSubview(emptyStateView)
        }
    }
    
    private func updateUI() {
        updateDataSource()
        
        if calculations.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.showEmptyStateView(withTitle: "Пока нет расчётов", andSubtitle: "Нажмите на + в правом верхнем углу или кнопку ниже, чтобы начать")
            }
        } else {
            DispatchQueue.main.async {
                self.emptyStateView.removeFromSuperview()
                self.view.bringSubviewToFront(self.tableView)
            }
            updateDataSource()
        }
    }
    
    private func getCalculations() {
        self.calculations = CoreDataManager.loadCalculations() ?? []
        updateUI()
    }
    
    private func goToCalculation() {
        navigationItem.title = ""
        let calculationVC = CalculationVC()
        navigationController?.pushViewController(calculationVC, animated: true)
    }
}

extension CalculationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.calculations.count }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pickedCalculation = calculations[indexPath.row]
        let results = pickedCalculation.result as? Set<CalculationResult>
        let calculationData = CalculationsVCHelper.createStoredCalculationData(pickedCalculation: pickedCalculation, results: results)
        
        CalculationResultHelper.createCalculationResultVC(data: calculationData, from: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            CoreDataManager.deleteCalculation(withID: self.calculations[indexPath.row].id)
            CoreDataManager.reassignCalculationsId()
            self.getCalculations()
            completionHandler(true)
        }
        deleteAction.image = Icons.trashBin.withTintColor(.red, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension CalculationsVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        
        switch button {
        case emptyStateView.getActionButton(): goToCalculation()
        default: break
        }
    }
}
