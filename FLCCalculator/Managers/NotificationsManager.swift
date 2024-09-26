import UIKit

struct NotificationsManager {
    static func notifyWhenInForeground(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    static func notifyWhenKeyboardWillShow(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    static func notifyWhenKeyboardWillHide(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    static func cloudKitKeyValueStoreValueDidChange(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default)
    }
}
