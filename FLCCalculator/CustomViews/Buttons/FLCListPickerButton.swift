import UIKit

protocol FLCListPickerButtonDelegate: AnyObject {
    func buttonTapped(_ button: FLCListPickerButton)
}

class FLCListPickerButton: UIButton {

    let smallLabelView = FLCSmallLabelView()
    private var selectedUIMenuItem = ""
    private let insets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 8, trailing: 0)
    private var config = Configuration.plain()
    
    weak var delegate: FLCListPickerButtonDelegate!
    
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
        layer.borderColor = UIColor.accent.cgColor
        layer.borderWidth = 1
        
        tintColor = .label
        setTitleColor(.label, for: .normal)
        backgroundColor = UIColor.flcNumberTextFieldBackground
        setTitleColor(.accent, for: .normal)
        
        config.contentInsets = insets
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { old in
            var new = old
            new.font = UIFont.systemFont(ofSize: 19, weight: .bold)
            return new
        }
        configuration = config
        
        titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        
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
        backgroundColor = UIColor.flcNumberTextFieldBackground
        tintColor = .label
        layer.borderColor = UIColor.accent.cgColor
    }
    
    func configureUIMenu(with options: [(title: String, subtitle: String)]) -> UIMenu {
        var items = [UIAction]()
        
        options.forEach { option in
            let isSelected = option.subtitle == self.selectedUIMenuItem
            
            let menuItem = UIAction(title: option.title, image: UIImage(named: option.subtitle), state: isSelected ? .on : .off, handler: { [weak self] _ in
                guard let self else { return }
                self.smallLabelView.moveUpSmallLabel()
                self.set(title: option.subtitle)
                self.selectedUIMenuItem = option.subtitle
                self.switchToOrangeColors()
                self.menu = self.configureUIMenu(with: options)
            })
            items.append(menuItem)
        }
        return UIMenu(children: items)
    }
    
    @objc private func buttonTapped() {
       smallLabelView.moveUpSmallLabel()
       delegate.buttonTapped(self)
    }
}
