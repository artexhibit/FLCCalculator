import UIKit

extension UITableView {
    
    func reloadTableViewOnMainThread() { DispatchQueue.main.async { self.reloadData() } }
    
    func hideFirstSeparator() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 1))
        headerView.backgroundColor = .clear
        self.tableHeaderView = headerView
    }
}
