import UIKit
import BackgroundTasks

struct AppDelegateHelper {
    
    @MainActor
    static func updateCurrencyData(for task: BGAppRefreshTask? = nil) {
        Task {
            do {
                let currencyData = try await NetworkManager.shared.getCurrencyData()
                
                guard let _ = CoreDataManager.updateItemInCoreData(item: currencyData) else {
                    task?.setTaskCompleted(success: false)
                    return
                }
            } catch {
                task?.setTaskCompleted(success: false)
            }
            task?.setTaskCompleted(success: true)
        }
    }
    
    @MainActor
    static func updateManagerData(for task: BGAppRefreshTask? = nil) {
        Task {
            do {
                if let storedManager: FLCManager = CoreDataManager.retrieveItemFromCoreData() {
                    let managers: [FLCManager] = try await FirebaseManager.getDataFromFirebase() ?? [CalculationInfo.defaultManager]
                    var manager = managers.first(where: { $0.id == storedManager.id }) ?? CalculationInfo.defaultManager
                    
                    if manager.dataDate != storedManager.dataDate {
                        let avatar = await FirebaseManager.downloadAvatar(for: manager)
                        manager.avatar = avatar ?? UIImage(resource: .personPlaceholder)
                        let _ = CoreDataManager.updateItemInCoreData(item: manager)
                    }
                }
            }
            task?.setTaskCompleted(success: true)
        }
    }
    
    @MainActor
    static func updateCalculationData(for task: BGAppRefreshTask? = nil) {
        Task {
            var success = false
            
            do {
                let dateString = try await FirebaseManager.getDateOfLastDataUpdate()
                if UserDefaults.sharedContainer.object(forKey: Keys.dateWhenDataWasUpdated) == nil {
                    let isTariffsUpdated = await FirebaseManager.updateTariffs()
                    let isPickupsUpdated = await FirebaseManager.updatePickups()
                    success = isTariffsUpdated && isPickupsUpdated
                    await save(dateString: dateString, if: isTariffsUpdated, and: isPickupsUpdated)
                } else {
                    guard let storedDate = UserDefaultsManager.dateWhenDataWasUpdated.createDate() else { return }
                    guard let receivedDate = dateString.createDate() else { return }
                    
                    if storedDate != receivedDate {
                        let isTariffsUpdated = await FirebaseManager.updateTariffs()
                        let isPickupsUpdated = await FirebaseManager.updatePickups()
                        success = isTariffsUpdated && isPickupsUpdated
                        await save(dateString: dateString, if: isTariffsUpdated, and: isPickupsUpdated)
                    }
                }
            } catch {
                success = false
                print(error)
            }
            task?.setTaskCompleted(success: success)
        }
    }
    
    @MainActor
    static func updateDocumentsData(for task: BGAppRefreshTask? = nil) {
        Task {
            do {
                guard let documents: [Document] = try await FirebaseManager.getDataFromFirebase() else {
                    task?.setTaskCompleted(success: false)
                    return
                }
                
                if let storedDocuments: [Document] = CoreDataManager.retrieveItemsFromCoreData() {
                    for doc in storedDocuments {
                        if let targetDoc = documents.first(where: { $0.fileName == doc.fileName && $0.docDate != doc.docDate }) {
                            FileSystemManager.deleteDocument(with: targetDoc.fileName)
                        }
                    }
                }
                let _ = CoreDataManager.updateItemsInCoreData(items: documents)
            }
            task?.setTaskCompleted(success: true)
        }
    }
    
    @MainActor
    static func updateAvailableLogisticsTypesData(for task: BGAppRefreshTask? = nil) {
        Task {
            do {
                guard let availableLogisticsTypes: [AvailableLogisticsType] = try await FirebaseManager.getDataFromFirebase() else {
                    task?.setTaskCompleted(success: false)
                    return
                }
                let _ = CoreDataManager.updateItemsInCoreData(items: availableLogisticsTypes)
            }
            task?.setTaskCompleted(success: true)
        }
    }
    
    static func manageStoredCalculationRecords() {
        let storedRecords: [CalculationDataFirebaseRecord] = UserDefaultsPercistenceManager.retrieveItemsFromUserDefaults() ?? [CalculationDataFirebaseRecord]()
        guard !storedRecords.isEmpty, NetworkStatusManager.shared.isDeviceOnline else { return }
        
        Task {
            for storedRecord in storedRecords { await FirebaseManager.createCalculationDocument(with: storedRecord) }
            _ = UserDefaultsPercistenceManager.saveItemsToUserDefaults(items: [CalculationDataFirebaseRecord]())
        }
    }
    
    static func updateDataOnAppLaunch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard NetworkStatusManager.shared.isDeviceOnline else { return }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastCurrencyDataUpdate) {
                updateCurrencyData()
                UserDefaultsManager.lastCurrencyDataUpdate = Date()
            }
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastCalculationDataUpdate) {
                updateCalculationData()
                UserDefaultsManager.lastCalculationDataUpdate = Date()
            }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastManagerDataUpdate) {
                updateManagerData()
                UserDefaultsManager.lastManagerDataUpdate = Date()
            }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastDocumentsDataUpdate) {
                updateDocumentsData()
                UserDefaultsManager.lastDocumentsDataUpdate = Date()
            }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastAvailableLogisticsTypesDataUpdate) {
                updateAvailableLogisticsTypesData()
                UserDefaultsManager.lastAvailableLogisticsTypesDataUpdate = Date()
            }
        }
    }
    
    static func configureSMSCounter() {
        SMSManager.checkAndResetSMSCounter()
        SMSManager.startTimer()
    }
    
    private static func save(dateString: String, if isTariffsUpdated: Bool, and isPickupsUpdated: Bool) async {
        if isTariffsUpdated && isPickupsUpdated {
            UserDefaultsManager.dateWhenDataWasUpdated = dateString
        }
    }
    
    private static func shouldUpdateData(afterDays days: Int, for lastDataUpdateDate: Date?) -> Bool {
        guard let lastDataUpdateDate else { return true }
        guard let daysAgo = Calendar.current.date(byAdding: .day, value: -days, to: Date()) else { return true }
        return lastDataUpdateDate < daysAgo
    }
    static func registerForRemoteNotifications(with app: UIApplication) { app.registerForRemoteNotifications() }
}
