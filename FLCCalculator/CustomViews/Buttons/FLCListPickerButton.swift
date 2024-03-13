import UIKit

protocol FLCListPickerButtonDelegate: AnyObject {
    func didTapButton(_ button: FLCListPickerButton)
}

class FLCListPickerButton: UIButton {

    let smallLabelView = FLCSmallLabelView()
    private var selectedUIMenuItem = ""
    private let insets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 8, trailing: 10)
    var inDisabledState: Bool = false
    var titleIsEmpty: Bool { titleLabel?.text == nil ? true : false }
    var showingTitle: String {
        get { titleLabel?.text ?? "" }
        set { titleLabel?.text = newValue }
    }
    
    weak var delegate: FLCListPickerButtonDelegate?
    
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
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(smallLabelView)
        
        contentHorizontalAlignment = .leading
        contentVerticalAlignment = .bottom
        
        layer.cornerRadius = 14
        layer.borderWidth = 1
        
        configuration = setButtonConfiguration()
        
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
        layer.borderColor = UIColor.accent.cgColor
    }
    
    func setEnabled() {
        inDisabledState = false
        layer.borderColor = UIColor.accent.cgColor
        tintColor = .label
        setTitleColor(.label, for: .normal)
        backgroundColor = .flcNumberTextFieldBackground
        setTitleColor(.accent, for: .normal)
    }
    
    func setDisabled() {
        inDisabledState = true
        layer.borderColor = UIColor.flcNumberTextFieldDisabled.cgColor
        tintColor = .label
        setTitleColor(.label, for: .normal)
        backgroundColor = .flcNumberTextFieldDisabled
        setTitleColor(.accent, for: .normal)
    }
    
    func resetState(disable: Bool = false) {
        setTitle("", for: .normal)
        titleLabel?.text = nil
        smallLabelView.returnSmallLabelToIdentity()
        if disable { setDisabled() }
    }
    
    private func setButtonConfiguration() -> UIButton.Configuration {
        var config = Configuration.plain()
        config.contentInsets = insets
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { old in
            var new = old
            new.font = UIFont.systemFont(ofSize: 19, weight: .bold)
            return new
        }
        config.titleLineBreakMode = .byTruncatingTail
        return config
    }
    
    @objc private func buttonTapped() { delegate?.didTapButton(self) }
}
