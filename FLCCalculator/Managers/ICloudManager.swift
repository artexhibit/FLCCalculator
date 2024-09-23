import Foundation
import CloudKit

class ICloudManager {
    static let shared = ICloudManager()
    private let database = CKContainer.default().publicCloudDatabase
    private let recordType = "Calculation"
    
    private init() {}
    
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
            let (fetchedRecordIDs, nextCursor) = try await performQuery(recordType: recordType, predicate: NSPredicate(value: true), cursor: cursor)
            
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
    
    private func encodeCalculationResults(calculation: Calculation) -> Data? {
        guard let results = calculation.result as? Set<CalculationResult> else { return nil }
        let resultsArray = Array(results).map({ $0.toDTO() })
        return try? JSONEncoder().encode(resultsArray)
    }
}
