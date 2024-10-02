import UIKit
import BackgroundTasks

struct AppDelegateHelper {
    
    @MainActor
    static func updateCurrencyData(for task: BGAppRefreshTask? = nil) async throws {
        do {
            let currencyData = try await NetworkManager.shared.getCurrencyData()
            
            guard let _ = CoreDataManager.updateItemInCoreData(item: currencyData) else {
                task?.setTaskCompleted(success: false)
                throw FLCError.unableToUpdateInCoreData
            }
        } catch {
            task?.setTaskCompleted(success: false)
            throw error
        }
        task?.setTaskCompleted(success: true)
    }
    
    @MainActor
    static func updateManagerData(for task: BGAppRefreshTask? = nil) async throws {
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
        } catch {
            task?.setTaskCompleted(success: false)
            throw error
        }
        task?.setTaskCompleted(success: true)
    }
    
    @MainActor
    static func updateCalculationData(for task: BGAppRefreshTask? = nil) async throws {
        var success = false
        
        do {
            let updateData = try await FirebaseManager.getFirebaseDataUpdateDates().filter { entry in
                FLCLogisticsType.allCases.contains { entry.item.rawValue.isContains($0.rawValue) }
            }
            var storedUpdateData: [FirebaseDataUpdateItem] = UserDefaultsPercistenceManager.retrieveItemsFromUserDefaults() ?? []

            for updateEntry in updateData {
                if let storedEntryIndex = storedUpdateData.firstIndex(where: { $0.item == updateEntry.item }) {
                    var storedEntry = storedUpdateData[storedEntryIndex]
                    
                    guard let storedDate = storedEntry.updateDate.createDate(format: .dotDMYHMS) else { continue }
                    guard let receivedDate = updateEntry.updateDate.createDate(format: .dotDMYHMS) else { continue }

                    if storedDate != receivedDate {
                        let item = storedEntry.item.getUpdateItemType()
                        let isUpdateSuccessful = await FirebaseManager.performUpdateForItem(item: item)
                        
                        if isUpdateSuccessful {
                            storedEntry.updateDate = updateEntry.updateDate
                            storedUpdateData[storedEntryIndex] = storedEntry
                            success = isUpdateSuccessful
                        }
                    } else { continue }
                } else {
                    let item = updateEntry.item.getUpdateItemType()
                    let isUpdateSuccessful = await FirebaseManager.performUpdateForItem(item: item)
                    
                    if isUpdateSuccessful {
                        storedUpdateData.append(updateEntry)
                        success = isUpdateSuccessful
                    }
                }
            }
            UserDefaultsPercistenceManager.updateItemsInUserDefaults(items: storedUpdateData)
        } catch {
            success = false
            throw error
        }
        task?.setTaskCompleted(success: success)
    }
    
    @MainActor
    static func updateDocumentsData(for task: BGAppRefreshTask? = nil) async throws {
        do {
            guard let documents: [Document] = try await FirebaseManager.getDataFromFirebase() else {
                task?.setTaskCompleted(success: false)
                throw FLCError.unknownFirebaseStorageError
            }
            
            if let storedDocuments: [Document] = CoreDataManager.retrieveItemsFromCoreData() {
                for doc in storedDocuments {
                    if let targetDoc = documents.first(where: { $0.fileName == doc.fileName && $0.docDate != doc.docDate }) {
                        FileSystemManager.deleteDocument(with: targetDoc.fileName)
                    }
                }
            }
            let _ = CoreDataManager.updateItemsInCoreData(items: documents)
            task?.setTaskCompleted(success: true)
        } catch {
            task?.setTaskCompleted(success: false)
            throw error
        }
    }
    
    @MainActor
    static func updateFacilitiesData(for task: BGAppRefreshTask? = nil) async throws {
        do {
            guard let facilities: [FLCFacility] = try await FirebaseManager.getDataFromFirebase() else {
                task?.setTaskCompleted(success: false)
                throw FLCError.unknownFirebaseStorageError
            }
            let _ = CoreDataManager.updateItemsInCoreData(items: facilities)
        } catch {
            task?.setTaskCompleted(success: false)
            throw error
        }
        task?.setTaskCompleted(success: true)
    }
    
    @MainActor
    static func updateAvailableLogisticsTypesData(for task: BGAppRefreshTask? = nil) async throws {
        do {
            guard let availableLogisticsTypes: [AvailableLogisticsType] = try await FirebaseManager.getDataFromFirebase() else {
                task?.setTaskCompleted(success: false)
                throw FLCError.unknownFirebaseStorageError
            }
            let _ = CoreDataManager.updateItemsInCoreData(items: availableLogisticsTypes)
        } catch {
            task?.setTaskCompleted(success: false)
            throw error
        }
        task?.setTaskCompleted(success: true)
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
                Task { try await updateCurrencyData() }
                UserDefaultsManager.lastCurrencyDataUpdate = Date()
            }
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastCalculationDataUpdate) {
                Task { try await updateCalculationData() }
                UserDefaultsManager.lastCalculationDataUpdate = Date()
            }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastManagerDataUpdate) {
                Task { try await updateManagerData() }
                UserDefaultsManager.lastManagerDataUpdate = Date()
            }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastDocumentsDataUpdate) {
                Task { try await updateDocumentsData() }
                UserDefaultsManager.lastDocumentsDataUpdate = Date()
            }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastFacilitiesDataUpdate) {
                Task { try await updateFacilitiesData() }
                UserDefaultsManager.lastFacilitiesDataUpdate = Date()
            }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastAvailableLogisticsTypesDataUpdate) {
                Task { try await updateAvailableLogisticsTypesData() }
                UserDefaultsManager.lastAvailableLogisticsTypesDataUpdate = Date()
            }
        }
    }
    
    static func configureSMSCounter() {
        SMSManager.checkAndResetSMSCounter()
        SMSManager.startTimer()
    }
    
    static func resetFLCUserDataOnAppInitialLaunch() {
        if UserDefaultsManager.isFirstLaunch {
            KeychainManager.shared.delete(type: FLCUserCredentials.self)
            UserDefaultsPercistenceManager.deleteItemFromUserDefaults(itemType: FLCUser.self)
            UserDefaultsManager.isFirstLaunch = false
        }
    }
    
    static func assignCloudIDToAllStoredCalculations() {
        guard let calculations = CoreDataManager.loadCalculationsWithCondition(condition: "cloudID == nil"), !calculations.isEmpty else { return }
        
        calculations.forEach({ $0.cloudID = UUID() })
        Persistence.shared.saveContext()
    }
    
    private static func shouldUpdateData(afterDays days: Int, for lastDataUpdateDate: Date?) -> Bool {
        guard let lastDataUpdateDate else { return true }
        guard let daysAgo = Calendar.current.date(byAdding: .day, value: -days, to: Date()) else { return true }
        return lastDataUpdateDate < daysAgo
    }
    static func assignUserCountryIfNil() {
        if var user: FLCUser = UserDefaultsPercistenceManager.retrieveItemFromUserDefaults() {
            if user.userCountry == nil { user.userCountry = .russia }
            let _ = UserDefaultsPercistenceManager.saveItemToUserDefaults(item: user)
        }
    }
    static func registerForRemoteNotifications(with app: UIApplication) { app.registerForRemoteNotifications() }
}
