import UIKit
import MessageUI

class UsefulInfoVC: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var sections: [FLCUsefulInfoSections] = [.managerContacts, .usefulInfo, .documents]
    private let usefulInfoContents: [UsefulInfoContent] = [
        UsefulInfoContent(type: .bonusSystem, image: Icons.rubleSign, title: "Бонусный счет", urlString: nil),
        UsefulInfoContent(type: .sanctionsCheck, image: Icons.circle, title: "Санкции", urlString: "https://cargointegrator.com"),
        UsefulInfoContent(type: .fashionSupplierBase, image: Icons.person, title: "База поставщиков индустрии моды", urlString: "https://manufactures.free-lines.ru"),
    ]
    private var usefulInfoDocuments: [FLCDocument] = [
        FLCDocument(title: "Шаблон договора", fileName: ""),
        FLCDocument(title: "Презентация FLC", fileName: ""),
        FLCDocument(title: "Презентация по Китаю", fileName: ""),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureSections()
        configureTableView()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Полезное"
        setNavBarColor(color: UIColor.flcOrange)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UsefulInfoManagerCell.self, forCellReuseIdentifier: UsefulInfoManagerCell.reuseID)
        tableView.register(UsefulInfoContentCell.self, forCellReuseIdentifier: UsefulInfoContentCell.reuseID)
        tableView.register(UsefulInfoDocumentsCell.self, forCellReuseIdentifier: UsefulInfoDocumentsCell.reuseID)
        tableView.register(UsefulInfoTableViewHeader.self, forHeaderFooterViewReuseIdentifier: UsefulInfoTableViewHeader.reuseID)
    }
    
    private func configureSections() {
        let manager: FLCManager? = PersistenceManager.retrieveItemFromUserDefaults()
        if manager == nil { sections = sections.filter({ $0 != .managerContacts }) }
    }
}

extension UsefulInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pickedContent = usefulInfoContents[indexPath.row]
        
        switch pickedContent.type {
        case .bonusSystem: 
            let bonusSystemVC = BonusSystemVC()
            let navController = UINavigationController(rootViewController: bonusSystemVC)
            navigationController?.present(navController, animated: true)
        case .sanctionsCheck, .fashionSupplierBase: presentSafariVC(with: pickedContent.urlString)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: UsefulInfoTableViewHeader.reuseID) as! UsefulInfoTableViewHeader
        headerView.set(title: sections[section].rawValue)
        return headerView
    }
}

extension UsefulInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        switch section {
        case .managerContacts, .usefulInfo: return UITableView.automaticDimension
        case .documents: return 180
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int { return sections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .managerContacts, .documents: return 1
        case .usefulInfo: return usefulInfoContents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .managerContacts:
            let cell = tableView.dequeueReusableCell(withIdentifier: UsefulInfoManagerCell.reuseID, for: indexPath) as! UsefulInfoManagerCell
            cell.set()
            return cell
        case .usefulInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: UsefulInfoContentCell.reuseID, for: indexPath) as! UsefulInfoContentCell
            cell.set(with: usefulInfoContents[indexPath.row])
            return cell
        case .documents:
            let cell = tableView.dequeueReusableCell(withIdentifier: UsefulInfoDocumentsCell.reuseID, for: indexPath) as! UsefulInfoDocumentsCell
            cell.setDocuments(documents: usefulInfoDocuments)
            return cell
        }
    }
}

extension UsefulInfoVC: FLCMailComposeDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        handleMailComposeResult(result)
    }
}
