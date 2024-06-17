import UIKit

protocol PermissionsVCDelegate: AnyObject {
    func shouldUpdatePermissionButtonWithStatus(status: Bool, type: FLCPermissionType)
}

class PermissionsVC: UIViewController {
    
    private let tableView = UITableView()
    
    weak var delegate: PermissionsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        NotificationsManager.notifyWhenInForeground(self, selector: #selector(appWillEnterForeground))
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
    @objc private func appWillEnterForeground() { PermissionsVCHelper.updateUIWithNotificationsAuthorizationStatus(delegate: delegate) }
}

extension PermissionsVC: UITableViewDelegate {}

extension PermissionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PermissionsCell.reuseID, for: indexPath) as? PermissionsCell else { return UITableViewCell() }
        cell.delegate = self
        delegate = cell as PermissionsVCDelegate
        PermissionsVCHelper.updateUIWithNotificationsAuthorizationStatus(delegate: delegate)
        return cell
    }
}

extension PermissionsVC: PermissionsCellDelegate {
    func didTapPermissionButton(_ type: FLCPermissionType) {
        switch type {
        case .notifications:
            Task {
                let settings = await PermissionsManager.getNotificationSettings()
                
                switch settings {
                case .notDetermined: PermissionsVCHelper.requestFirstNotificationsAlert(delegate: delegate)
                case .denied, .authorized, .provisional, .ephemeral: PermissionsManager.openAppPermissionsSettings()
                @unknown default: break
                }
            }
        }
    }
}
