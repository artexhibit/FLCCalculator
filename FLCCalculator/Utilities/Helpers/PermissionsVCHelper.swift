import Foundation

struct PermissionsVCHelper {
    
    static func requestFirstNotificationsAlert(delegate: PermissionsVCDelegate?) {
        Task {
            let status = await PermissionsManager.requestNotificationsAuthorizationStatus()
            delegate?.shouldUpdatePermissionButtonWithStatus(status: status, type: .notifications)
        }
    }
    
    
    static func updateUIWithNotificationsAuthorizationStatus(delegate: PermissionsVCDelegate?) {
        Task {
            let settings = await PermissionsManager.getNotificationSettings()
            
            switch settings {
            case .notDetermined, .denied: delegate?.shouldUpdatePermissionButtonWithStatus(status: false, type: .notifications)
            case .authorized, .provisional, .ephemeral: delegate?.shouldUpdatePermissionButtonWithStatus(status: true, type: .notifications)
            @unknown default: break
            }
        }
    }
}
