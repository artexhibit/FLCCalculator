import UIKit

class FLCNumberTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
       let becomeFirstResponder = super.becomeFirstResponder()
        
        if becomeFirstResponder {
        }
        return becomeFirstResponder
    }
    
    convenience init(placeholderText: String) {
        self.init(frame: .zero)
        placeholder = placeholderText
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.accent.cgColor
        
        textColor = .accent
        tintColor = .accent
        textAlignment = .left
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .clear
        autocorrectionType = .no
        returnKeyType = .next
        clearButtonMode = .whileEditing
        
        let color = UIColor.accent.withAlphaComponent(0.5)
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : color])
        
        addLeadingPadding(15)
    }
}
