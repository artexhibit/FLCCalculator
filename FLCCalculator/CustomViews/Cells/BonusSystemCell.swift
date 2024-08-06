import UIKit

class BonusSystemCell: UITableViewCell {
    
    static let reuseID = String(describing: BonusSystemCell.self)
    
    private let padding: CGFloat = 18
    private let textButtonURLString = BonusSystemVCStrings.textButtonURLLink
    
    private let titleLabel = FLCTitleLabel(color: .flcOrange, textAlignment: .left)
    private let mainTextLabel = FLCBodyLabel(color: .label, textAlignment: .left)
    private let detailsButton = FLCButton(color: .flcOrange, title: BonusSystemVCStrings.detailsButton)
    private let markTintedView = FLCTintedView(color: .flcOrange, withText: true)
    private var parentVC: UIViewController { get { self.findParentViewController() ?? UIViewController() } }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        
        configureTitleLabel()
        configureMainTextLabel()
        configureMarkTintedView()
        configureDetailsButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubviews(titleLabel, mainTextLabel, markTintedView, detailsButton)
        selectionStyle = .none
    }
    
    private func configureTitleLabel() {
        titleLabel.text = BonusSystemVCStrings.titleLabel
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureMainTextLabel() {
        mainTextLabel.text = BonusSystemVCStrings.mainTextLabel
        
        NSLayoutConstraint.activate([
            mainTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            mainTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mainTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureMarkTintedView() {
        let message = BonusSystemVCStrings.markTintedMessage
        markTintedView.setTextLabel(text: message.makeAttributed(icon: Icons.exclamationMark, tint: .flcOrange, size: (0, -2.5, 17, 16), placeIcon: .beforeText), textAlignment: .left, fontWeight: .regular, fontSize: 15, delegate:  parentVC)
        
        NSLayoutConstraint.activate([
            markTintedView.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: padding),
            markTintedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            markTintedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureDetailsButton() {
        detailsButton.delegate = self
        
        NSLayoutConstraint.activate([
            detailsButton.topAnchor.constraint(equalTo: markTintedView.bottomAnchor, constant: padding),
            detailsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            detailsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            detailsButton.heightAnchor.constraint(equalToConstant: 60),
            detailsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}

extension BonusSystemCell: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        switch button {
        case detailsButton: parentVC.presentSafariVC(with: textButtonURLString)
        default: break
        }
    }
}
