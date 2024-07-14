import UIKit

struct PermissionsVCHelper {
    
    static func requestFirstNotificationsAlert(delegate: PermissionsVCDelegate?, in vc: UIViewController) {
        Task {
            let status = await PermissionsManager.requestNotificationsAuthorizationStatus()
            delegate?.shouldUpdatePermissionButtonWithStatus(status: status, type: .notifications)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { if status { vc.dismiss(animated: true) } }
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
