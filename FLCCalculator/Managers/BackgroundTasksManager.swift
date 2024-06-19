import Foundation
import BackgroundTasks

struct BackgroundTasksManager {
    
    static func registerTask(id: FLCBackgroundFetchId, beginDateInterval: TimeInterval) {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: id.rawValue, using: nil) { task in
            guard let task = task as? BGAppRefreshTask else { return }
            self.handleTask(task: task, id: id)
            self.scheduleTask(id: id, beginDateInterval: beginDateInterval)
        }
        scheduleTask(id: id, beginDateInterval: beginDateInterval)
    }
    
    static private func scheduleTask(id: FLCBackgroundFetchId, beginDateInterval: TimeInterval) {
        do {
            let newTask = BGAppRefreshTaskRequest(identifier: id.rawValue)
            newTask.earliestBeginDate = Date().addingTimeInterval(beginDateInterval)
            try BGTaskScheduler.shared.submit(newTask)
        } catch {
            print("Could not schedule app refresh: \(error)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) { self.scheduleTask(id: id, beginDateInterval: beginDateInterval) }
        }
    }
    
    static private func handleTask(task: BGAppRefreshTask, id: FLCBackgroundFetchId) {
        DispatchQueue.main.async {
            task.expirationHandler = { task.setTaskCompleted(success: false) }
            
            switch id {
            case .updateCurrencyDataTaskId:
                AppDelegateHelper.updateCurrencyData(for: task)
            case .updateCalculationData:
                AppDelegateHelper.updateCalculationData(for: task)
            case .updateManagerData:
                AppDelegateHelper.updateManagerData(for: task)
            case .updateDocumentsData:
                AppDelegateHelper.updateDocumentsData(for: task)
            case .updateAvailableLogisticsTypesData:
                AppDelegateHelper.updateAvailableLogisticsTypesData(for: task)
            }
        }
    }
    
    static func registerBackgroundTasks() {
        BackgroundTasksManager.registerTask(id: FLCBackgroundFetchId.updateCurrencyDataTaskId, beginDateInterval: (3600 * 8))
        BackgroundTasksManager.registerTask(id: FLCBackgroundFetchId.updateCalculationData, beginDateInterval: (3600 * 24))
        BackgroundTasksManager.registerTask(id: FLCBackgroundFetchId.updateManagerData, beginDateInterval: (3600 * 24 * 7))
        BackgroundTasksManager.registerTask(id: FLCBackgroundFetchId.updateDocumentsData, beginDateInterval: (3600 * 24 * 7))
        BackgroundTasksManager.registerTask(id: FLCBackgroundFetchId.updateAvailableLogisticsTypesData, beginDateInterval: (3600 * 24 * 7))
    }
}
