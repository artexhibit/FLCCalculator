import UIKit

class ConfirmOrderVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cofigure()
    }
    
    private func cofigure() {
        view.backgroundColor = .blue
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.createCloseButton(in: self, with: #selector(closeViewController))
    }
    @objc func closeViewController() {
        navigationController?.popViewController(animated: true)
    }
}
