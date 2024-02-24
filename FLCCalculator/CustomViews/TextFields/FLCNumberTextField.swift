import UIKit

class FLCNumberTextField: UITextField {
    
    private let smallLabelView = FLCSmallLabelView()
    private let insets = UIEdgeInsets(top: 0, left: 15, bottom: 7, right: 0)
    static let placeholderValue = "0\(NumberFormatter().decimalSeparator ?? "")00"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholderText: String) {
        self.init(frame: .zero)
        smallLabelView.configureSmallLabel(with: placeholderText)
        smallLabelView.constraint(in: self)
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
        becomeFirstResponder ? smallLabelView.moveUpSmallLabel() : smallLabelView.returnSmallLabelToIdentity()
        return becomeFirstResponder
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(smallLabelView)
        
        layer.cornerRadius = 14
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
        keyboardType = .decimalPad
        clearButtonMode = .whileEditing
    }
}
