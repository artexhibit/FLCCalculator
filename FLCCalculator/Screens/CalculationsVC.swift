import UIKit
import CoreData

class CalculationsVC: UIViewController {
    
    let tableView = UITableView()
    var calculations: [Calculation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let calc = Calculation(context: Persistence.shared.container.viewContext)
        
        calculations.append(calc)
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CalculationCell.self, forCellReuseIdentifier: CalculationCell.reuseID)
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
