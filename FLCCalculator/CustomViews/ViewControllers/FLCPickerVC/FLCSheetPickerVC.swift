import UIKit

class FLCSheetPickerVC: FLCPickerVC {
    
    private let titleLabel = FLCSubtitleLabel(color: .label, textAlignment: .left, textStyle: .callout)
    private let tableView = UITableView()
    private var pickerItems = [FLCPickerItem]()
    
    private let padding: CGFloat = 20
        
    init(items pickerItems: [FLCPickerItem], triggerButton: FLCListPickerButton, title: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.pickerItems = pickerItems
        self.triggerButton = triggerButton
        self.title = triggerButton.smallLabelView.smallLabel.text ?? ""
        self.titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitleLabel()
        configureTableView()
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = false
        tableView.hideFirstSeparator()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding / 2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.register(SheetPickerCell.self, forCellReuseIdentifier: SheetPickerCell.reuseID)
    }
}

extension FLCSheetPickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectItem(pickedItem: pickerItems[indexPath.row], triggerButton: triggerButton)
        triggerButton.smallLabelView.moveUpSmallLabel()
        closeViewController()
    }
}

extension FLCSheetPickerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SheetPickerCell.reuseID, for: indexPath) as! SheetPickerCell
        cell.set(pickerItem: pickerItems[indexPath.row], buttonTitle: triggerButton.showingTitle)
        if indexPath.row == pickerItems.count - 1 { cell.separatorInset.left = UIScreen.main.bounds.width }
        
        return cell
    }
}
