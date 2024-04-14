import UIKit

final class FLCOptionsCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "FLCOptionsCollectionViewCell"
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let optionTitle = FLCTitleLabel(color: .accent, textAlignment: .center, size: 19)
    
    private let padding: CGFloat = 10
    
    override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = isSelected ? .flcNumberTextFieldBackground : .clear
            containerView.layer.borderColor = isSelected ? UIColor.accent.cgColor : UIColor.accent.withAlphaComponent(0.4).cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with option: FLCLogisticsOption) {
        self.imageView.image = option.image
        self.optionTitle.text = option.title
    }
    
    private func configure() {
        contentView.addSubviews(containerView)
        configureContainerView()
        configureImageView()
        configureTitle()
    }
    
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubviews(imageView, optionTitle)
        containerView.pinToEdges(of: contentView, withPadding: 5, paddingType: .vertical)
        
        containerView.layer.cornerRadius = 13
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.accent.withAlphaComponent(0.4).cgColor
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .accent
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 1.3),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func configureTitle() {
        optionTitle.textColor = .accent
        
        NSLayoutConstraint.activate([
            optionTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: padding / 1.5),
            optionTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding * 1.3),
            optionTitle.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
