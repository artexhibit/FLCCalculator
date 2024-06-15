import UIKit

extension UITableView {
    
    func reloadTableViewOnMainThread() { DispatchQueue.main.async { self.reloadData() } }
    
    func hideFirstSeparator() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 1))
        headerView.backgroundColor = .clear
        self.tableHeaderView = headerView
    }
    
    func dequeueConfigurableCell<T: UITableViewCell & FLCConfigurableCell>(for indexPath: IndexPath, with item: SettingsCellContent) -> T {
        let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
        cell.configureSettingsCell(with: item)
        return cell
    }
    
    func pinToSafeArea(of view: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
