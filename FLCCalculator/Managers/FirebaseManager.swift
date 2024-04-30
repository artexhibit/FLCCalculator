import UIKit
import Firebase
import FirebaseStorage

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
            let chinaPickups: [ChinaPickup]? = try await getDataFromFirebase()
            guard let _ = PersistenceManager.updateItemsInUserDefaults(items: chinaPickups ?? []) else { return false }
            
            let turkeyPickups: [TurkeyPickup]? = try await getDataFromFirebase()
            guard let _ = PersistenceManager.updateItemsInUserDefaults(items: turkeyPickups ?? []) else { return false }
            return true
        } catch {
            return false
        }
    }
    
    static func downloadAvatar(for manager: FLCManager) async -> UIImage? {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let photoRef = storageRef.child(manager.avatarRef)
        
        do {
            let data = try await getAvatarData(ref: photoRef)
            guard let image = UIImage(data: data) else { return nil }
            return image
        } catch {
            return nil
        }
    }
    
    private static func getAvatarData(ref: StorageReference) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: FLCError.unknownFirebaseStorageError)
                }
            }
        }
    }
}
