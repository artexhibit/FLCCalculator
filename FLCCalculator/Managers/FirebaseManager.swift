import Foundation
import Firebase

struct FirebaseManager {
    private static let decoder = JSONDecoder()
    
    static func configureFirebase() { FirebaseApp.configure() }
    
     static func getTariffs() async throws -> [Tariff] {
        let snapshot = try await Firestore.firestore().collection("tariffs").getDocuments()
        guard let tariffs = snapshot.documents.first?.data().values.first else { throw FLCError.unableToGetDocuments }
        guard let tariffsString = tariffs as? String else { throw FLCError.castingError }
        guard let tariffsData = tariffsString.data(using: .utf8) else { throw FLCError.castingError }
         
        do {
           return try decoder.decode([Tariff].self, from: tariffsData)
        } catch {
            throw FLCError.invalidData
        }
     }
    
    static func updateTariffs() {
        Task {
            do {
                let tariffs = try await getTariffs()
                
                guard let _ = PersistenceManager.update(tariffs: tariffs) else {
                    await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось обновить тарифы", style: .error)
                    return
                }
                await FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Тарифы обновлены")
            } catch {
                await FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось получить тарифы", style: .error)
            }
        }
    }
}
