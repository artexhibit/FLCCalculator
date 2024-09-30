import UIKit

struct ICloudVCUIHelper {
    
    static func deleteDatabaseTextButtonPressed() {
        Task {
            do {
                try await validateICloudActivation()
                await FLCPopupView.showOnMainThread(title: FLCPopupMessages.deletingCalculations, style: .spinner)
                try await deleteDatabase()
                await showSuccessPopup(message: FLCPopupMessages.databaseDeleted)
            } catch {
                await showErrorPopup(message: error.localizedDescription)
            }
        }
    }
    
    static func syncNowTextButtonPressed() {
        Task {
            do {
                try await forceICloudSync()
                await showSuccessPopup(message: FLCPopupMessages.calculationsUploadedSuccessfully)
            } catch {
                await showErrorPopup(message: error.localizedDescription)
            }
        }
    }
    
    static func configureICloudSwitch(iCloudSwitch: UISwitch) {
        Task {
            if await iCloudSwitch.isOn {
                do {
                    try await validateICloudAvailability()
                } catch {
                    await handleICloudActivationFailure(message: error.localizedDescription, switchControl: iCloudSwitch)
                    return
                }
            }
            
            UserDefaultsManager.iCloudSyncEnabled = await iCloudSwitch.isOn
            let successMessage = await iCloudSwitch.isOn ? FLCPopupMessages.calculationsUploadedSuccessfully : FLCPopupMessages.iCloudSyncDisabled
            
            do {
                if await iCloudSwitch.isOn { try await performICloudSync() }
                await showSuccessPopup(message: successMessage)
            } catch {
                UserDefaultsManager.iCloudSyncEnabled = false
                await toggleSwitchOff(iCloudSwitch)
                await showErrorPopup(message: FLCPopupMessages.failedToUploadCalculations)
            }
        }
    }
    
    private static func deleteDatabase() async throws {
        Task {
            do {
                try await ICloudManager.shared.deleteRecordsFromCloud()
                await FLCPopupView.removeFromMainThread()
            } catch {
                await FLCPopupView.removeFromMainThread()
                throw FLCICloudSyncError.cantDeleteDatabase
            }
        }
    }
    
    private static func forceICloudSync() async throws {
        try await validateICloudActivation()
        await FLCPopupView.showOnMainThread(title: FLCPopupMessages.uploadingCalculations, style: .spinner)
        try await ICloudManager.shared.uploadCalculationsToCloud()
        try await ICloudManager.shared.downloadMissingCalculationsFromCloud()
        await FLCPopupView.removeFromMainThread()
    }
    
    private static func performICloudSync() async throws {
        guard await ICloudManager.shared.isICloudAvailable() else {
            throw FLCICloudSyncError.iCloudNotAvailable
        }
        try await forceICloudSync()
    }
    
    private static func validateICloudActivation() async throws {
        guard NetworkStatusManager.shared.isDeviceOnline else {
            throw FLCICloudSyncError.needInternetConnection
        }

        guard UserDefaultsManager.iCloudSyncEnabled else {
            throw FLCICloudSyncError.iCloudSyncDisabled
        }
    }
    
    private static func validateICloudAvailability() async throws {
        guard NetworkStatusManager.shared.isDeviceOnline else {
            throw FLCICloudSyncError.needInternetConnection
        }
        guard await ICloudManager.shared.isICloudAvailable() else {
            throw FLCICloudSyncError.iCloudNotAvailable
        }
    }
    
    private static func handleICloudActivationFailure(message: String, switchControl: UISwitch) async {
        UserDefaultsManager.iCloudSyncEnabled = false
        await toggleSwitchOff(switchControl)
        await showErrorPopup(message: message)
    }
    
    private static func toggleSwitchOff(_ switchControl: UISwitch) async {
        await MainActor.run { switchControl.setOn(false, animated: true) }
    }
    
    private static func showSuccessPopup(message: String) async {
        await FLCPopupView.showOnMainThread(systemImage: FLCIcon.checkmark.icon, title: message)
    }
    
    private static func showErrorPopup(message: String) async {
        await FLCPopupView.showOnMainThread(title: message, style: .error)
    }
}
