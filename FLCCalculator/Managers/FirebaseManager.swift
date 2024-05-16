import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage

struct FirebaseManager {
    private static let decoder = JSONDecoder()
    private static let storageRef = Storage.storage().reference()
    private static var timer: Timer?
    
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
    
    static func downloadDocument(doc: Document, completion: @escaping ((progress: Int?, url: URL?)) -> Void) {
        var lastProgress: Int64 = 0
        let docRef = storageRef.child(doc.fileName)
        guard let fileURL = FileSystemManager.getLocalFileURL(for: doc.fileName) else { return }
        
        let downloadTask = docRef.write(toFile: fileURL) { url, error in
            timer?.invalidate()
            
            guard error == nil else {
                FLCPopupView.showOnMainThread(title: "Не удалось скачать документ", style: .error)
                completion((nil, nil))
                return
            }
            completion((nil, fileURL))
            //print("File downloaded to: \(url?.path ?? "unknown path")")
        }
        configureTimer(with: downloadTask) { completion((nil, nil)) }
        
        
        downloadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let progressPercentage = 100 * Int(progress.completedUnitCount) / Int(progress.totalUnitCount)
            
            if progress.completedUnitCount > lastProgress {
                lastProgress = progress.completedUnitCount
                configureTimer(with: downloadTask) { completion((nil, nil)) }
            }
            completion((progressPercentage, fileURL))
        }
    }
    
    static private func configureTimer(with downloadTask: StorageDownloadTask, completion: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block: { _ in
            downloadTask.cancel()
            FLCPopupView.showOnMainThread(title: "Не удалось скачать документ", style: .error)
            completion()
        })
    }
    
    static func downloadAvatar(for manager: FLCManager) async -> UIImage? {
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
