import UIKit

final class DocumentsCell: UICollectionViewCell {
    
    static let reuseID = "DocumentsCell"
    
    private var shimmeringView = FLCShimmeringView()
    private let containerView = UIView()
    private let documentNameLabel = FLCSubtitleLabel(color: .flcGray, textAlignment: .left, textStyle: .callout)
    private let iconView = FLCRoundButton(image: Icons.document, tint: .flcOrange, cornerStyle: .capsule)
    private let downloadPercentageLabel = FLCTitleLabel(color: .flcOrange, textAlignment: .right, size: 15)
    private let downloadedDocumentIcon = FLCRoundButton(image: Icons.checkmark, tint: .flcOrange, cornerStyle: .capsule, imageSize: 13)
    
    private let padding: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        makeViewCanBeTapableAnimation(whenTouchesBegan: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.makeViewCanBeTapableAnimation(whenTouchesBegan: false) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.makeViewCanBeTapableAnimation(whenTouchesBegan: false) }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shimmeringView.frame = contentView.bounds
    }
    
    private func configure() {
        contentView.addSubview(containerView)
        
        configureContainerView()
        configureTitle()
        configureIconView()
        configureDownloadPercentageLabel()
        configureDownloadedDocumentIcon()
        addShimmeringView()
    }
    
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubviews(documentNameLabel, iconView, downloadPercentageLabel, downloadedDocumentIcon)
        containerView.pinToEdges(of: contentView)
        
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .tertiarySystemFill
    }
    
    private func configureTitle() {
        NSLayoutConstraint.activate([
            documentNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            documentNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            documentNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureIconView() {
        iconView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            iconView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            iconView.widthAnchor.constraint(equalToConstant: 45),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
        ])
    }
    
    private func configureDownloadPercentageLabel() {
        downloadPercentageLabel.hide()
        
        NSLayoutConstraint.activate([
            downloadPercentageLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: padding),
            downloadPercentageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            downloadPercentageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureDownloadedDocumentIcon() {
        downloadedDocumentIcon.hide()
        downloadedDocumentIcon.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            downloadedDocumentIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            downloadedDocumentIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            downloadedDocumentIcon.widthAnchor.constraint(equalToConstant: 25),
            downloadedDocumentIcon.heightAnchor.constraint(equalTo: downloadedDocumentIcon.widthAnchor)
        ])
    }
    
    func set(with document: Document, canRemoveShimmer: Bool) {
        self.documentNameLabel.text = document.title
        if canRemoveShimmer { self.removeShimmerAnimation() }
    }
    
    func setupDownloadPercentageLabel(with progress: Int?) {
        guard let progress else { return }
    
        downloadPercentageLabel.show()
        downloadPercentageLabel.text = "\(progress)%"
        
        if progress == 100 { DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { self.downloadPercentageLabel.hide() } }
    }
    
    func setupDownloadedDocumentIcon(with document: Document, progress: Int? = 0) {
        let delay = progress == 100 ? 0.4 : 0
        
        if FileSystemManager.isHavingDocument(with: document.fileName) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { self.downloadedDocumentIcon.show() }
        } else {
            downloadedDocumentIcon.hide()
        }
    }
    
    private func addShimmeringView() {
        shimmeringView = FLCShimmeringView(frame: contentView.bounds)
        contentView.addSubview(shimmeringView)
    }
    
    func addShimmerAnimation() { shimmeringView.addShimmerAnimation() }
    func removeShimmerAnimation() { shimmeringView.removeShimmerAnimation() }
}
