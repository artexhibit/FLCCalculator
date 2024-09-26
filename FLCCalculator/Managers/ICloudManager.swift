import Foundation
import CloudKit

protocol ICloudManagerDelegate: AnyObject {
    func calculationsUpdated()
    func iCloudToggleSwitched()
}

extension ICloudManagerDelegate {
    func calculationsUpdated() {}
    func iCloudToggleSwitched() {}
}

class ICloudManager: NSObject {
    static let shared = ICloudManager()
    private let database = CKContainer.default().publicCloudDatabase
    private let recordType = "Calculation"
    private let predicate = NSPredicate(value: true)
    
    weak var delegate: ICloudManagerDelegate?
    
    override init() {
        super.init()
        NotificationsManager.cloudKitKeyValueStoreValueDidChange(self, selector: #selector(cloudKitKeyValueStoreValueDidChange(_:)))
    }
    
    func subscribeToCalculationChangesInICloud() {
        Task {
            do {
                try await subscribeToCalculationChange(ofType: .creation)
                try await subscribeToCalculationChange(ofType: .deletion)
                try await subscribeToCalculationChange(ofType: .update)
            } catch {
                throw FLCError.failedToSubscribeToICloudChanges
            }
        }
    }
    
    private func subscribeToCalculationChange(ofType type: CalculationChangeICloudType) async throws {
        let subscription = CKQuerySubscription(recordType: recordType, predicate: predicate, subscriptionID: type.rawValue, options: type.subscriptionOptions)
        let notificationInfo = CKSubscription.NotificationInfo()
        
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        try await database.save(subscription)
    }
    
    func checkForCloudKitChangeEvent(from userInfo: [AnyHashable : Any]) -> CalculationICloudChangeEvent {
        guard let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) else { return .unknown }
        guard let subscriptionID = notification.subscriptionID else { return .unknown }
        guard let queryNotification = CKNotification(fromRemoteNotificationDictionary: userInfo) as? CKQueryNotification else { return .unknown }
        guard let recordID = queryNotification.recordID else { return .unknown }
        
        switch subscriptionID {
        case CalculationChangeICloudType.creation.rawValue: return handleCreationNotification(recordID: recordID)
        case CalculationChangeICloudType.deletion.rawValue: return handleDeletionNotification(recordID: recordID)
        case CalculationChangeICloudType.update.rawValue: return handleUpdateNotification(recordID: recordID)
        default: return .unknown
        }
    }
    
    private func handleCreationNotification(recordID: CKRecord.ID) -> CalculationICloudChangeEvent {
        Task {
            do {
                guard let record = try await fetchRecords([recordID]).first else { return }
                
                await MainActor.run {
                    createCalculationsFromRecords(records: [record])
                    CoreDataManager.reassignCalculationsID()
                    delegate?.calculationsUpdated()
                }
            }
        }
        return .creation
    }
    
    private func handleUpdateNotification(recordID: CKRecord.ID) -> CalculationICloudChangeEvent {
        Task {
            do {
                guard let updatedRecordUUID = UUID(uuidString: recordID.recordName) else { return }
                guard let record = try await fetchRecords([recordID]).first else { return }
                
                await MainActor.run {
                    CoreDataManager.deleteCalculation(withID: updatedRecordUUID)
                    createCalculationsFromRecords(records: [record])
                    delegate?.calculationsUpdated()
                }
            }
        }
        return .update
    }

    
    private func handleDeletionNotification(recordID: CKRecord.ID) -> CalculationICloudChangeEvent {
        guard let deletedRecordUUID = UUID(uuidString: recordID.recordName) else { return .unknown }
        
        CoreDataManager.deleteCalculation(withID: deletedRecordUUID)
        CoreDataManager.reassignCalculationsID()
        delegate?.calculationsUpdated()
        return .deletion
    }
    
    func uploadCalculationsToCloud() async throws {
        guard let calculations = CoreDataManager.loadCalculations()?.filter({ $0.cloudID == nil }), calculations.count > 0 else { return }
        
        await withThrowingTaskGroup(of: Void.self) { group in
            for calculation in calculations {
                group.addTask { [weak self] in
                    guard let self = self else { return }
                    
                    let newCloudID = UUID()
                    let record = CKRecord(recordType: self.recordType, recordID: CKRecord.ID(recordName: newCloudID.uuidString))
                    
                    await MainActor.run {
                        calculation.cloudID = newCloudID
                        self.configureRecordFields(for: record, with: calculation)
                    }
                    
                    do {
                        try await self.saveRecord(record)
                    } catch {
                        await MainActor.run { calculation.cloudID = nil }
                        throw error
                    }
                }
            }
        }
        Persistence.shared.saveContext()
    }
    
    func deleteRecordsFromCloud() async throws {
        var cursor: CKQueryOperation.Cursor? = nil
        
        repeat {
            let (fetchedRecordIDs, nextCursor) = try await performQuery(recordType: recordType, predicate: predicate, cursor: cursor)
            
            if !fetchedRecordIDs.isEmpty { try await deleteRecords(recordIDs: fetchedRecordIDs) }
            cursor = nextCursor
        } while cursor != nil
    }
    
    private func performQuery(recordType: String, predicate: NSPredicate, cursor: CKQueryOperation.Cursor?) async throws -> ([CKRecord.ID], CKQueryOperation.Cursor?) {
        return try await withCheckedThrowingContinuation { continuation in
            var recordIDs: [CKRecord.ID] = []
            let batchSize = 400
            
            let query = CKQuery(recordType: recordType, predicate: predicate)
            let operation: CKQueryOperation
            
            if let cursor = cursor {
                operation = CKQueryOperation(cursor: cursor)
            } else {
                operation = CKQueryOperation(query: query)
            }
            
            operation.resultsLimit = batchSize
            operation.recordMatchedBlock = { recordID, result in
                switch result {
                case .success(_): recordIDs.append(recordID)
                case .failure(_): break
                }
            }
            
            operation.queryResultBlock = { result in
                switch result {
                case .success(let cursor): continuation.resume(returning: (recordIDs, cursor))
                case .failure(let error): continuation.resume(throwing: error)
                }
            }
            self.database.add(operation)
        }
    }
    
    private func deleteRecords(recordIDs: [CKRecord.ID]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let modifyOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
            modifyOperation.isAtomic = false
            
            modifyOperation.perRecordDeleteBlock = { recordID, result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        guard let deletedRecordUUID = UUID(uuidString: recordID.recordName) else { return }
                        CoreDataManager.resetCalculationFor(cloudID: deletedRecordUUID)
                    }
                case .failure(_): break
                }
            }
            
            modifyOperation.modifyRecordsResultBlock = { result in
                switch result {
                case .success(_): continuation.resume(returning: ())
                case .failure(let error): continuation.resume(throwing: error)
                }
            }
            self.database.add(modifyOperation)
        }
    }
    
    private func saveRecord(_ record: CKRecord) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            database.save(record) { savedRecord, error in
                
                if let error = error, savedRecord == nil {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
    
    private func fetchRecords(_ recordIDs: [CKRecord.ID]) async throws -> [CKRecord] {
        return try await withCheckedThrowingContinuation { continuation in
            database.fetch(withRecordIDs: recordIDs, completionHandler: { result in
                switch result {
                case .success(let recordsDict):
                    var records = [CKRecord]()
                    for (_, recordResult) in recordsDict {
                        switch recordResult {
                        case .success(let record): records.append(record)
                        case .failure(_): break
                        }
                    }
                    continuation.resume(returning: records)
                case .failure(let error): continuation.resume(throwing: error)
                }
            })
        }
    }
    
    private func configureRecordFields(for record: CKRecord, with calculation: Calculation) {
        record.setValue(calculation.calculationConfirmDate, forKey: "calculationConfirmDate")
        record.setValue(calculation.calculationDate, forKey: "calculationDate")
        record.setValue(calculation.countryFrom, forKey: "countryFrom")
        record.setValue(calculation.countryTo, forKey: "countryTo")
        record.setValue(calculation.deliveryType, forKey: "deliveryType")
        record.setValue(calculation.deliveryTypeCode, forKey: "deliveryTypeCode")
        record.setValue(calculation.departureAirport, forKey: "departureAirport")
        record.setValue(calculation.exchangeRate, forKey: "exchangeRate")
        record.setValue(calculation.fromLocation, forKey: "fromLocation")
        record.setValue(calculation.fromLocationCode, forKey: "fromLocationCode")
        record.setValue(calculation.goodsType, forKey: "goodsType")
        record.setValue(calculation.id, forKey: "id")
        record.setValue(calculation.invoiceAmount, forKey: "invoiceAmount")
        record.setValue(calculation.invoiceCurrency, forKey: "invoiceCurrency")
        record.setValue(calculation.isConfirmed, forKey: "isConfirmed")
        record.setValue(calculation.logisticsTypes, forKey: "logisticsTypes")
        record.setValue(calculation.needCustomsClearance, forKey: "needCustomsClearance")
        record.setValue(calculation.toLocation, forKey: "toLocation")
        record.setValue(calculation.toLocationCode, forKey: "toLocationCode")
        record.setValue(calculation.totalPrice, forKey: "totalPrice")
        record.setValue(calculation.volume, forKey: "volume")
        record.setValue(calculation.weight, forKey: "weight")
        
        if let results = encodeCalculationResults(calculation: calculation) {
            record.setValue(results, forKey: "calculationResultsData")
        } else {
            record.setValue([], forKey: "calculationResultsData")
        }
    }
    
    private func createCalculationsFromRecords(records: [CKRecord]) {
        for record in records {
            let calc = Calculation(context: CoreDataManager.context)
            calc.calculationDate = record.value(forKey: "calculationDate") as? Date
            calc.calculationConfirmDate = record.value(forKey: "calculationConfirmDate") as? Date
            calc.id = record.value(forKey: "id") as? Int32 ?? Int32()
            calc.toLocation = record.value(forKey: "toLocation") as? String
            calc.toLocationCode = record.value(forKey: "toLocationCode") as? String
            calc.deliveryType = record.value(forKey: "deliveryType") as? String
            calc.goodsType = record.value(forKey: "goodsType") as? String
            calc.fromLocation = record.value(forKey: "fromLocation") as? String
            calc.departureAirport = record.value(forKey: "departureAirport") as? String
            calc.fromLocationCode = record.value(forKey: "fromLocationCode") as? String
            calc.deliveryTypeCode = record.value(forKey: "deliveryTypeCode") as? String
            calc.countryTo = record.value(forKey: "countryTo") as? String
            calc.countryFrom = record.value(forKey: "countryFrom") as? String
            calc.weight = record.value(forKey: "weight") as? Double ?? 0
            calc.volume = record.value(forKey: "volume") as? Double ?? 0
            calc.invoiceAmount = record.value(forKey: "invoiceAmount") as? Double ?? 0
            calc.invoiceCurrency = record.value(forKey: "invoiceCurrency") as? String
            calc.isConfirmed = record.value(forKey: "isConfirmed") as? Bool ?? false
            calc.totalPrice = record.value(forKey: "totalPrice") as? String
            calc.needCustomsClearance = record.value(forKey: "needCustomsClearance") as? Bool ?? true
            calc.exchangeRate = record.value(forKey: "exchangeRate") as? Double ?? 0
            calc.logisticsTypes = record.value(forKey: "logisticsTypes") as? Data
            calc.cloudID = UUID(uuidString: record.recordID.recordName)
            
            let calcResultsData = record.value(forKey: "calculationResultsData") as? Data
            guard let calcResultsDTO = decodeCalculationResults(data: calcResultsData) else { continue }
            
            for dtoResult in calcResultsDTO {
                let calcResult = CalculationResult(context: CoreDataManager.context)
                
                calcResult.logisticsType = dtoResult.logisticsType.rawValue
                calcResult.totalPrice = dtoResult.totalPrice
                calcResult.totalTime = dtoResult.totalTime
                calcResult.cargoHandling = dtoResult.cargoHandling
                calcResult.customsClearance = dtoResult.customsClearance
                calcResult.customsWarehousePrice = dtoResult.customsWarehousePrice
                calcResult.deliveryFromWarehousePrice = dtoResult.deliveryFromWarehousePrice
                calcResult.deliveryFromWarehouseTime = dtoResult.deliveryFromWarehouseTime
                calcResult.deliveryToWarehousePrice = dtoResult.deliveryToWarehousePrice
                calcResult.deliveryToWarehouseTime = dtoResult.deliveryToWarehouseTime
                calcResult.russianDeliveryPrice = dtoResult.russianDeliveryPrice
                calcResult.russianDeliveryTime = dtoResult.russianDeliveryTime
                calcResult.groupageDocs = dtoResult.groupageDocs
                calcResult.insurance = dtoResult.insurance
                calcResult.insurancePercentage = dtoResult.insurancePercentage ?? 0
                calcResult.insuranceRatio = dtoResult.insuranceRatio ?? 0
                calcResult.insuranceAgentVisit = dtoResult.insuranceAgentVisit ?? 0
                calcResult.minLogisticsProfit = dtoResult.minLogisticsProfit ?? 0
                calcResult.cargoHandlingPricePerKg = dtoResult.cargoHandlingPricePerKg ?? 0
                calcResult.cargoHandlingMinPrice = dtoResult.cargoHandlingMinPrice ?? 0
                calcResult.isConfirmed = dtoResult.isConfirmed
                
                calcResult.calculation = calc
                calc.addToResult(calcResult)
            }
        }
        Persistence.shared.saveContext()
    }
    
    private func encodeCalculationResults(calculation: Calculation) -> Data? {
        guard let results = calculation.result as? Set<CalculationResult> else { return nil }
        let resultsArray = Array(results).map({ $0.toDTO() })
        return try? JSONEncoder().encode(resultsArray)
    }
    
    private func decodeCalculationResults(data: Data?) -> [TotalPriceData]? {
        guard let data else { return nil }
        return try? JSONDecoder().decode([TotalPriceData].self, from: data)
    }
    
    @objc func cloudKitKeyValueStoreValueDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let reason = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int else { return }
        
        if reason == NSUbiquitousKeyValueStoreServerChange || reason == NSUbiquitousKeyValueStoreInitialSyncChange {
            guard let changedKeys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] else { return }
            
            for key in changedKeys {
                if key == Keys.iCloudSyncEnabled { delegate?.iCloudToggleSwitched() }
            }
        }
    }
}
