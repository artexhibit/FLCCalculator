import Foundation
import UserNotifications
import UserNotificationsUI

class PermissionsManager: NSObject {
    private static let shared = PermissionsManager()
    
    static func configureUNUserNotificationCenterDelegate() { UNUserNotificationCenter.current().delegate = shared }
    
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

extension PermissionsManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions { [.banner, .sound] }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {}
}
