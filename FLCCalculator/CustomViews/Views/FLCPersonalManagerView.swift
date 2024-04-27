import UIKit

class FLCPersonalManagerView: UIView {
    
    private let backgroundView = FLCTintedView(color: .secondarySystemBackground, alpha: 1)
    private let managerPhotoView = UIImageView()
    private let managerNameLabel = FLCTitleLabel(color: .label, textAlignment: .left, size: 28)
    private let managerPositionLabel = FLCSubtitleLabel(color: .lightGray, textAlignment: .left)
    private var salesManager: FLCSalesManager = .igorVolkov
    
    private var padding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureBackgroundView()
        configureManagerPhotoView()
        configureManagerNameLabel()
        configureManagerPositionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubviews(backgroundView)
    }
    
    private func configureBackgroundView() {
        backgroundView.pinToEdges(of: self)
        backgroundView.addSubviews(managerPhotoView, managerNameLabel, managerPositionLabel)
    }
    
    private func configureManagerPhotoView() {
        managerPhotoView.translatesAutoresizingMaskIntoConstraints = false
        managerPhotoView.layer.cornerRadius = managerPhotoView.frame.height / 2
        managerPhotoView.contentMode = .scaleAspectFit
        managerPhotoView.image = UIImage(resource: .personPlaceholder)
        
        NSLayoutConstraint.activate([
            managerPhotoView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: padding * 2),
            managerPhotoView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: padding * 2),
            managerPhotoView.widthAnchor.constraint(equalToConstant: 68),
            managerPhotoView.heightAnchor.constraint(equalTo: managerPhotoView.widthAnchor)
        ])
    }
    
    private func configureManagerNameLabel() {
        managerNameLabel.text = salesManager.rawValue
        
        NSLayoutConstraint.activate([
            managerNameLabel.topAnchor.constraint(equalTo: managerPhotoView.topAnchor, constant: -2),
            managerNameLabel.leadingAnchor.constraint(equalTo: managerPhotoView.trailingAnchor, constant: padding * 1.5),
            managerNameLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -padding),
            managerNameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureManagerPositionLabel() {
        managerPositionLabel.text = "Менеджер по привлечению клиентов"
        
        NSLayoutConstraint.activate([
            managerPositionLabel.topAnchor.constraint(equalTo: managerNameLabel.bottomAnchor),
            managerPositionLabel.leadingAnchor.constraint(equalTo: managerPhotoView.trailingAnchor, constant: padding * 1.5),
            managerPositionLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -padding)
        ])
    }
    
    func setPersonalManagerInfo(manager: FLCSalesManager) {
        self.salesManager = manager
    }
}
