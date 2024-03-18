import UIKit

class FLCListPickerVC: FLCPickerVC {
    
    let searchController = UISearchController()
    let tableView = UITableView()
    var items = [FLCPickerItem]()
    var sortType: FLCListPickerSortType = .byTitle
    var searchType: FLCListPickerSearchType = .both
        
    init(from button: FLCListPickerButton, items: [FLCPickerItem], sort sortType: FLCListPickerSortType, searchType: FLCListPickerSearchType) {
        super.init(nibName: nil, bundle: nil)
        self.triggerButton = button
        self.title = triggerButton.smallLabelView.smallLabel.text ?? ""
        self.items = items
        self.sortType = sortType
        self.searchType = searchType
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
    
    private func configureInitialData() {
        items.sort { $0.title < $1.title }
        configureSections(with: items)
    }
}
