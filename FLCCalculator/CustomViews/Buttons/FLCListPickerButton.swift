import UIKit

protocol FLCListPickerButtonDelegate: AnyObject {
    func didTapButton(_ button: FLCListPickerButton)
}

class FLCListPickerButton: UIButton {

    let smallLabelView = FLCSmallLabelView()
    private var selectedUIMenuItem = ""
    var inDisabledState: Bool = false
    var titleIsEmpty: Bool { titleLabel?.text == nil ? true : false }
    var showingTitle: String {
        get { titleLabel?.text ?? "" }
        set { setTitle(newValue, for: .normal) }
    }
    
    weak var delegate: FLCListPickerButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholderText: String, smallLabelFontSize: CGFloat = 0, mainLabelFontSize: CGFloat = 19) {
        self.init(frame: .zero)
        smallLabelView.configureSmallLabel(with: placeholderText, fontSize: smallLabelFontSize)
        smallLabelView.constraint(in: self)
        configuration = setButtonConfiguration(fontSize: mainLabelFontSize)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(smallLabelView)
        
        contentHorizontalAlignment = .leading
        contentVerticalAlignment = .bottom
        
        layer.cornerRadius = 14
        layer.borderWidth = 1
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = 0.5
        
        setEnabled()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        smallLabelView.frame = self.frame
    }
    
    func set(title: String) { setTitle(title, for: .normal) }
    
    func switchToRedColors() {
        backgroundColor = .red.withAlphaComponent(0.2)
        tintColor = .red
        layer.borderColor = UIColor.red.cgColor
    }
    
    func switchToOrangeColors() {
        backgroundColor = .flcNumberTextFieldBackground
        tintColor = .label
        layer.borderColor = UIColor.flcOrange.cgColor
    }
    
    func setEnabled() {
        inDisabledState = false
        layer.borderColor = UIColor.flcOrange.cgColor
        tintColor = .label
        setTitleColor(.label, for: .normal)
        backgroundColor = .flcNumberTextFieldBackground
        setTitleColor(.flcOrange, for: .normal)
    }
    
    func setDisabled() {
        inDisabledState = true
        layer.borderColor = UIColor.flcNumberTextFieldDisabled.cgColor
        tintColor = .label
        setTitleColor(.label, for: .normal)
        backgroundColor = .flcNumberTextFieldDisabled
        setTitleColor(.flcOrange, for: .normal)
    }
    
    func resetState(isDisabled: Bool = false) {
        setTitle("", for: .normal)
        titleLabel?.text = nil
        smallLabelView.returnSmallLabelToIdentity()
        if isDisabled { setDisabled() }
    }
    
    private func setButtonConfiguration(fontSize: CGFloat = 19) -> UIButton.Configuration {
        var config = Configuration.plain()
        config.addInsets((0, 15, 8, 10))
        config.setupCustomFont(ofSize: fontSize)
        config.titleLineBreakMode = .byTruncatingTail
        return config
    }
    
    @objc private func buttonTapped() { delegate?.didTapButton(self) }
}
