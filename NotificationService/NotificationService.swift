import UserNotifications

enum FLCNotificationServiceDataKeys: String {
    case isCalculationDataAvailable, isDocumentsDataAvailable, isManagerDataAvailable, isNewLogisticsTypesDataAvailable
}

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        guard let bestAttemptContent = bestAttemptContent else { return }
        
        let data = bestAttemptContent.userInfo as NSDictionary
        
        for (key, value) in data {
            guard let keyString = key as? String else { return }
            guard let dataKey = FLCNotificationServiceDataKeys(rawValue: keyString) else { continue }
            guard let value = value as? Bool else { continue }
           
            if value {
                switch dataKey {
                case .isCalculationDataAvailable: break
                   // Task { await AppDelegateHelper.updateCalculationData(canShowPopup: false) }
                case .isDocumentsDataAvailable: break
                   // Task { await AppDelegateHelper.updateDocumentsData() }
                case .isManagerDataAvailable: break
                   // Task { await AppDelegateHelper.updateManagerData() }
                case .isNewLogisticsTypesDataAvailable: break
                   // Task { await AppDelegateHelper.updateAvailableLogisticsTypesData() }
                }
            }
        }
        contentHandler(bestAttemptContent)
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
