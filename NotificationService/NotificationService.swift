import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
       
        guard let bestAttemptContent = bestAttemptContent else { return }
        let data = bestAttemptContent.userInfo as NSDictionary
        updateData(data: data)
        contentHandler(bestAttemptContent)
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func updateData(data: NSDictionary) {
        for (key, value) in data {
            guard let keyString = key as? String else { return }
            guard let dataKey = FLCNotificationServiceDataKey(rawValue: keyString) else { continue }
            guard let value = value as? String, let boolValue = Bool(value) else { continue }
            FirebaseManager.configureFirebase()
            
            switch dataKey {
            case .isCalculationDataAvailable:
                if boolValue { Task { await AppDelegateHelper.updateCalculationData() } }
            case .isDocumentsDataAvailable:
                if boolValue { Task { await AppDelegateHelper.updateDocumentsData() } }
            case .isManagerDataAvailable:
                if boolValue { Task { await AppDelegateHelper.updateManagerData() } }
            case .isNewLogisticsTypesDataAvailable:
                if boolValue { Task { await AppDelegateHelper.updateAvailableLogisticsTypesData() } }
            }
        }
    }
}
