import UIKit

class CalculationsVC: UIViewController {
    
    private let tableView = UITableView()
    private let emptyStateView = FLCEmptyStateView()
    private var calculations: [Calculation] = []
    private var dataSource: UITableViewDiffableDataSource<FLCSection, Calculation>!
    
    private var canAnimateCalcDifferences = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
        getCalculations()
        performICloudOperations()
        canAnimateCalcDifferences = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureVC()
        CalculationsVCHelper.showPermissionsVC(in: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { self.getCalculations() }
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        setNavBarColor(color: UIColor.flcOrange)
        navigationItem.title = CalculationsVCStrings.calculations
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
        let animatingDifferences = canAnimateCalcDifferences ? false : true
        var snapshot = NSDiffableDataSourceSnapshot<FLCSection, Calculation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.calculations)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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
                self.showEmptyStateView(withTitle: CalculationsVCStrings.noCalculations, andSubtitle: CalculationsVCStrings.newCalculationLabel)
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
        DispatchQueue.main.async {
            self.calculations = CoreDataManager.loadCalculations() ?? []
            self.updateUI()
        }
    }
    
    private func goToCalculation() {
        navigationItem.title = ""
        let calculationVC = CalculationVC()
        navigationController?.pushViewController(calculationVC, animated: true)
    }
    
    private func performICloudOperations() {
        ICloudManager.shared.delegate = self
        ICloudManager.shared.manageCalculationFromCloud(action: .sync)
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
        let deleteAction = UIContextualAction(style: .destructive, title: CalculationsVCStrings.deleteAction) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let calculationToDelete = self.calculations[indexPath.row]
            
            CoreDataManager.deleteCalculation(withID: calculationToDelete.id)
            CoreDataManager.reassignCalculationsID()
            ICloudManager.shared.manageCalculationFromCloud(with: calculationToDelete.cloudID, action: .delete)
            self.getCalculations()
            completionHandler(true)
        }
        deleteAction.image = FLCIcon.trashBin.icon.withTintColor(.red, renderingMode: .alwaysOriginal)
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

extension CalculationsVC: ICloudManagerDelegate {
    func calculationsUpdated() { getCalculations() }
}
