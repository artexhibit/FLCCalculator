import UIKit

class FLCListPickerVC: FLCPickerVC {
    
    private let searchController = UISearchController()
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<String, String>!
    private var titlesToShow = [String]()
    private var subtitlesToShow = [String]()
    private var filteredTitles = [String]()
    private var sections = [String]()
        
    init(from button: FLCListPickerButton, type: FLCListPickerContentType) {
        super.init(nibName: nil, bundle: nil)
        self.triggerButton = button
        self.title = triggerButton.smallLabelView.smallLabel.text ?? ""
        self.set(according: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureTableView()
        configureDataSource()
        updateDataSource(with: titlesToShow)
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
        dataSource = FLCListPickerVCDataSource(tableView: tableView, sections: sections, cellProvider: { (tableView, indexPath, itemIdentifier) in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListPickerCell.reuseID, for: indexPath) as! ListPickerCell
            guard let index = self.titlesToShow.firstIndex(of: itemIdentifier) else { return cell }
            
            cell.set(title: itemIdentifier, subtitle: self.subtitlesToShow[index])
            return cell
        })
    }
    
    private func updateDataSource(with titles: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(sections)
        
        for section in sections {
            let items = titles.filter { $0.first?.description == section }
            snapshot.appendItems(items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func set(according type: FLCListPickerContentType) {

        switch type {
        case .withSubtitle(let data):
            configureDataSourceWithSubtitle(data: data)
        case .onlyTitle(let data):
            configureDataSourceWithTitle(data: data)
        }
    }
    
    private func configureDataSourceWithSubtitle(data: [(title: String, subtitle: String)]) {
        var sortedData = data
        sortedData.sort { $0.title < $1.title }
        titlesToShow = sortedData.map { $0.title }
        subtitlesToShow = sortedData.map { $0.subtitle }
        sections = Array(Set(titlesToShow.map { $0.first?.description ?? "" })).sorted()
    }
    
    private func configureDataSourceWithTitle(data: [String]) {
        var sortedData = data
        sortedData.sort { $0 < $1 }
        titlesToShow = sortedData
        subtitlesToShow = Array(repeating: "", count: titlesToShow.count)
        sections = Array(Set(titlesToShow.map { $0.first?.description ?? "" })).sorted()
    }
}

extension FLCListPickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        searchController.dismiss(animated: true)
        delegate?.didSelectItem(pickedItem: dataSource.itemIdentifier(for: indexPath) ?? "", triggerButton: triggerButton)
        triggerButton.smallLabelView.moveUpSmallLabel()
        closeViewController()
    }
}

extension FLCListPickerVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredTitles.removeAll()
            sections = Array(Set(titlesToShow.map { $0.first?.description ?? "" })).sorted()
            updateDataSource(with: titlesToShow)
            return
        }
        filteredTitles = filterTitlesAndSubtitles(basedOn: filter).map { $0.0 }
        sections = Array(Set(filteredTitles.map { $0.first?.description ?? "" })).sorted()
        updateDataSource(with: filteredTitles)
    }
    
    func filterTitlesAndSubtitles(basedOn filter: String) -> [(String, String)] {
        let titlesAndSubtitles = zip(titlesToShow, subtitlesToShow).filter { titleAndSubtitle in
            let (title, subtitle) = titleAndSubtitle
            
            return title.lowercased().contains(filter.lowercased()) || subtitle.lowercased().contains(filter.lowercased())
        }
        return titlesAndSubtitles
    }
}
