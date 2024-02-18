import UIKit

extension UITableView {
    
    func reloadTableViewOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
}
