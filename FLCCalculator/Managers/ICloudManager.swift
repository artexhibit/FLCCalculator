import Foundation
import CloudKit

protocol ICloudManagerDelegate: AnyObject {
    func calculationsUpdated()
}

class ICloudManager {
    static let shared = ICloudManager()
    private let database = CKContainer.default().privateCloudDatabase
    private let recordType = "Calculation"
    private let predicate = NSPredicate(value: true)
    private let batchSize = 400

    weak var delegate: ICloudManagerDelegate?
    
    private init() {}
    
    func isICloudAvailable() async -> Bool {
        do {
            let accountStatus = try await CKContainer.default().accountStatus()
            return accountStatus == .available
        } catch {
            return false
        }
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
    
    private func subscribeToCalculationChange(ofType type: FLCCKQuerySubscriptionType) async throws {
        let subscription = CKQuerySubscription(recordType: recordType, predicate: predicate, subscriptionID: type.rawValue, options: type.subscriptionOptions)
        let notificationInfo = CKSubscription.NotificationInfo()
        
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        try await database.save(subscription)
    }
    
    func checkForCloudKitChangeEvent(from userInfo: [AnyHashable : Any]) -> FLCICloudChangeEvent {
        guard UserDefaultsManager.iCloudSyncEnabled else { return .unknown }
        guard let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) else { return .unknown }
        guard let subscriptionID = notification.subscriptionID else { return .unknown }
        guard let queryNotification = CKNotification(fromRemoteNotificationDictionary: userInfo) as? CKQueryNotification else { return .unknown }
        guard let recordID = queryNotification.recordID else { return .unknown }
        
        switch subscriptionID {
        case FLCCKQuerySubscriptionType.creation.rawValue: return handleCreationNotification(recordID: recordID)
        case FLCCKQuerySubscriptionType.deletion.rawValue: return handleDeletionNotification(recordID: recordID)
        case FLCCKQuerySubscriptionType.update.rawValue: return handleUpdateNotification(recordID: recordID)
        default: return .unknown
        }
    }
    
    private func handleCreationNotification(recordID: CKRecord.ID) -> FLCICloudChangeEvent {
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
    
    private func handleUpdateNotification(recordID: CKRecord.ID) -> FLCICloudChangeEvent {
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
    
    private func handleDeletionNotification(recordID: CKRecord.ID) -> FLCICloudChangeEvent {
        Task {
            do {
                guard let deletedRecordUUID = UUID(uuidString: recordID.recordName) else { return }
                
                await MainActor.run {
                    CoreDataManager.deleteCalculation(withID: deletedRecordUUID)
                    CoreDataManager.reassignCalculationsID()
                    delegate?.calculationsUpdated()
                }
            }
        }
        return .deletion
    }
    
    func uploadCalculationsToCloud() async throws {
        guard let calculations = try await getCalculationsToUpload(), calculations.count > 0, UserDefaultsManager.iCloudSyncEnabled else { return }
        
        await withThrowingTaskGroup(of: Void.self) { group in
            for calculation in calculations {
                group.addTask { [weak self] in
                    guard let self = self else { return }
                    
                    let cloudIDToAssign = calculation.cloudID != nil ? calculation.cloudID ?? UUID() : UUID()
                    let record = CKRecord(recordType: self.recordType, recordID: CKRecord.ID(recordName: cloudIDToAssign.uuidString))
                    
                    await MainActor.run { calculation.cloudID = cloudIDToAssign }
                    self.configureRecordFields(for: record, with: calculation)
                    
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
    
    func downloadMissingCalculationsFromCloud() async throws {
        guard let recordIDsToDownload = try await getRecordIDsToDownload() else { return }
        let records = try await fetchRecords(recordIDsToDownload)
        
        await MainActor.run {
            createCalculationsFromRecords(records: records)
            CoreDataManager.reassignCalculationsID()
        }
    }
    
    func manageCalculationFromCloud(with cloudID: UUID? = nil, action: FLCICloudManageAction) {
        guard UserDefaultsManager.iCloudSyncEnabled else { return }
        
        Task {
            do {
                if action == .delete || action == .update {
                    guard let cloudID else { return }
                    let recordID = CKRecord.ID(recordName: cloudID.uuidString)
                    try await deleteRecords(recordIDs: [recordID])
                }
                
                if action == .create || action == .update { try await uploadCalculationsToCloud() }
                if action == .sync {
                    try await Task.sleep(for: .seconds(2))
                    try await uploadCalculationsToCloud()
                    try await downloadMissingCalculationsFromCloud()
                    await MainActor.run { delegate?.calculationsUpdated() }
                }
            }
        }
    }
    
    private func getCalculationsToUpload() async throws -> [Calculation]? {
        guard let storedCalculations = CoreDataManager.loadCalculations() else { return nil }
        guard let cloudRecordIDs = try await getAllRecordIDs() else { return storedCalculations }
        let cloudRecordsUUIDs = Set(cloudRecordIDs.compactMap({ UUID(uuidString: $0.recordName) }))
        
        return storedCalculations.filter({ $0.cloudID.map { !cloudRecordsUUIDs.contains($0) } ?? true })
    }
    
    private func getRecordIDsToDownload() async throws -> [CKRecord.ID]? {
        guard let storedCalculations = CoreDataManager.loadCalculations() else { return nil }
        guard let cloudRecordIDs = try await getAllRecordIDs() else { return nil }
        let storedCalculationsIDs = Set(storedCalculations.compactMap({ $0.cloudID }))
        let missingRecordIDs = cloudRecordIDs.filter { UUID(uuidString: $0.recordName).map { !storedCalculationsIDs.contains($0) } ?? true }

        return missingRecordIDs.isEmpty ? nil : missingRecordIDs
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
        var allRecords: [CKRecord] = []
        var currentIndex = 0
        let totalRecords = recordIDs.count
        
        while currentIndex < totalRecords {
            let endIndex = min(currentIndex + batchSize, totalRecords)
            let batch = Array(recordIDs[currentIndex..<endIndex])
            let records = try await fetchBatch(batch)
            allRecords.append(contentsOf: records)
            currentIndex += batchSize
        }
        return allRecords
    }
    
    private func fetchBatch(_ recordIDs: [CKRecord.ID]) async throws -> [CKRecord] {
        return try await withCheckedThrowingContinuation { continuation in
            database.fetch(withRecordIDs: recordIDs, completionHandler: { result in
                switch result {
                case .success(let recordsDict):
                    var records = [CKRecord]()
                    for (_, recordResult) in recordsDict {
                        switch recordResult {
                        case .success(let record): records.append(record)
                        case .failure(let error): continuation.resume(throwing: error)
                        }
                    }
                    continuation.resume(returning: records)
                case .failure(let error): continuation.resume(throwing: error)
                }
            })
        }
    }
    
    private func getAllRecordIDs() async throws -> [CKRecord.ID]? {
        var recordIDs: [CKRecord.ID] = []
        var cursor: CKQueryOperation.Cursor? = nil

        repeat {
            let (fetchedRecordIDs, nextCursor) = try await performQuery(recordType: recordType, predicate: predicate, cursor: cursor)
            recordIDs.append(contentsOf: fetchedRecordIDs)
            cursor = nextCursor
        } while cursor != nil
        return recordIDs.isEmpty ? nil : recordIDs
    }
    
    private func configureRecordFields(for record: CKRecord, with calculation: Calculation) {
        record.setValue(calculation.calculationConfirmDate, forKey: ICloudManagerStrings.calculationConfirmDate)
        record.setValue(calculation.calculationDate, forKey: ICloudManagerStrings.calculationDate)
        record.setValue(calculation.countryFrom, forKey: ICloudManagerStrings.countryFrom)
        record.setValue(calculation.countryTo, forKey: ICloudManagerStrings.countryTo)
        record.setValue(calculation.deliveryType, forKey: ICloudManagerStrings.deliveryType)
        record.setValue(calculation.deliveryTypeCode, forKey: ICloudManagerStrings.deliveryTypeCode)
        record.setValue(calculation.departureAirport, forKey: ICloudManagerStrings.departureAirport)
        record.setValue(calculation.exchangeRate, forKey: ICloudManagerStrings.exchangeRate)
        record.setValue(calculation.fromLocation, forKey: ICloudManagerStrings.fromLocation)
        record.setValue(calculation.fromLocationCode, forKey: ICloudManagerStrings.fromLocationCode)
        record.setValue(calculation.goodsType, forKey: ICloudManagerStrings.goodsType)
        record.setValue(calculation.id, forKey: ICloudManagerStrings.id)
        record.setValue(calculation.invoiceAmount, forKey: ICloudManagerStrings.invoiceAmount)
        record.setValue(calculation.invoiceCurrency, forKey: ICloudManagerStrings.invoiceCurrency)
        record.setValue(calculation.isConfirmed, forKey: ICloudManagerStrings.isConfirmed)
        record.setValue(calculation.logisticsTypes, forKey: ICloudManagerStrings.logisticsTypes)
        record.setValue(calculation.needCustomsClearance, forKey: ICloudManagerStrings.needCustomsClearance)
        record.setValue(calculation.toLocation, forKey: ICloudManagerStrings.toLocation)
        record.setValue(calculation.toLocationCode, forKey: ICloudManagerStrings.toLocationCode)
        record.setValue(calculation.totalPrice, forKey: ICloudManagerStrings.totalPrice)
        record.setValue(calculation.volume, forKey: ICloudManagerStrings.volume)
        record.setValue(calculation.weight, forKey: ICloudManagerStrings.weight)
        
        if let results = encodeCalculationResults(calculation: calculation) {
            record.setValue(results, forKey: ICloudManagerStrings.calculationResultsData)
        } else {
            record.setValue([], forKey: ICloudManagerStrings.calculationResultsData)
        }
    }

    private func createCalculationsFromRecords(records: [CKRecord]) {
        for record in records {
            let calc = Calculation(context: CoreDataManager.context)
            calc.calculationDate = record.value(forKey: ICloudManagerStrings.calculationDate) as? Date
            calc.calculationConfirmDate = record.value(forKey: ICloudManagerStrings.calculationConfirmDate) as? Date
            calc.id = record.value(forKey: ICloudManagerStrings.id) as? Int32 ?? Int32()
            calc.toLocation = record.value(forKey: ICloudManagerStrings.toLocation) as? String
            calc.toLocationCode = record.value(forKey: ICloudManagerStrings.toLocationCode) as? String
            calc.deliveryType = record.value(forKey: ICloudManagerStrings.deliveryType) as? String
            calc.goodsType = record.value(forKey: ICloudManagerStrings.goodsType) as? String
            calc.fromLocation = record.value(forKey: ICloudManagerStrings.fromLocation) as? String
            calc.departureAirport = record.value(forKey: ICloudManagerStrings.departureAirport) as? String
            calc.fromLocationCode = record.value(forKey: ICloudManagerStrings.fromLocationCode) as? String
            calc.deliveryTypeCode = record.value(forKey: ICloudManagerStrings.deliveryTypeCode) as? String
            calc.countryTo = record.value(forKey: ICloudManagerStrings.countryTo) as? String
            calc.countryFrom = record.value(forKey: ICloudManagerStrings.countryFrom) as? String
            calc.weight = record.value(forKey: ICloudManagerStrings.weight) as? Double ?? 0
            calc.volume = record.value(forKey: ICloudManagerStrings.volume) as? Double ?? 0
            calc.invoiceAmount = record.value(forKey: ICloudManagerStrings.invoiceAmount) as? Double ?? 0
            calc.invoiceCurrency = record.value(forKey: ICloudManagerStrings.invoiceCurrency) as? String
            calc.isConfirmed = record.value(forKey: ICloudManagerStrings.isConfirmed) as? Bool ?? false
            calc.totalPrice = record.value(forKey: ICloudManagerStrings.totalPrice) as? String
            calc.needCustomsClearance = record.value(forKey: ICloudManagerStrings.needCustomsClearance) as? Bool ?? true
            calc.exchangeRate = record.value(forKey: ICloudManagerStrings.exchangeRate) as? Double ?? 0
            calc.logisticsTypes = record.value(forKey: ICloudManagerStrings.logisticsTypes) as? Data
            calc.cloudID = UUID(uuidString: record.recordID.recordName)
            
            let calcResultsData = record.value(forKey: ICloudManagerStrings.calculationResultsData) as? Data
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
}
