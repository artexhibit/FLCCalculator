import UIKit

struct ICloudVCUIHelper {
    static func configureICloudSwitch(iCloudSwitch: UISwitch) {
        Task {
            if await iCloudSwitch.isOn {
                guard NetworkStatusManager.shared.isDeviceOnline else {
                    await handleICloudStatusError(message: FLCPopupMessages.needInternetConnection, iCloudSwitch: iCloudSwitch)
                    return
                }
                guard await ICloudManager.shared.isICloudAvailable() else {
                    await handleICloudStatusError(message: FLCPopupMessages.iCloudIsNotAvailable, iCloudSwitch: iCloudSwitch)
                    return
                }
            }
            
            UserDefaultsManager.iCloudSyncEnabled = await iCloudSwitch.isOn
            let successMessage = await iCloudSwitch.isOn ? FLCPopupMessages.calculationsUploadedSuccessfully : FLCPopupMessages.iCloudSyncDisabled
            
            do {
                if await iCloudSwitch.isOn {
                    await FLCPopupView.showOnMainThread(title: FLCPopupMessages.uploadingCalculations, style: .spinner)
                    try await ICloudManager.shared.uploadCalculationsToCloud()
                    try await ICloudManager.shared.downloadMissingCalculationsFromCloud()
                    await FLCPopupView.removeFromMainThread()
                }
                await FLCPopupView.showOnMainThread(systemImage: FLCIcon.checkmark.icon, title: successMessage)
            } catch {
                UserDefaultsManager.iCloudSyncEnabled = false
                await iCloudSwitch.setOn(false, animated: true)
                await FLCPopupView.removeFromMainThread()
                await FLCPopupView.showOnMainThread(title: FLCPopupMessages.failedToUploadCalculations, style: .error)
            }
        }
    }
    
    private static func handleICloudStatusError(message: String, iCloudSwitch: UISwitch) async {
        UserDefaultsManager.iCloudSyncEnabled = false
        await iCloudSwitch.setOn(false, animated: true)
        await FLCPopupView.showOnMainThread(title: message, style: .error)
    }
}
