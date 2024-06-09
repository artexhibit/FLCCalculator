import UIKit

protocol FLCNumberTextFieldDelegate: AnyObject {
    func didRequestNextTextfield(_ textField: FLCNumberTextField)
    func didRequestPreviousTextField(_ textField: FLCNumberTextField)
    func didTriggerDeleteBackward(_ textField: FLCNumberTextField)
}

extension FLCNumberTextFieldDelegate {
    func didRequestNextTextfield(_ textField: FLCNumberTextField) {}
    func didRequestPreviousTextField(_ textField: FLCNumberTextField) {}
    func didTriggerDeleteBackward(_ textField: FLCNumberTextField) {}
}

class FLCNumberTextField: UITextField {
    
    private let smallLabelView = FLCSmallLabelView()
    private let insets = UIEdgeInsets(top: 0, left: 15, bottom: 7, right: 0)
    
    private var withSmallLabel = true
    private var isTextCentered = false
    
    weak var flcNumberTextfieldDelegate: FLCNumberTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureToolBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(smallLabelPlaceholderText: String = "", smallLabelFontSize: CGFloat = 0, keyboardType: UIKeyboardType = .decimalPad, textContentType: UITextContentType? = nil, fontSize: CGFloat = 19, fontWeight: UIFont.Weight = .bold, addClearButton: Bool = true, withSmallLabel: Bool = true, isTextCentered: Bool = false) {
        self.init(frame: .zero)
        
        self.withSmallLabel = withSmallLabel
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.isTextCentered = isTextCentered
        
        if addClearButton { clearButtonMode = .whileEditing }
        
        textAlignment = isTextCentered ? .center : .left
        contentVerticalAlignment = isTextCentered ? .center : .bottom
        
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        
        if withSmallLabel {
            smallLabelView.configureSmallLabel(with: smallLabelPlaceholderText, fontSize: smallLabelFontSize)
            smallLabelView.constraint(in: self)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return isTextCentered ? rect : rect.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return isTextCentered ? rect : rect.inset(by: insets)
    }
    
    override func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        guard withSmallLabel else { return false }
        
        if becomeFirstResponder {
            moveUpSmallLabel()
            switchToOrangeColors()
        } else {
            guard let text, let placeholder else { return false }
            if text.isEmpty && placeholder.isEmpty { returnToIdentity() }
        }
        return becomeFirstResponder
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        flcNumberTextfieldDelegate?.didTriggerDeleteBackward(self)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(smallLabelView)
        
        switchToOrangeColors()
        layer.cornerRadius = 14
        layer.borderWidth = 1
        textColor = .flcOrange
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 15
        autocorrectionType = .no
    }
    
    private func configureToolBar() {
        let toolbar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        toolbar.barStyle = .default
                
        let items = [
            UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(goToPreviousTextField)),
            UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(goToNextTextField)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
        ]
        toolbar.setItems(items, animated: false)
        toolbar.updateConstraintsIfNeeded()
        inputAccessoryView = toolbar
    }
    
    func switchToRedColors() {
        backgroundColor = .red.withAlphaComponent(0.2)
        tintColor = .red
        layer.borderColor = UIColor.red.cgColor
    }
    func returnToIdentity() { smallLabelView.returnSmallLabelToIdentity() }
    func moveUpSmallLabel() { smallLabelView.moveUpSmallLabel() }
    func getSmallLabel() -> UILabel { smallLabelView.smallLabel }
    
    func switchToOrangeColors() {
        backgroundColor = UIColor.flcNumberTextFieldBackground
        tintColor = .lightGray
        layer.borderColor = UIColor.flcOrange.cgColor
    }
    @objc private func doneButtonTapped() { self.resignFirstResponder() }
    @objc private func goToNextTextField() { flcNumberTextfieldDelegate?.didRequestNextTextfield(self) }
    @objc private func goToPreviousTextField() { flcNumberTextfieldDelegate?.didRequestPreviousTextField(self) }
}
