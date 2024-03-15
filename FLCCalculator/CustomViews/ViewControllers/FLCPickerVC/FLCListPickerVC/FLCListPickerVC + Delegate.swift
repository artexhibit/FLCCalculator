import UIKit

extension FLCListPickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        searchController.dismiss(animated: true)
        
        guard let pickedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelectItem(pickedItem: pickedItem, triggerButton: triggerButton)
        triggerButton.smallLabelView.moveUpSmallLabel()
        closeViewController()
    }
}
