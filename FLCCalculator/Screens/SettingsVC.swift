import UIKit

class SettingsVC: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var sections = SettingsVCHelper.configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataSource()
        configureVC()
        configureTableView()
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
        tableView.register(SettingsMenuCell.self, forCellReuseIdentifier: SettingsMenuCell.reuseID)
        tableView.register(FLCTableViewHeader.self, forHeaderFooterViewReuseIdentifier: FLCTableViewHeader.reuseID)
    }
    private func updateDataSource() { sections = SettingsVCHelper.configureDataSource() }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItemContentType = sections[indexPath.section].items[indexPath.row].contentType
        
        switch selectedItemContentType {
        case .profile: SettingsVCHelper.showProfleSettingsVC(in: self)
        case .haptic, .theme: break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FLCTableViewHeader.reuseID) as? FLCTableViewHeader
        headerView?.set(title: sections[section].title)
        return headerView
    }
}

extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].items.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        
        switch item.cellType {
        case .profile:
            return tableView.dequeueConfigurableCell(for: indexPath, with: item) as SettingsProfileCell
        case .switcher:
            let cell = tableView.dequeueConfigurableCell(for: indexPath, with: item) as SettingsSwitchCell
            cell.delegate = self
            return cell
        case .menu:
            let cell = tableView.dequeueConfigurableCell(for: indexPath, with: item) as SettingsMenuCell
            cell.delegate = self
            return cell
        }
    }
}

extension SettingsVC: SettingsSwitchCellDelegate {
    func switchValueChanged(contentType: FLCSettingsContentType, state: Bool) {
        switch contentType {
        case .haptic: UserDefaultsManager.isHapticTurnedOn = state
        case .profile, .theme: break
        }
    }
}

extension SettingsVC: SettingsMenuCellDelegate {
    func menuButtonPressed(contentType: FLCSettingsContentType) {
        switch contentType {
        case .theme:
            updateDataSource()
            SettingsVCHelper.updateAppTheme(in: tableView, sections: sections, with: contentType)
        case .profile, .haptic: break
        }
    }
}

extension SettingsVC: ProfileSettingsVCDelegate {
    func didUpdateUserInfo() {
        updateDataSource()
        tableView.reloadRows(at: [SettingsVCHelper.getIndexPath(for: .profile, in: sections)], with: .none)
    }
}
