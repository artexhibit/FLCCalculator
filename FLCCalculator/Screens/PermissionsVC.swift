import UIKit

class PermissionsVC: UIViewController {
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    private func configureVC() {
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Разрешения"
        setNavBarColor(color: UIColor.flcOrange)
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.register(PermissionsCell.self, forCellReuseIdentifier: PermissionsCell.reuseID)
        tableView.pinToSafeArea(of: view)
    }
    @objc func closeButtonPressed() { dismiss(animated: true) }
}

extension PermissionsVC: UITableViewDelegate {}
extension PermissionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PermissionsCell.reuseID, for: indexPath) as? PermissionsCell else { return UITableViewCell() }
        return cell
    }
}
