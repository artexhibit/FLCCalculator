import UIKit

class FacilityDetailsVC: UIViewController {
    
    private let emptyStateView = FLCEmptyStateView(withButton: false)
    
    private var facility: FLCFacility?
    
    init(facility: FLCFacility) {
        super.init(nibName: nil, bundle: nil)
        self.facility = facility
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        showEmptyStateView(withTitle: "Раздел находится в разработке", andSubtitle: "И появится в следующем обновлении")
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        setNavBarColor(color: UIColor.flcOrange)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
        navigationItem.title = facility?.name ?? ""
    }
    
    private func showEmptyStateView(withTitle: String, andSubtitle: String) {
        if !emptyStateView.isDescendant(of: view) {
            emptyStateView.frame = view.bounds
            emptyStateView.setup(titleText: withTitle, subtitleText: andSubtitle)
            emptyStateView.setDelegate(for: self)
            view.addSubview(emptyStateView)
        }
    }
    @objc func closeButtonPressed() { dismiss(animated: true) }
}
