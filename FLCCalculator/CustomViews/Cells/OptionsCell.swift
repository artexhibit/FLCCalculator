import UIKit

final class OptionsCell: UICollectionViewCell {
    
    static let reuseID = "OptionsCell"
    
    private let containerView = UIView()
    private let labelsContainerView = UIView()
    
    private let imageView = FLCImageView(tint: .flcGray)
    private let optionTitle = FLCTitleLabel(color: .flcGray, textAlignment: .left, size: 18)
    private let optionSubtitle = FLCSubtitleLabel(color: .flcGray, textAlignment: .left, textStyle: .caption1)
    
    private let padding: CGFloat = 10
    
    override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = isSelected ? .flcNumberTextFieldBackground : .clear
            containerView.layer.borderColor = isSelected ? UIColor.flcOrange.cgColor : UIColor.flcGray.cgColor
            imageView.tintColor = isSelected ? .flcOrange : .flcGray
            optionTitle.textColor = isSelected ? .flcOrange : .flcGray
            optionSubtitle.textColor = isSelected ? .flcOrange : .flcGray
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
        imageView.image = option.image
        optionTitle.text = option.title
        optionSubtitle.text = option.subtitle
    }
    
    private func configure() {
        contentView.addSubviews(containerView)
        configureContainerView()
        configureImageView()
        configureLabelsContainerView()
        configureTitle()
        configureSubtitle()
    }
    
    private func configureContainerView() {
        containerView.addSubviews(imageView, labelsContainerView)
        containerView.pinToEdges(of: contentView, withPadding: 4.5, paddingType: .vertical)
        
        containerView.layer.cornerRadius = 13
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.flcGray.cgColor
    }
    
    private func configureImageView() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding / 1.1),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    private func configureLabelsContainerView() {
        labelsContainerView.addSubviews(optionTitle, optionSubtitle)
        labelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelsContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding / 2),
            labelsContainerView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            labelsContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            labelsContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding / 1.8)
        ])
    }
    
    private func configureTitle() {
            NSLayoutConstraint.activate([
                optionTitle.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),
                optionTitle.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor, constant: padding),
                optionTitle.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            ])
        }
        
        private func configureSubtitle() {
            NSLayoutConstraint.activate([
                optionSubtitle.topAnchor.constraint(equalTo: optionTitle.bottomAnchor, constant: -padding / 4),
                optionSubtitle.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor, constant: padding),
                optionSubtitle.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor, constant: -padding / 1.1),
                optionSubtitle.bottomAnchor.constraint(equalTo: labelsContainerView.bottomAnchor)
            ])
        }
}
