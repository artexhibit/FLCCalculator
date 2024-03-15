import UIKit

class FLCTintedView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, alpha: Double = 0.2) {
        self.init(frame: .zero)
        set(color: color, alpha: alpha)
        
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 13
        layer.borderWidth = 1
    }
    
    private func set(color: UIColor, alpha: Double) {
        layer.borderColor = color.cgColor
        backgroundColor = color.withAlphaComponent(alpha)
    }
}
