import UIKit

class ConfirmOrderVC: UIViewController {
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let welcomeLabelOne = FLCTitleLabel(color: .accent, textAlignment: .center, size: 37, weight: .heavy)
    private let welcomeLabelTwo = FLCTitleLabel(color: .accent, textAlignment: .center, size: 37, weight: .heavy)
    private let welcomeLabelThree = FLCTitleLabel(color: .accent, textAlignment: .center, size: 37, weight: .heavy)
    private let flcLogoImageView = UIImageView()
    private let companyLogoNameContainerView = UIView()
    
    private let padding: CGFloat = 10
    private var itemsToAnimate = [(UIView, NSLayoutConstraint)]()
    
    private var welcomeLabelOneTopContraint: NSLayoutConstraint!
    private var welcomeLabelTwoTopContraint: NSLayoutConstraint!
    private var companyLogoNameContainerTopContraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        showConfetti()
        
        cofigureView()
        configureScrollView()
        configureContainerView()
        configureWelcomeLabelOne()
        configureWelcomeLabelTwo()
        configureCompanyLogoNameContainerView()
        configureFlcLogoImageView()
        configureWelcomeLabelThree()
        
        configureItemsToAnimate()
        animateWelcomeLabels()
    }
    
    private func cofigureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.createCloseButton(in: self, with: #selector(closeViewController))
    }
    
    private func configureItemsToAnimate() {
        itemsToAnimate.append((welcomeLabelOne, welcomeLabelOneTopContraint))
        itemsToAnimate.append((welcomeLabelTwo, welcomeLabelTwoTopContraint))
        itemsToAnimate.append((companyLogoNameContainerView, companyLogoNameContainerTopContraint))
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        
        scrollView.addSubview(containerView)
        scrollView.pinToEdges(of: view)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func configureContainerView() {
        containerView.addSubviews(welcomeLabelOne, welcomeLabelTwo, companyLogoNameContainerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    private func configureWelcomeLabelOne() {
        welcomeLabelOne.text = "Добро пожаловать"
        welcomeLabelOne.alpha = 0
        
        welcomeLabelOneTopContraint = welcomeLabelOne.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding * 7)
        
        NSLayoutConstraint.activate([
            welcomeLabelOneTopContraint,
            welcomeLabelOne.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            welcomeLabelOne.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            welcomeLabelOne.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureWelcomeLabelTwo() {
        welcomeLabelTwo.text = "на борт"
        welcomeLabelTwo.alpha = 0
        
        welcomeLabelTwoTopContraint = welcomeLabelTwo.topAnchor.constraint(equalTo: welcomeLabelOne.bottomAnchor, constant: padding * 5)
        
        NSLayoutConstraint.activate([
            welcomeLabelTwoTopContraint,
            welcomeLabelTwo.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            welcomeLabelTwo.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            welcomeLabelTwo.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureCompanyLogoNameContainerView() {
        companyLogoNameContainerView.translatesAutoresizingMaskIntoConstraints = false
        companyLogoNameContainerView.alpha = 0
        companyLogoNameContainerView.addSubviews(flcLogoImageView, welcomeLabelThree)
        
        companyLogoNameContainerTopContraint = companyLogoNameContainerView.topAnchor.constraint(equalTo: welcomeLabelTwo.bottomAnchor)
        
        NSLayoutConstraint.activate([
            companyLogoNameContainerTopContraint,
            companyLogoNameContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            companyLogoNameContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -padding),
            companyLogoNameContainerView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func configureFlcLogoImageView() {
        flcLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        flcLogoImageView.image = UIImage(resource: .flcIcon)
        flcLogoImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            flcLogoImageView.topAnchor.constraint(equalTo: companyLogoNameContainerView.topAnchor),
            flcLogoImageView.trailingAnchor.constraint(equalTo: welcomeLabelThree.leadingAnchor),
            flcLogoImageView.widthAnchor.constraint(equalToConstant: 40),
            flcLogoImageView.heightAnchor.constraint(equalTo: flcLogoImageView.widthAnchor)
        ])
    }
    
    private func configureWelcomeLabelThree() {
        welcomeLabelThree.text = "Free Lines"
        
        NSLayoutConstraint.activate([
            welcomeLabelThree.topAnchor.constraint(equalTo: companyLogoNameContainerView.topAnchor),
            welcomeLabelThree.centerXAnchor.constraint(equalTo: companyLogoNameContainerView.centerXAnchor, constant: (flcLogoImageView.frame.width + padding * 2)),
            welcomeLabelThree.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func animateWelcomeLabels() {
        for (index, (item, constraint)) in itemsToAnimate.enumerated() {
            let delay = 1 + (0.5 * Double(index))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                UIView.animate(withDuration: 0.7) {
                    constraint.constant = 1
                    item.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func closeViewController() { navigationController?.popViewController(animated: true) }
}

extension ConfirmOrderVC: UIScrollViewDelegate {}
