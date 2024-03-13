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
    
    convenience init(title: String) {
        self.init(frame: .zero)
        configuration?.title = title
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
