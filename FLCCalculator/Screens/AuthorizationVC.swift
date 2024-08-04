import UIKit

class AuthorizationVC: UIViewController {
    
    private let flcLogoImageView = FLCImageView()
    private let authButtonsContainer = UIView()
    private let signInButton = FLCButton(color: .flcOrange, title: "Войти", subtitle: "для зарегистрированных пользователей")
    private let orButton = FLCSubtitleLabel(color: .label, textAlignment: .center, textStyle: .caption1)
    private let registrationButton = FLCButton(color: .flcGray, title: "Зарегистрироваться", subtitle: "создать новый аккаунт")
    
    private let padding: CGFloat = 10
    private var flcLogoYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureFLCLogoImageView()
        configureAuthButtonsContainer()
        configureSignInButton()
        configureOrButton()
        configureRegistrationButton()
        
        AuthorizationVCHelper.moveFLCLogoImageViewUp(yContraint: flcLogoYConstraint, vc: self, container: authButtonsContainer)
    }
    
    private func configureVC() {
        view.backgroundColor = .systemGray6
        view.addSubviews(flcLogoImageView, authButtonsContainer)
    }
    
    private func configureFLCLogoImageView() {
        flcLogoImageView.image = UIImage(resource: .fullLogo)
        
        flcLogoYConstraint = flcLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        NSLayoutConstraint.activate([
            flcLogoYConstraint,
            flcLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flcLogoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            flcLogoImageView.heightAnchor.constraint(equalTo: flcLogoImageView.widthAnchor, multiplier: 9/16)
        ])
    }
    
    private func configureAuthButtonsContainer() {
        authButtonsContainer.addSubviews(signInButton, orButton, registrationButton)
        authButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        authButtonsContainer.hide()
        
        NSLayoutConstraint.activate([
            authButtonsContainer.topAnchor.constraint(equalTo: flcLogoImageView.bottomAnchor, constant: padding * 7),
            authButtonsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authButtonsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            authButtonsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureSignInButton() {
        signInButton.delegate = self
        
        let widthConstraint = signInButton.widthAnchor.constraint(equalTo: authButtonsContainer.widthAnchor, multiplier: 0.85)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: authButtonsContainer.topAnchor),
            signInButton.centerXAnchor.constraint(equalTo: authButtonsContainer.centerXAnchor),
            signInButton.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            widthConstraint
        ])
    }
    
    private func configureOrButton() {
        orButton.text = "или"
        
        NSLayoutConstraint.activate([
            orButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: padding),
            orButton.leadingAnchor.constraint(equalTo: authButtonsContainer.leadingAnchor, constant: padding),
            orButton.trailingAnchor.constraint(equalTo: authButtonsContainer.trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureRegistrationButton() {
        registrationButton.delegate = self
        
        let widthConstraint = registrationButton.widthAnchor.constraint(equalTo: authButtonsContainer.widthAnchor, multiplier: 0.85)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            registrationButton.topAnchor.constraint(equalTo: orButton.bottomAnchor, constant: padding),
            registrationButton.centerXAnchor.constraint(equalTo: authButtonsContainer.centerXAnchor),
            registrationButton.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            widthConstraint
        ])
    }
}

extension AuthorizationVC: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        switch button {
        case signInButton: self.presentNewVC(ofType: LoginVC.self)
        case registrationButton: self.presentNewVC(ofType: RegistrationVC.self)
        default: break
        }
    }
}

extension AuthorizationVC: LoginVCDelegate {
    func didFoundPhoneNumberDoesntExists(number: String) { AuthorizationVCHelper.handleNumberNotExist(in: self) }
    func didSuccessWithLogin(for number: String, country: FLCUserCountry) { AuthorizationVCHelper.handleSuccessLogin(with: number, in: self, country: country) }
}

extension AuthorizationVC: RegistrationVCDelegate {
    func didFoundPhoneNumberExists(number: String) { AuthorizationVCHelper.handleNumberAlreadyExist(in: self) }
    func didSuccessWithRegistration(phoneNumber: String, email: String, country: FLCUserCountry) { AuthorizationVCHelper.handleSuccessRegistration(with: phoneNumber, email: email, country: country, in: self) }
}
