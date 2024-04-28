import UIKit

class FLCTextLayer: CATextLayer {
    static let increaseKey = "increase"
    static let decreaseKey = "decrease"
    
    private var color: UIColor = .label
    
    override init() {
        super.init()
        configure()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat, fontWeight: UIFont.Weight, color: UIColor, alignment: CATextLayerAlignmentMode) {
        self.init()
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.fontSize = fontSize
        self.foregroundColor = color.cgColor
        self.alignmentMode = alignment
        self.color = color
    }
    
    private func configure() {
        self.backgroundColor = UIColor.clear.cgColor
        self.contentsScale = UIScreen.main.scale
        self.isWrapped = true
    }
    
    func animateFont(toSize: CGFloat, animDuration: CFTimeInterval = 1, key: String) {
        let animation = CABasicAnimation(keyPath: key)
        animation.toValue = toSize
        animation.duration = animDuration
        self.add(animation, forKey: nil)
        self.fontSize = toSize
    }
    
    func setColorOnThemeChange() { self.foregroundColor = self.color.cgColor }
}
