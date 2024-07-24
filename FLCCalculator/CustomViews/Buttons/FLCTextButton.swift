import UIKit

protocol FLCTextButtonDelegate: AnyObject {
    func didTapButton(_ button: FLCTextButton)
}

class FLCTextButton: UIButton {
    
    weak var delegate: FLCTextButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, titleAlignment: UIButton.Configuration.TitleAlignment = .center, underlineTitle: Bool = false) {
        self.init(frame: .zero)
        configuration?.title = title
        configuration?.titleAlignment = titleAlignment
        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            if underlineTitle { outgoing.underlineStyle = [.single] }
            return outgoing
        }
        if titleAlignment == .leading {
            contentHorizontalAlignment = .leading
            configuration?.addInsets((0, 0, 0, 0))
        }
    }
    
    private func configure() {
        configuration = .plain()
        
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        HapticManager.addHaptic(style: .light)
        delegate?.didTapButton(self)
    }
}
