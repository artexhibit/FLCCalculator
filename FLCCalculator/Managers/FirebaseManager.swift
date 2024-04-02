import Foundation
import Firebase

struct FirebaseManager {
    private static let decoder = JSONDecoder()
    
    static func configureFirebase() { FirebaseApp.configure() }
    
    static func getDateOfLastDataUpdate() async throws -> String {
        let snapshot = try await Firestore.firestore().collection(Keys.dateWhenDataWasUpdated).getDocuments()
        guard let timestamp = snapshot.documents.first?.data().values.first as? Timestamp else {
            throw FLCError.unableToGetDocuments
        }
        let date = timestamp.dateValue().formatted(date: .numeric, time: .standard)
        return date
    }
    
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
    
    static func updateTariffs() async -> Bool {
        do {
            let tariffs: [Tariff]? = try await getDataFromFirebase()
            guard let _ = PersistenceManager.updateItemsInUserDefaults(items: tariffs ?? []) else {
                return false
            }
            return true
        } catch {
            return false
        }
    }
    
    static func updatePickups() async -> Bool {
        do {
            let pickups: [Pickup]? = try await getDataFromFirebase()
            
            guard let _ = PersistenceManager.updateItemsInUserDefaults(items: pickups ?? []) else {
                return false
            }
            return true
        } catch {
            return false
        }
    }
}
