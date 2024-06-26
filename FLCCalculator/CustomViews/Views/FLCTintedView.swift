import UIKit

class FLCTintedView: UIView {
    
    let tintedViewLabel = FLCTextViewLabel()
    private let padding: CGFloat = 10
    private var color: UIColor = .clear

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, alpha: Double = 0.2, withText: Bool = false) {
        self.init(frame: .zero)
        set(color: color, alpha: alpha, withText: withText)
        self.color = color
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 13
        layer.borderWidth = 1
    }
    
    private func set(color: UIColor, alpha: Double, withText: Bool) {
        layer.borderColor = color.cgColor
        backgroundColor = color.withAlphaComponent(alpha)
        
        if withText {
            addSubview(tintedViewLabel)
            configureTintedViewLabel()
        }
    }
    
    func setTextLabel(text: NSAttributedString? = nil, textAlignment: NSTextAlignment = .left, fontWeight: UIFont.Weight = .regular, fontSize: CGFloat = 1, delegate: UIViewController? = nil) {
        if delegate != nil { tintedViewLabel.delegate = delegate as? UITextViewDelegate }
        tintedViewLabel.attributedText = text
        tintedViewLabel.setStyle(color: color.makeDarker(), textAlignment: textAlignment, fontWeight: fontWeight, fontSize: fontSize)
    }
    
    func updateColor(to color: UIColor) {
        backgroundColor = color
        layer.borderColor = color.cgColor
    }
    
    private func configureTintedViewLabel() { tintedViewLabel.pinToEdges(of: self, withPadding: padding) }
}
