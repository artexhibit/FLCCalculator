import UIKit

class UsefulInfoManagerCell: UITableViewCell {
    
    static let reuseID = "UsefulInfoManagerCell"
    
    private let managerView = FLCPersonalManagerView(backgroundColor: .flcManagerViewBackground)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureManagerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set() {
        let manager: FLCManager = CoreDataManager.retrieveItemFromCoreData() ?? CalculationInfo.defaultManager
        managerView.setPersonalManagerInfo(manager: manager)
    }
    
    private func configure() {
        contentView.addSubview(managerView)
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func configureManagerView() {
        managerView.pinToEdges(of: contentView)
    }
}
