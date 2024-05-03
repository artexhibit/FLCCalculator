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
        task.expirationHandler = { task.setTaskCompleted(success: false) }
        
        switch id {
        case .updateCurrencyDataTaskId:
            AppDelegateHelper.updateCurrencyData(for: task, canShowPopup: false)
        case .updateCalculationData:
            AppDelegateHelper.updateCalculationData(for: task, canShowPopup: false)
        case .updateManagerData:
            AppDelegateHelper.updateManagerData(for: task)
        }
    }
}
