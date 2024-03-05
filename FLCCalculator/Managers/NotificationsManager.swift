import UIKit

struct NotificationsManager {
    static func notifyWhenInForeground(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}
