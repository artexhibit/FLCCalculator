import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseMessaging

class FirebaseManager: NSObject {
    private static let shared = FirebaseManager()
    
    private static let decoder = JSONDecoder()
    private static let storageRef = Storage.storage().reference()
    private static var timer: Timer?
    
    static func configureFirebase() { FirebaseApp.configure() }
    static func configureMessagingDelegate() { Messaging.messaging().delegate = shared }

    @MainActor
    static func getFirebaseDataUpdateDates() async throws -> [FirebaseDataUpdateItem] {
        let snapshot = try await Firestore.firestore().collection(Keys.dateDataWasUpdated).getDocuments()
        guard let dataDict = snapshot.documents.first?.data() else { throw FLCError.unableToGetDocuments }
        
        let result: [FirebaseDataUpdateItem] = dataDict.compactMap { dataEntry in
            let updateDate = (dataEntry.value as? Timestamp)?.dateValue().makeString(format: .dotDMYHMS) ?? ""
            return FirebaseDataUpdateItem(item: FLCFirebaseDataUpdateItem(rawValue: dataEntry.key) ?? .managers, updateDate: updateDate)
        }
        return result
    }
    
    @MainActor
    static func getDataFromFirebase<T: FirebaseIdentifiable>() async throws -> [T]? {
        let snapshot = try await Firestore.firestore().collection(T.collectionNameKey).getDocuments()
        guard let items = snapshot.documents.first?.data()[T.fieldNameKey] else { throw FLCError.unableToGetDocuments }
        guard let itemsString = items as? String else { throw FLCError.castingError }
        guard let itemsData = itemsString.data(using: .utf8) else { throw FLCError.castingError }
        
        do {
            return try decoder.decode([T].self, from: itemsData)
        } catch {
            throw FLCError.invalidData
        }
    }
    
    @MainActor
    static func performUpdateForItem<T: FirebaseIdentifiable & CoreDataStorable>(item: T.Type) async -> Bool {
        do {
            async let itemToUpdate: [T]? = getDataFromFirebase()
            let data = CoreDataManager.updateItemsInCoreData(items: try await itemToUpdate ?? [])
            return data != nil
        } catch {
            return false
        }
    }
    
    static func downloadDocument(doc: Document, completion: @escaping ((progress: Int?, url: URL?, isWithError: Bool)) -> Void) {
        var lastProgress: Int64 = 0
        let docRef = storageRef.child(doc.fileName)
        guard let fileURL = FileSystemManager.getLocalFileURL(for: doc.fileName) else { return }
        
        let downloadTask = docRef.write(toFile: fileURL) { url, error in
            timer?.invalidate()
            
            guard error == nil else {
                completion((nil, nil, true))
                return
            }
        }
        configureTimer(with: downloadTask) { completion((nil, nil, true)) }
        
        
        downloadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let progressPercentage = 100 * Int(progress.completedUnitCount) / Int(progress.totalUnitCount)
            
            if progress.completedUnitCount > lastProgress {
                lastProgress = progress.completedUnitCount
                configureTimer(with: downloadTask) { completion((nil, nil, true)) }
            }
            completion((progressPercentage, fileURL, false))
        }
    }
    
    static private func configureTimer(with downloadTask: StorageDownloadTask, completion: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block: { _ in
            downloadTask.cancel()
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
    
    static func createCalculationDocument(with calcData: CalculationDataFirebaseRecord) async {
        let calcDataDict = calcData.toDictionary()
        let calculationDate = calcData.calculationDate.getDataBetweenCharacter(char: ",", returnFirstHalf: true)?.replacingOccurrences(of: "/", with: ".") ?? ""

        do {
            let documentName = "\(calculationDate) \(calcData.countryFrom) \(calcData.goodsType) \(calcData.invoiceAmount) \(calcData.invoiceCurrency) \(calcData.volume) \(calcData.weight)"
            
            let newCalcEntry = Firestore.firestore().collection(Keys.calculations).document(documentName)
            try await newCalcEntry.setData(calcDataDict)
        } catch {
            print(error)
        }
    }
    
    static func updateCalculationRecordInFirebase(with data: CalculationData, and totalPriceData: [TotalPriceData]) async {
        let calculationDate = data.calculationDate.getDataBetweenCharacter(char: ",", returnFirstHalf: true)?.replacingOccurrences(of: "/", with: ".") ?? ""
        let documentName = "\(calculationDate) \(data.countryFrom) \(data.goodsType) \(data.invoiceAmount) \(data.invoiceCurrency) \(data.volume) \(data.weight)"
        let documentNameRef = Firestore.firestore().collection(Keys.calculations).document(documentName)
        
        do {
            let document = try await documentNameRef.getDocument()
            
            if document.exists {
                try await documentNameRef.updateData(["isConfirmed": true])
            } else {
                let calcEntryData = createCalculationDataFirebaseRecord(with: data, and: totalPriceData)
                await createCalculationDocument(with: calcEntryData)
            }
        } catch {
            print(error)
        }
    }
    
    static func createCalculationDataFirebaseRecord(with data: CalculationData, and totalPriceData: [TotalPriceData]) -> CalculationDataFirebaseRecord {
        let user: FLCUser? = UserDefaultsPercistenceManager.retrieveItemFromUserDefaults()
        
        return CalculationDataFirebaseRecord(
            calculationDate: data.calculationDate,
            name: user?.fio ?? "",
            email: user?.email ?? "",
            mobilePhone: user?.mobilePhone ?? "",
            userCalculationID: data.id,
            countryFrom: data.countryFrom.rawValue,
            countryTo: data.countryTo.rawValue,
            deliveryType: data.deliveryType.rawValue,
            deliveryTypeCode: data.deliveryTypeCode,
            departureAirport: data.departureAirport,
            fromLocationCode: data.fromLocationCode,
            fromLocation: data.fromLocation,
            toLocation: data.toLocation,
            toLocationCode: data.toLocationCode,
            goodsType: data.goodsType.rawValue,
            volume: data.volume,
            weight: data.weight,
            invoiceAmount: data.invoiceAmount,
            invoiceCurrency: data.invoiceCurrency,
            needCustomClearance: data.needCustomClearance,
            isConfirmed: false,
            exchangeRate: data.exchangeRate,
            totalPriceData: totalPriceData
        )
    }
}

extension FirebaseManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Task {
            do {
                try await messaging.token()
                try await Messaging.messaging().subscribe(toTopic: "flcCalculatorLive")
            } catch {
                print(error)
            }
        }
    }
}
