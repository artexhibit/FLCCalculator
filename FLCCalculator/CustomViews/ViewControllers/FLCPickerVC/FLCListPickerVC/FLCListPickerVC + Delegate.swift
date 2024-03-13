import UIKit

extension FLCListPickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        searchController.dismiss(animated: true)
        delegate?.didSelectItem(pickedItem: dataSource.itemIdentifier(for: indexPath)?.title ?? "", triggerButton: triggerButton)
        triggerButton.smallLabelView.moveUpSmallLabel()
        closeViewController()
    }
}
