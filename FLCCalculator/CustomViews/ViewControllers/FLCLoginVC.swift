import UIKit

class FLCLoginVC: UIViewController {
    
    private let scrollView = UIScrollView()
    let containerView = UIView()
    let enterUserCredentialsView = UIView()
    let loginConfirmationVCContainer = UIView()
    let loginConfirmationVC = FLCLoginConfirmationVC()
    
    var leadingConstraint: NSLayoutConstraint!
    let padding: CGFloat = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureScrollView()
        configureContainerView()
        configureEnterUserCredentialsView()
        configureLoginConfirmationViewContainer()
        configureLoginConfirmationVC()
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
        containerView.addSubviews(enterUserCredentialsView, loginConfirmationVCContainer)
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
    
    private func configureLoginConfirmationViewContainer() {
        loginConfirmationVCContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginConfirmationVCContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
            loginConfirmationVCContainer.leadingAnchor.constraint(equalTo: enterUserCredentialsView.trailingAnchor),
            loginConfirmationVCContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            loginConfirmationVCContainer.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
    }
    
    private func configureLoginConfirmationVC() { add(childVC: loginConfirmationVC, to: loginConfirmationVCContainer) }
    @objc func closeButtonPressed() { self.dismiss(animated: true) }
}

extension FLCLoginVC: UIScrollViewDelegate {}
