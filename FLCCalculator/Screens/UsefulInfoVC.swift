import UIKit
import MessageUI

class UsefulInfoVC: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var sections = [FLCUsefulInfoSections]()
    
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
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UsefulInfoManagerCell.self, forCellReuseIdentifier: UsefulInfoManagerCell.reuseID)
    }
    
    private func configureSections() {
        let manager: FLCManager? = PersistenceManager.retrieveItemFromUserDefaults()
        
        if manager != nil {
            sections = [.managerContacts, .usefulInfo]
        } else {
            sections = [.usefulInfo]
        }
    }
}

extension UsefulInfoVC: UITableViewDelegate {
}

extension UsefulInfoVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .managerContacts:
           return 1
        case .usefulInfo:
           return 5
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
            return UITableViewCell()
        }
    }
}

extension UsefulInfoVC: FLCMailComposeDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        handleMailComposeResult(result)
    }
}
