import UIKit

struct HapticManager {
    static private let notificationGenerator = UINotificationFeedbackGenerator()
    
    static func addSuccessHaptic(delay: Double = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(.success)
        }
    }
    
    static func addErrorHaptic() {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(.error)
    }
    
    static func addHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactGenerator = UIImpactFeedbackGenerator(style: style)
        impactGenerator.prepare()
        impactGenerator.impactOccurred()
    }
}
