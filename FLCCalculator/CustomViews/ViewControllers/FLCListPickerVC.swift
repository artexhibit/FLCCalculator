import UIKit

enum ListContentType { case cargo, address }

class FLCListPickerVC: UIViewController {
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<String, String>!
    private var titlesToShow = [String]()
    private var subtitlesToShow = [String]()
    
    init(title: String, type: ListContentType) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.set(according: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchController()
        configureTableView()
        configureDataSource()
        updateDataSource()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.register(ListPickerCell.self, forCellReuseIdentifier: ListPickerCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListPickerCell.reuseID, for: indexPath) as! ListPickerCell
            cell.set(title: self.titlesToShow[indexPath.row], subtitle: self.subtitlesToShow[indexPath.row])
            return cell
        })
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(["Main"])
        snapshot.appendItems(titlesToShow, toSection: "Main")
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func set(according type: ListContentType) {
        switch type {
        case .cargo:
            CalculationData.categories.sort { $0.title < $1.title }
            titlesToShow = CalculationData.categories.map { $0.title }
            subtitlesToShow = CalculationData.categories.map { $0.subtitle }
        case .address:
            break
        }
    }
}

extension FLCListPickerVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
