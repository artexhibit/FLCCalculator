import UIKit

class BonusSystemVC: UIViewController {
    
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
        navigationItem.title = "Бонусный счёт"
        setNavBarColor(color: UIColor.flcOrange)
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    private func configureTableView() {
        tableView.pinToEdges(of: view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(BonusSystemCell.self, forCellReuseIdentifier: BonusSystemCell.reuseID)
    }
    @objc func closeButtonPressed() { dismiss(animated: true) }
}

extension BonusSystemVC: UITableViewDelegate {}
extension BonusSystemVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: BonusSystemCell.reuseID, for: indexPath) as! BonusSystemCell
    }
}
