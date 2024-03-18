import UIKit

fileprivate var filteredItems = [FLCPickerItem]()

extension FLCListPickerVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredItems.removeAll()
            configureSections(with: items)
            updateDataSource(with: items)
            return
        }
        
        switch searchType {
            
        case .onlyByTitle:
            filteredItems = items.filter { $0.title.lowercased().contains(filter.lowercased()) }
            
        case .onlyBySubtitle:
            filteredItems = items.filter { $0.subtitle.lowercased().contains(filter.lowercased()) }
            
        case .both:
            filteredItems = items.filter { $0.title.lowercased().contains(filter.lowercased()) || $0.subtitle.lowercased().contains(filter.lowercased()) }
        }
        configureSections(with: filteredItems)
        updateDataSource(with: filteredItems)
    }
}
