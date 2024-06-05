import UIKit

struct HapticManager {
    static private let notificationGenerator = UINotificationFeedbackGenerator()
    
    static func addSuccessHaptic(delay: Double = 0) {
        guard UserDefaultsManager.isHapticTurnedOn else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(.success)
        }
    }
    
    static func addErrorHaptic() {
        guard UserDefaultsManager.isHapticTurnedOn else { return }
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(.error)
    }
    
    static func addHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard UserDefaultsManager.isHapticTurnedOn else { return }
        let impactGenerator = UIImpactFeedbackGenerator(style: style)
        impactGenerator.prepare()
        impactGenerator.impactOccurred()
    }
}
