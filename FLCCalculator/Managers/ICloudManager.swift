import Foundation
import CloudKit

class ICloudManager {
    static let shared = ICloudManager()
    private let database = CKContainer.default().publicCloudDatabase
    
    private init() {}
    
    func uploadCalculationsToCloudKit() {
        guard let caclulations = CoreDataManager.loadCalculations() else { return }
        
        caclulations.forEach { calculation in
            let recordID = CKRecord.ID(recordName: UUID().uuidString)
            let record = CKRecord(recordType: "Calculation", recordID: recordID)
            configureRecordFields(for: record, with: calculation)
            saveRecord(record)
        }
    }
    
    private func saveRecord(_ record: CKRecord) {
        database.save(record) { savedRecord, error in
            if savedRecord != nil && error == nil {
                print("Record saved successfully")
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
    }
}
