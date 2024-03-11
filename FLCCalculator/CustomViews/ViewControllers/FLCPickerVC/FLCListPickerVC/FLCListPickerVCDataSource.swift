import UIKit

class FLCListPickerVCDataSource: UITableViewDiffableDataSource<String, FLCPickerItem> {
    
    private var sections = [String]()
    
    init(tableView: UITableView, sections: [String], cellProvider: @escaping UITableViewDiffableDataSource<String, FLCPickerItem>.CellProvider) {
        super.init(tableView: tableView, cellProvider: cellProvider)
        self.sections = sections
    }
    
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
