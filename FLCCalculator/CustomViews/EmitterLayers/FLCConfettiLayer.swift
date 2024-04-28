import UIKit

class FLCConfettiLayer: CAEmitterLayer {
    
    private var confettiTypes = [FLCConfetti]()
    private var confettiCells = [CAEmitterCell]()
    
    override init() {
        super.init()
        configureConfettiTypes()
        configureConfettiCells()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    convenience init(view: UIView) {
        self.init()
        configureLayer(in: view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConfettiTypes() {
        let confettiColors = [UIColor.flcOrange, UIColor.gray, UIColor.systemOrange]
        
        confettiTypes = [FLCConfettiPosition.foreground, FLCConfettiPosition.background].flatMap { position in
            return [FLCConfettiShape.rectangle, FLCConfettiShape.circle].flatMap { shape in
                return confettiColors.map { color in
                    return FLCConfetti(color: color, shape: shape, position: position)
                }
            }
        }
    }
    
    private func configureConfettiCells() {
        confettiCells = confettiTypes.map { confettiType in
            let cell = CAEmitterCell()
            
            cell.beginTime = 0.1
            cell.birthRate = 100
            cell.name = confettiType.name
            cell.contents = confettiType.image.cgImage
            cell.emissionRange = CGFloat(Double.pi)
            cell.lifetime = 10
            cell.spin = 4
            cell.spinRange = 8
            cell.velocityRange = 0
            cell.yAcceleration = 0
            
            cell.setValue("plane", forKey: "particleType")
            cell.setValue(Double.pi, forKey: "orientationRange")
            cell.setValue(Double.pi / 2, forKey: "orientationLongitude")
            cell.setValue(Double.pi / 2, forKey: "orientationLatitude")
            
            return cell
        }
    }
    
    private func configureLayer(in view: UIView) {
        self.emitterCells = confettiCells
        self.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.minY - 500)
        self.emitterSize = CGSize(width: view.bounds.size.width, height: 500)
        self.emitterShape = .sphere
        self.birthRate = 0
        self.frame = view.bounds
        self.beginTime = CACurrentMediaTime()
    }
    
    private func createBehavior(type: String) -> NSObject {
        let behaviorClass = NSClassFromString("CAEmitterBehavior") as! NSObject.Type
        let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:"))!
        let castedBehaviorWithType = unsafeBitCast(behaviorWithType, to:(@convention(c)(Any?, Selector, Any?) -> NSObject).self)
        return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
    }
    
    private func attractorBehavior(for emitterLayer: CAEmitterLayer) -> Any {
        let behavior = createBehavior(type: "attractor")
        
        behavior.setValue(-290, forKeyPath: "falloff")
        behavior.setValue(300, forKeyPath: "radius")
        behavior.setValue(10, forKeyPath: "stiffness")
        
        behavior.setValue(CGPoint(x: emitterLayer.emitterPosition.x, y: emitterLayer.emitterPosition.y + 20), forKeyPath: "position")
        behavior.setValue(-70, forKeyPath: "zPosition")
        return behavior
    }
    
    private func addAttractorAnimation(to layer: CALayer) {
        let animation = CAKeyframeAnimation()
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.duration = 3
        animation.keyTimes = [0, 0.4]
        animation.values = [80, 5]
        
        layer.add(animation, forKey: "emitterBehaviors.attractor.stiffness")
    }
    
    private func addBirthrateAnimation(to layer: CALayer) {
        let animation = CABasicAnimation()
        animation.duration = 1
        animation.fromValue = 1
        animation.toValue = 0
        
        layer.add(animation, forKey: "birthRate")
    }
    
    private func dragBehavior() -> Any {
        let behavior = createBehavior(type: "drag")
        behavior.setValue("drag", forKey: "name")
        behavior.setValue(2, forKey: "drag")
        
        return behavior
    }
    
    private func addDragAnimation(to layer: CALayer) {
        let animation = CABasicAnimation()
        animation.duration = 0.35
        animation.fromValue = 0
        animation.toValue = 2
        
        layer.add(animation, forKey:  "emitterBehaviors.drag.drag")
    }
    
    private func addGravityAnimation(to layer: CALayer) {
        let animation = CAKeyframeAnimation()
        animation.duration = 6
        animation.keyTimes = [0.05, 0.1, 0.5, 1]
        animation.values = [0, 100, 2000, 4000]
        
        for image in confettiTypes {
            layer.add(animation, forKey: "emitterCells.\(image.name).yAcceleration")
        }
    }
    
    func addBehaviors() {
        self.setValue([attractorBehavior(for: self)], forKey: "emitterBehaviors")
    }
    
    func addAnimations() {
        addAttractorAnimation(to: self)
        addBirthrateAnimation(to: self)
        addGravityAnimation(to: self)
    }
}
