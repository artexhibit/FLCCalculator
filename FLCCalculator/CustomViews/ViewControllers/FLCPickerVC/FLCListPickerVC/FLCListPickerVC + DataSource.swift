import UIKit

var dataSource: UITableViewDiffableDataSource<String, FLCPickerItem>!
fileprivate var sections = [String]()

class FLCListPickerVCDataSource: UITableViewDiffableDataSource<String, FLCPickerItem> {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionIdentifier(for: section)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
}

extension FLCListPickerVC {
    
    func configureSections(with items: [FLCPickerItem]) {
        
        switch sortType {
        case .byTitle:
            sections = Array(Set(items.map { $0.title.first?.description ?? "" })).sorted()
        case .bySubtitle:
            sections = Array(Set(items.map { $0.subtitle.first?.description ?? "" })).sorted()
        }
        if items.contains(where: { $0.shouldDisplayOnTop }) { sections.insert("#", at: 0) }
    }
    
    func configureDataSource() {
        dataSource = FLCListPickerVCDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, listItem) in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListPickerCell.reuseID, for: indexPath) as! ListPickerCell
            cell.set(with: listItem)
            return cell
        })
    }
    
    func updateDataSource(with itemsToShow: [FLCPickerItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, FLCPickerItem>()
        snapshot.appendSections(sections)
        var items = [FLCPickerItem]()
        
        for section in sections {
            if section == "#" {
                items = itemsToShow.filter { $0.shouldDisplayOnTop }
            } else {
                switch sortType {
                case .byTitle:
                    items = itemsToShow.filter { $0.title.first?.description == section && !$0.shouldDisplayOnTop }
                case .bySubtitle:
                    items = itemsToShow
                        .filter { $0.subtitle.first?.description == section && !$0.shouldDisplayOnTop }
                        .sorted { $0.subtitle < $1.subtitle }
                }
            }
            snapshot.appendItems(items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
