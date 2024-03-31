import Foundation
import Firebase

struct FirebaseManager {
    private static let decoder = JSONDecoder()
    
    static func configureFirebase() { FirebaseApp.configure() }
    
    static func getDataFromFirebase<T: FirebaseIdentifiable>() async throws -> [T]? {
        let snapshot = try await Firestore.firestore().collection(T.collectionNameKey).getDocuments()
        guard let items = snapshot.documents.first?.data().values.first else { throw FLCError.unableToGetDocuments }
        guard let itemsString = items as? String else { throw FLCError.castingError }
        guard let itemsData = itemsString.data(using: .utf8) else { throw FLCError.castingError }
        
        do {
            return try decoder.decode([T].self, from: itemsData)
        } catch {
            throw FLCError.invalidData
        }
    }
    
    static func updateTariffs() {
        Task {
            do {
                let tariffs: [Tariff]? = try await getDataFromFirebase()
                
                guard let _ = PersistenceManager.updateItemsInUserDefaults(items: tariffs ?? []) else {
                    await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось обновить тарифы", style: .error)
                    return
                }
                await FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Тарифы обновлены")
            } catch {
                await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось получить тарифы", style: .error)
            }
        }
    }
    
    static func updatePickups() {
            Task {
                do {
                    let pickups: [Pickup]? = try await getDataFromFirebase()
                    
                    guard let _ = PersistenceManager.updateItemsInUserDefaults(items: pickups ?? []) else {
                        await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось обновить данные по пикапам", style: .error)
                        return
                    }
                    await FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Данные по пикапам обновлены")
                } catch {
                    await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось получить данные по пикапам", style: .error)
                }
            }
        }
}
