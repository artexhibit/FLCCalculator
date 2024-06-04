import UIKit
import MessageUI

class UsefulInfoVC: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var sections: [FLCUsefulInfoSections] = FLCUsefulInfoSections.allCases
    private var usefulInfoDocuments = CalculationInfo.defaultUsefulInfoDocuments
    private let usefulInfoContents = UsefulInfoHelper.usefulInfoContents
    private var canRemoveShimmerInDocumentsCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureSections()
        Task { await self.updateDocumentsSectionUI(with: UsefulInfoHelper.getUsefulInfoDocuments()) }
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
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.bounds
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UsefulInfoManagerCell.self, forCellReuseIdentifier: UsefulInfoManagerCell.reuseID)
        tableView.register(UsefulInfoContentCell.self, forCellReuseIdentifier: UsefulInfoContentCell.reuseID)
        tableView.register(UsefulInfoDocumentsCell.self, forCellReuseIdentifier: UsefulInfoDocumentsCell.reuseID)
        tableView.register(FLCTableViewHeader.self, forHeaderFooterViewReuseIdentifier: FLCTableViewHeader.reuseID)
    }
    
    private func configureSections() {
        let manager: FLCManager? = CoreDataManager.retrieveItemFromCoreData()
        if manager == nil { sections = sections.filter({ $0 != .managerContacts }) }
    }
    
    private func updateDocumentsSectionUI(with docs: [Document]) {
        DispatchQueue.main.async {
            self.usefulInfoDocuments = docs
            self.canRemoveShimmerInDocumentsCell = true
            self.tableView.reloadSections([self.tableView.numberOfSections - 1], with: .none)
        }
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
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FLCTableViewHeader.reuseID) as? FLCTableViewHeader
        headerView?.set(title: sections[section].rawValue)
        return headerView
    }
}

extension UsefulInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .managerContacts, .usefulInfo: UITableView.automaticDimension
        case .documents: 180
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int { return sections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .managerContacts, .documents: 1
        case .usefulInfo: usefulInfoContents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
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
            cell.setDocuments(documents: usefulInfoDocuments, canRemoveShimmer: canRemoveShimmerInDocumentsCell)
            return cell
        }
    }
}

extension UsefulInfoVC: FLCMailComposeDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        handleMailComposeResult(result)
    }
}

extension UsefulInfoVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
