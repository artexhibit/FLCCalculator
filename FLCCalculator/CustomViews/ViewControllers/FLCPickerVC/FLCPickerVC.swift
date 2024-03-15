import UIKit

protocol FLCPickerDelegate: AnyObject {
    func didSelectItem(pickedItem: FLCPickerItem, triggerButton: FLCListPickerButton)
    func didClosePickerView(parentButton: FLCListPickerButton)
}

class FLCPickerVC: UIViewController {
    
    var triggerButton = FLCListPickerButton()
    
    weak var delegate: FLCPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didClosePickerView(parentButton: triggerButton)
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.createCloseButton(in: self, with: #selector(closeViewController))
    }
    
    @objc func closeViewController() { dismiss(animated: true) }
}
