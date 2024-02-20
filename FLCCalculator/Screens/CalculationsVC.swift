import UIKit
import CoreData

class CalculationsVC: UIViewController {
    
    private let tableView = UITableView()
    private var calculations: [Calculation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
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
    
    private func updateUI(with calculations: [Calculation]) {
        if calculations.isEmpty {
            showEmptyStateView(withTitle: "Пока нет расчётов", andSubtitle: "Нажмите на + в правом верхнем углу или кнопку ниже, чтобы начать")
        } else {
            self.calculations = calculations
            tableView.reloadTableViewOnMainThread()
            DispatchQueue.main.async { self.view.bringSubviewToFront(self.tableView) }
        }
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CalculationCell.self, forCellReuseIdentifier: CalculationCell.reuseID)
    }
    
    private func showEmptyStateView(withTitle: String, andSubtitle: String) {
        let emptyStateView = FLCEmptyStateView(titleText: withTitle, subtitleText: andSubtitle)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}

extension CalculationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calculations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalculationCell.reuseID, for: indexPath) as! CalculationCell
        cell.set(calculation: calculations[indexPath.row])
        return cell
    }
}
