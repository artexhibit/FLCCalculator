import UIKit

class FLCListPickerVC: FLCPickerVC {
    
    private let searchController = UISearchController()
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<String, FLCPickerItem>!
    private var items = [FLCPickerItem]()
    private var filteredItems = [FLCPickerItem]()
    private var sections = [String]()
    private var sortType: FLCListPickerSortType = .byTitle
        
    init(from button: FLCListPickerButton, items: [FLCPickerItem], sort sortType: FLCListPickerSortType) {
        super.init(nibName: nil, bundle: nil)
        self.triggerButton = button
        self.title = triggerButton.smallLabelView.smallLabel.text ?? ""
        self.items = items
        self.sortType = sortType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureTableView()
        configureInitialData()
        configureDataSource()
        updateDataSource(with: items)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func configureSearchController() {
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func configureSearchController2() {
        searchController.isActive = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.register(ListPickerCell.self, forCellReuseIdentifier: ListPickerCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = FLCListPickerVCDataSource(tableView: tableView, sections: sections, cellProvider: { (tableView, indexPath, listItem) in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListPickerCell.reuseID, for: indexPath) as! ListPickerCell            
            cell.set(with: listItem)
            return cell
        })
    }
    
    private func updateDataSource(with itemsToShow: [FLCPickerItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, FLCPickerItem>()
        snapshot.appendSections(sections)
        var items = [FLCPickerItem]()
        
        for section in sections {
            
            switch sortType {
            case .byTitle:
                items = itemsToShow.filter { $0.title.first?.description == section }
            case .bySubtitle:
                items = itemsToShow
                    .filter { $0.subtitle.first?.description == section }
                    .sorted { $0.subtitle < $1.subtitle }
            }
            snapshot.appendItems(items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureInitialData() {
        items.sort { $0.title < $1.title }
        configureSections(with: items)
    }
    
    private func configureSections(with items: [FLCPickerItem]) {
        
        switch sortType {
        case .byTitle:
            sections = Array(Set(items.map { $0.title.first?.description ?? "" })).sorted()
        case .bySubtitle:
            sections = Array(Set(items.map { $0.subtitle.first?.description ?? "" })).sorted()
        }
    }
}

extension FLCListPickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        searchController.dismiss(animated: true)
        delegate?.didSelectItem(pickedItem: dataSource.itemIdentifier(for: indexPath)?.title ?? "", triggerButton: triggerButton)
        triggerButton.smallLabelView.moveUpSmallLabel()
        closeViewController()
    }
}

extension FLCListPickerVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredItems.removeAll()
            configureSections(with: items)
            updateDataSource(with: items)
            return
        }
        filteredItems = items.filter { $0.title.lowercased().contains(filter.lowercased()) || $0.subtitle.lowercased().contains(filter.lowercased()) }
        configureSections(with: filteredItems)
        updateDataSource(with: filteredItems)
    }
}
