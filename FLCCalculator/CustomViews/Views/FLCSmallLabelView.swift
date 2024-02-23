import UIKit

class FLCSmallLabelView: UIView {
    
    let smallLabel = UILabel()
    var smallLabelTopConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholderText: String) {
        self.init(frame: .zero)
        configureSmallLabel(with: placeholderText)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        addSubviews(smallLabel)
    }
    
    func constraint(in view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureSmallLabel(with text: String) {
        smallLabel.translatesAutoresizingMaskIntoConstraints = false
        
        smallLabel.font = UIFont.preferredFont(forTextStyle: .body)
        smallLabel.adjustsFontSizeToFitWidth = true
        smallLabel.minimumScaleFactor = 0.5
        smallLabel.numberOfLines = 1
        smallLabel.text = text
        smallLabel.textColor = .label
        smallLabel.layer.opacity = 1
        
        smallLabelTopConstraint = smallLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        NSLayoutConstraint.activate([
            smallLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            smallLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            smallLabel.heightAnchor.constraint(equalToConstant: 25),
            smallLabelTopConstraint
        ])
    }
    
     func moveUpSmallLabel() {
        tintColor = .label
        layoutIfNeeded()
        
        smallLabelTopConstraint.isActive = false
        smallLabelTopConstraint = smallLabel.topAnchor.constraint(equalTo: topAnchor, constant: -1)
        smallLabelTopConstraint.isActive = true
        
        let translationX = (smallLabel.bounds.width - (smallLabel.bounds.width * 0.57)) / 2
        
        UIView.animate(withDuration: 0.2) {
            self.smallLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).translatedBy(x: -translationX, y: 0)
            self.layoutIfNeeded()
        }
    }
    
     func returnSmallLabelToIdentity() {
        smallLabelTopConstraint.isActive = false
        smallLabelTopConstraint = smallLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        smallLabelTopConstraint.isActive = true
        
        UIView.animate(withDuration: 0.2) {
            self.smallLabel.transform = .identity
            self.layoutIfNeeded()
        }
    }
}
