import UIKit

protocol FLCListPickerButtonDelegate: AnyObject {
    func buttonTapped(_ button: FLCListPickerButton)
}

class FLCListPickerButton: UIButton {

    let smallLabelView = FLCSmallLabelView()
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
        
        config.contentInsets = insets
        configuration = config
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        smallLabelView.frame = self.frame
    }
    
    func set(title: String) { setTitle(title, for: .normal) }
    
   @objc private func buttonTapped() {
       smallLabelView.moveUpSmallLabel()
       delegate.buttonTapped(self)
    }
}
