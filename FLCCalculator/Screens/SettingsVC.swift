import UIKit

class SettingsVC: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var sections: [FLCSettingsSections] = FLCSettingsSections.allCases
    private let contents = [FLCContent(image: Icons.phone, title: "Использовать виброотклик")]
    private var user: FLCUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = UserDefaultsPercistenceManager.retrieveItemFromUserDefaults()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Настройки"
        setNavBarColor(color: UIColor.flcOrange)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.bounds
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsProfileCell.self, forCellReuseIdentifier: SettingsProfileCell.reuseID)
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: SettingsSwitchCell.reuseID)
        tableView.register(FLCTableViewHeader.self, forHeaderFooterViewReuseIdentifier: FLCTableViewHeader.reuseID)
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FLCTableViewHeader.reuseID) as? FLCTableViewHeader
        headerView?.set(title: sections[section].rawValue)
        return headerView
    }
}

extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return sections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .general, .profile: 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsProfileCell.reuseID, for: indexPath) as? SettingsProfileCell else { return UITableViewCell() }
            cell.set(with: user)
            return cell
        case .general:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSwitchCell.reuseID, for: indexPath) as! SettingsSwitchCell
            cell.set(with: contents[indexPath.row])
            return cell
        }
    }
}
