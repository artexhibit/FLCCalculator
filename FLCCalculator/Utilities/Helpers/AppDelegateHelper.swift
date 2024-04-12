import Foundation

struct  AppDelegateHelper {
    static func updateCurrencyData() {
        Task {
            do {
                let currencyData = try await NetworkManager.shared.getCurrencyData()
                guard let _ = PersistenceManager.update(newCurrencyData: currencyData) else {
                    await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось обновить курсы валют", style: .error)
                    return
                }
                await FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Курсы валют обновлены")
            } catch {
                await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось получить курсы валют", style: .error)
            }
        }
    }
    
    static func updateCalculationData() {
        Task {
            do {
                let dateString = try await FirebaseManager.getDateOfLastDataUpdate()
                if UserDefaults.sharedContainer.object(forKey: Keys.dateWhenDataWasUpdated) == nil {
                    let isTariffsUpdated = await FirebaseManager.updateTariffs()
                    let isPickupsUpdated = await FirebaseManager.updatePickups()
                    await save(dateString: dateString, if: isTariffsUpdated, and: isPickupsUpdated)
                } else {
                    guard let storedDate = UserDefaultsManager.dateWhenDataWasUpdated.createDate() else { return }
                    guard let receivedDate = dateString.createDate() else { return }
                    
                    if storedDate != receivedDate {
                        let isTariffsUpdated = await FirebaseManager.updateTariffs()
                        let isPickupsUpdated = await FirebaseManager.updatePickups()
                        await save(dateString: dateString, if: isTariffsUpdated, and: isPickupsUpdated)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    private static func save(dateString: String, if isTariffsUpdated: Bool, and isPickupsUpdated: Bool) async {
        if isTariffsUpdated && isPickupsUpdated {
            UserDefaultsManager.dateWhenDataWasUpdated = dateString
           await FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Данные для расчёта загружены")
        } else {
            await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось загрузить данные. Попробуйте обновить Тарифы и Пикапы в разделе Настройки", style: .error)
        }
    }
}
