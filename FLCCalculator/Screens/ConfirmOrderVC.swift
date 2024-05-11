import UIKit
import MessageUI

class ConfirmOrderVC: UIViewController {
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let welcomeLabelOne = FLCTitleLabel(color: .flcGray, textAlignment: .center, size: 37, weight: .heavy)
    private let welcomeLabelTwo = FLCTitleLabel(color: .flcGray, textAlignment: .center, size: 37, weight: .heavy)
    private let welcomeLabelThree = FLCTitleLabel(color: .flcOrange, textAlignment: .center, size: 37, weight: .heavy)
    private let flcLogoImageView = FLCImageView(image: UIImage(resource: .flcIcon))
    private let companyLogoNameContainerView = UIView()
    private let salesManagerTitle = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 21)
    private let managerView = FLCPersonalManagerView()
    private let tintedMessageView = FLCTintedView(color: .lightGray, withText: true)
    private let closeButton = FLCButton(color: .flcOrange, title: "Закрыть", subtitle: "расчёты будут сохранены")
    
    private let padding: CGFloat = 10
    private let containerHeight: CGFloat = DeviceTypes.isiPhoneSE3rdGen ? 665 : 600
    private var itemsToAnimate = [(UIView, NSLayoutConstraint?)]()
    private var manager: FLCManager = CalculationInfo.defaultManager
    private var confirmedCalculation: Calculation?
    
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
        configureSalesManagerTitle()
        configureManagerView()
        configureTintedMessageView()
        configureCloseButton()
        
        getPersonalManagerInfo()
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
        itemsToAnimate.append((salesManagerTitle, nil))
        itemsToAnimate.append((managerView, nil))
        itemsToAnimate.append((tintedMessageView, nil))
        itemsToAnimate.append((closeButton, nil))
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        
        scrollView.addSubview(containerView)
        scrollView.pinToEdges(of: view)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func configureContainerView() {
        containerView.addSubviews(welcomeLabelOne, welcomeLabelTwo, companyLogoNameContainerView, salesManagerTitle, managerView, tintedMessageView, closeButton)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
    }
    
    private func configureWelcomeLabelOne() {
        welcomeLabelOne.text = "Добро пожаловать"
        welcomeLabelOne.hide(withAnimationDuration: 0)
        
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
        welcomeLabelTwo.hide(withAnimationDuration: 0)
        
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
        companyLogoNameContainerView.hide(withAnimationDuration: 0)
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
        NSLayoutConstraint.activate([
            flcLogoImageView.centerYAnchor.constraint(equalTo: welcomeLabelThree.centerYAnchor),
            flcLogoImageView.trailingAnchor.constraint(equalTo: welcomeLabelThree.leadingAnchor),
            flcLogoImageView.widthAnchor.constraint(equalToConstant: 37),
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
    
    private func configureSalesManagerTitle() {
        salesManagerTitle.text = "Ваш персональный менеджер"
        salesManagerTitle.hide(withAnimationDuration: 0)
        
        NSLayoutConstraint.activate([
            salesManagerTitle.topAnchor.constraint(equalTo: companyLogoNameContainerView.bottomAnchor, constant: 65),
            salesManagerTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 2.5),
            salesManagerTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -padding * 2.5)
        ])
    }
    
    private func configureManagerView() {
        managerView.hide(withAnimationDuration: 0)
        managerView.getConfirmedCalculationData(calculation: confirmedCalculation)
        
        NSLayoutConstraint.activate([
            managerView.topAnchor.constraint(equalTo: salesManagerTitle.bottomAnchor, constant: padding),
            managerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 2.5),
            managerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -padding * 2.5)
        ])
    }
    
    private func configureTintedMessageView() {
        tintedMessageView.hide(withAnimationDuration: 0)
        tintedMessageView.setTextLabel(text: "Вы всегда можете посмотреть контакты вашего менеджера на вкладке Полезное".makeAttributed(icon: Icons.infoSign, tint: .flcGray, size: (0, -2.5, 17, 16), placeIcon: .beforeText), textAlignment: .left, fontWeight: .regular, fontSize: 15, delegate: self)
        
        NSLayoutConstraint.activate([
            tintedMessageView.topAnchor.constraint(equalTo: managerView.bottomAnchor, constant: padding * 2),
            tintedMessageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 2.5),
            tintedMessageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -padding * 2.5)
        ])
    }
    
    private func configureCloseButton() {
        closeButton.delegate = self
        closeButton.hide(withAnimationDuration: 0)
        
        let widthConstraint = closeButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9)
        let heightConstraint = closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor, multiplier: 1/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: tintedMessageView.bottomAnchor, constant: padding * 4),
            closeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            widthConstraint, heightConstraint,
            
            closeButton.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            closeButton.widthAnchor.constraint(lessThanOrEqualToConstant: 450)
        ])
    }
    
    private func animateWelcomeLabels() {
        for (index, (item, constraint)) in itemsToAnimate.enumerated() {
            let delay = 1 + (0.5 * Double(index))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                UIView.animate(withDuration: 0.7) {
                    constraint?.constant = 0
                    item.show()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    private func getPersonalManagerInfo() {
        managerView.addShimmerAnimationToAllItems()
        
        Task {
            do {
                if let storedManager: FLCManager = PersistenceManager.retrieveItemFromUserDefaults() {
                    let managers: [FLCManager] = try await FirebaseManager.getDataFromFirebase() ?? [CalculationInfo.defaultManager]
                    var manager = managers.first(where: { $0.id == storedManager.id }) ?? CalculationInfo.defaultManager
                    
                    if manager.dataDate != storedManager.dataDate {
                        let avatar = await FirebaseManager.downloadAvatar(for: manager)
                        manager.avatar = avatar ?? UIImage(resource: .personPlaceholder)
                        let _ = PersistenceManager.updateItemInUserDefaults(item: manager)
                        self.manager = manager
                    } else {
                        self.manager = storedManager
                    }
                } else {
                    let managers: [FLCManager] = try await FirebaseManager.getDataFromFirebase() ?? [CalculationInfo.defaultManager]
                    var manager = managers.randomElement() ?? CalculationInfo.defaultManager
                    let avatar = await FirebaseManager.downloadAvatar(for: manager)
                    manager.avatar = avatar ?? UIImage(resource: .personPlaceholder)
                    let _ = PersistenceManager.saveItemToUserDefaults(item: manager)
                    self.manager = manager
                }
            }
            managerView.setPersonalManagerInfo(manager: self.manager)
        }
    }
    
    @objc func closeViewController() { navigationController?.popViewController(animated: true) }
    func getConfirmedCalculationData(calculation: Calculation?) { self.confirmedCalculation = calculation }
}

extension ConfirmOrderVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        switch button {
        case closeButton: closeViewController()
        default: break
        }
    }
}

extension ConfirmOrderVC: FLCMailComposeDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        handleMailComposeResult(result)
    }
}

extension ConfirmOrderVC: UIScrollViewDelegate {}
