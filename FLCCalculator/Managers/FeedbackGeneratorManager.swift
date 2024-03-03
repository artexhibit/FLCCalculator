import UIKit

struct FeedbackGeneratorManager {
    static private let notificationGenerator = UINotificationFeedbackGenerator()
    
    static func addSuccessHaptic() {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(.success)
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
