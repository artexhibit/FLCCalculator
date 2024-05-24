import UIKit
import BackgroundTasks

struct  AppDelegateHelper {
    static func updateCurrencyData(for task: BGAppRefreshTask? = nil, canShowPopup: Bool = true) {
        Task {
            do {
                let currencyData = try await NetworkManager.shared.getCurrencyData()
                
                guard let _ = CoreDataManager.updateItemInCoreData(item: currencyData) else {
                    if canShowPopup {
                        await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось обновить курсы валют", style: .error)
                    }
                    task?.setTaskCompleted(success: false)
                    return
                }
                if canShowPopup {
                    await FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Курсы валют обновлены")
                }
            } catch {
                if canShowPopup {
                    await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось получить курсы валют", style: .error)
                }
                task?.setTaskCompleted(success: false)
            }
            task?.setTaskCompleted(success: true)
        }
    }
    
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
    
    static func updateCalculationData(for task: BGAppRefreshTask? = nil, canShowPopup: Bool = true) {
        Task {
            var success = false
            
            do {
                let dateString = try await FirebaseManager.getDateOfLastDataUpdate()
                if UserDefaults.sharedContainer.object(forKey: Keys.dateWhenDataWasUpdated) == nil {
                    let isTariffsUpdated = await FirebaseManager.updateTariffs()
                    let isPickupsUpdated = await FirebaseManager.updatePickups()
                    success = isTariffsUpdated && isPickupsUpdated
                    await save(dateString: dateString, if: isTariffsUpdated, and: isPickupsUpdated, canShowPopup: canShowPopup)
                } else {
                    guard let storedDate = UserDefaultsManager.dateWhenDataWasUpdated.createDate() else { return }
                    guard let receivedDate = dateString.createDate() else { return }
                    
                    if storedDate != receivedDate {
                        let isTariffsUpdated = await FirebaseManager.updateTariffs()
                        let isPickupsUpdated = await FirebaseManager.updatePickups()
                        success = isTariffsUpdated && isPickupsUpdated
                        await save(dateString: dateString, if: isTariffsUpdated, and: isPickupsUpdated, canShowPopup: canShowPopup)
                    }
                }
            } catch {
                success = false
                print(error)
            }
            task?.setTaskCompleted(success: success)
        }
    }
    
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
    
    static func registerBackgroundTasks() {
        BackgroundTasksManager.registerTask(id: FLCBackgroundFetchId.updateCurrencyDataTaskId, beginDateInterval: (3600 * 8))
        BackgroundTasksManager.registerTask(id: FLCBackgroundFetchId.updateCalculationData, beginDateInterval: (3600 * 24))
        BackgroundTasksManager.registerTask(id: FLCBackgroundFetchId.updateManagerData, beginDateInterval: (3600 * 24 * 7))
        BackgroundTasksManager.registerTask(id: FLCBackgroundFetchId.updateDocumentsData, beginDateInterval: (3600 * 24 * 7))
    }
    
    static func updateDataOnAppLaunch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard NetworkAvailabilityManager.shared.currentStatus() == .connected else { return }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastCurrencyDataUpdate) {
                updateCurrencyData(canShowPopup: false)
                UserDefaultsManager.lastCurrencyDataUpdate = Date()
            }
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastCalculationDataUpdate) {
                updateCalculationData(canShowPopup: false)
                UserDefaultsManager.lastCalculationDataUpdate = Date()
            }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastManagerDataUpdate) {
                updateManagerData()
                UserDefaultsManager.lastManagerDataUpdate = Date()
            }
            
            if shouldUpdateData(afterDays: 1, for: UserDefaultsManager.lastDocumentsDataUpdate) {
                updateDocumentsData()
                UserDefaultsManager.lastManagerDataUpdate = Date()
            }
        }
    }
    
    private static func save(dateString: String, if isTariffsUpdated: Bool, and isPickupsUpdated: Bool, canShowPopup: Bool = true) async {
        if isTariffsUpdated && isPickupsUpdated {
            UserDefaultsManager.dateWhenDataWasUpdated = dateString
            if canShowPopup {
                await FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Данные для расчёта загружены")
            }
        } else {
            if canShowPopup {
                await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось загрузить данные. Попробуйте обновить Тарифы и Пикапы в разделе Настройки", style: .error)
            }
        }
    }
    
    private static func shouldUpdateData(afterDays days: Int, for lastDataUpdateDate: Date?) -> Bool {
        guard let lastDataUpdateDate else { return true }
        guard let daysAgo = Calendar.current.date(byAdding: .day, value: -days, to: Date()) else { return true }
        return lastDataUpdateDate < daysAgo
    }
}
