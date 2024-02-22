import UIKit

class FLCNumberTextField: UITextField {
    
    let smallLabel = UILabel()
    let insets = UIEdgeInsets(top: 0, left: 20, bottom: 7, right: 0)
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
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: insets)
    }
    
    override func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        becomeFirstResponder ? showSmallLabel() : hideSmallLabel()
        return becomeFirstResponder
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(smallLabel)
        
        layer.cornerRadius = 10
        textColor = .label
        tintColor = .label
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 19, weight: .bold)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 15
        contentVerticalAlignment = .bottom
        backgroundColor = UIColor.accent.withAlphaComponent(0.6)
        
        autocorrectionType = .no
        returnKeyType = .next
        clearButtonMode = .whileEditing
    }
    
    private func configureSmallLabel(with text: String) {
        smallLabel.translatesAutoresizingMaskIntoConstraints = false
        
        smallLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        smallLabel.adjustsFontSizeToFitWidth = true
        smallLabel.minimumScaleFactor = 12
        smallLabel.text = text
        smallLabel.textColor = .label
        smallLabel.layer.opacity = 1
            
        smallLabelTopConstraint = smallLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        NSLayoutConstraint.activate([
            smallLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            smallLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            smallLabelTopConstraint,
            smallLabel.heightAnchor.constraint(equalToConstant: 25)
            
        ])
    }
    
    private func showSmallLabel() {
        smallLabelTopConstraint.isActive = false
        smallLabelTopConstraint = smallLabel.topAnchor.constraint(equalTo: topAnchor, constant: -2)
        smallLabelTopConstraint.isActive = true
        
        let translationX = (smallLabel.bounds.width - (smallLabel.bounds.width * 0.55)) / 2
        
        UIView.animate(withDuration: 0.2) {
            self.smallLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).translatedBy(x: -translationX, y: 0)
            self.layoutIfNeeded()
        }
    }
    
    private func hideSmallLabel() {
        smallLabelTopConstraint.isActive = false
        smallLabelTopConstraint = smallLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        smallLabelTopConstraint.isActive = true
        
        UIView.animate(withDuration: 0.2) {
            self.smallLabel.transform = .identity
            self.layoutIfNeeded()
        }
    }
}
