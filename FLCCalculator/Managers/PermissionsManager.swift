import Foundation
import UserNotifications
import UserNotificationsUI

struct PermissionsManager {
    
    static func configureUNUserNotificationCenter(delegate: AnyObject) { UNUserNotificationCenter.current().delegate = delegate as? any UNUserNotificationCenterDelegate }
    
    static func getNotificationSettings() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }
    
    static func requestNotificationsAuthorizationStatus() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print(error)
            return false
        }
    }
    
    static func openAppPermissionsSettings() {
        guard let appSettings = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
    }
}
