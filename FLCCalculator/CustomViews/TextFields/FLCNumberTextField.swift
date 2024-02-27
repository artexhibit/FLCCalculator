import UIKit

class FLCNumberTextField: UITextField {
    
    private let smallLabelView = FLCSmallLabelView()
    private let insets = UIEdgeInsets(top: 0, left: 15, bottom: 7, right: 0)
    static let placeholderValue = "0\(NumberFormatter().decimalSeparator ?? "")00"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureToolBar()
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
        layer.borderColor = UIColor.accent.cgColor
        layer.borderWidth = 1
        textColor = .accent
        tintColor = .lightGray
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 19, weight: .bold)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 15
        contentVerticalAlignment = .bottom
        backgroundColor = UIColor.flcNumberTextFieldBackground
        
        autocorrectionType = .no
        keyboardType = .decimalPad
        clearButtonMode = .whileEditing
    }
    
    private func configureToolBar() {
        let toolbar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 45))
        toolbar.barStyle = .default
        
        let items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
        ]
        toolbar.setItems(items, animated: false)
        toolbar.updateConstraintsIfNeeded()
        inputAccessoryView = toolbar
    }
    @objc private func doneButtonTapped() { self.resignFirstResponder() }
}
