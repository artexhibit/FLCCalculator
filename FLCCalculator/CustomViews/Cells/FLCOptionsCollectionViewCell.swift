import UIKit

final class FLCOptionsCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "FLCOptionsCollectionViewCell"
    
    private let containerView = UIView()
    private let imageView = FLCImageView(tint: .flcOrange)
    private let optionTitle = FLCTitleLabel(color: .flcOrange, textAlignment: .center, size: 18)
    
    private let padding: CGFloat = 10
    
    override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = isSelected ? .flcNumberTextFieldBackground : .clear
            containerView.layer.borderColor = isSelected ? UIColor.flcOrange.cgColor : UIColor.flcOrange.withAlphaComponent(0.4).cgColor
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
        containerView.pinToEdges(of: contentView, withPadding: 4.5, paddingType: .vertical)
        
        containerView.layer.cornerRadius = 13
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.flcOrange.withAlphaComponent(0.4).cgColor
    }
    
    private func configureImageView() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding / 1.1),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 29),
            imageView.heightAnchor.constraint(equalToConstant: 31)
        ])
    }
    
    private func configureTitle() {
        NSLayoutConstraint.activate([
            optionTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: padding / 1.5),
            optionTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding / 1.1),
            optionTitle.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
