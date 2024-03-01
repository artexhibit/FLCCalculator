import UIKit

class FLCSubtitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, textAlignment: NSTextAlignment, isHided: Bool = false) {
        self.init(frame: .zero)
        self.textColor = color
        self.textAlignment = textAlignment
        if isHided { self.layer.opacity = 0 }
    }
    
    private func configure() {
        font = UIFont.preferredFont(forTextStyle: .callout)
        minimumScaleFactor = 0.9
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func showError(animDuration: Double) {
        animateIn()
        animateOut(afterSeconds: animDuration)
    }
    
    private func animateIn() {
        DispatchQueue.main.async { UIView.animate(withDuration: 0.2) { self.layer.opacity = 1 } }
    }
    
    private func animateOut(afterSeconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + afterSeconds) { 
            UIView.animate(withDuration: 0.5) { self.layer.opacity = 0 }
        }
    }
}
