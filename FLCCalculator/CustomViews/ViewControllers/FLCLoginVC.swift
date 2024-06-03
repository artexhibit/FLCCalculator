import UIKit

class FLCLoginVC: UIViewController {
    
    private let scrollView = UIScrollView()
    let containerView = UIView()
    let enterUserCredentialsView = UIView()
    let loginConfirmationView = LoginConfirmationView()
    
    var leadingConstraint: NSLayoutConstraint!
    let padding: CGFloat = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureScrollView()
        configureContainerView()
        configureEnterUserCredentialsView()
        configureLoginConfirmationView()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        setNavBarColor(color: UIColor.flcOrange)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.createCloseButton(in: self, with: #selector(closeButtonPressed))
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        
        scrollView.addSubview(containerView)
        scrollView.pinToEdges(of: view)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubviews(enterUserCredentialsView, loginConfirmationView)
        containerView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 650)
        ])
    }
    
    private func configureEnterUserCredentialsView() {
        enterUserCredentialsView.translatesAutoresizingMaskIntoConstraints = false
        leadingConstraint = enterUserCredentialsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([
            enterUserCredentialsView.topAnchor.constraint(equalTo: containerView.topAnchor),
            leadingConstraint,
            enterUserCredentialsView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            enterUserCredentialsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func configureLoginConfirmationView() {
        NSLayoutConstraint.activate([
            loginConfirmationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loginConfirmationView.leadingAnchor.constraint(equalTo: enterUserCredentialsView.trailingAnchor),
            loginConfirmationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            loginConfirmationView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
    }
    
    @objc func closeButtonPressed() { self.dismiss(animated: true) }
}

extension FLCLoginVC: UIScrollViewDelegate {}
