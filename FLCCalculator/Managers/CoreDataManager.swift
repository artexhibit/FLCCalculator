import Foundation
import CoreData

struct CoreDataManager {
    private static let context = Persistence.shared.container.viewContext
    
    static func loadCalculations(sortBy key: String = "id", ascending: Bool = true) -> [Calculation]? {
        let request: NSFetchRequest<Calculation> = Calculation.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: key, ascending: ascending)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print(FLCError.unableToFetchCategories)
            return nil
        }
    }
    
    static func getCalculation(withID id: Int32) -> Calculation? {
        let request: NSFetchRequest<Calculation> = Calculation.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            return try context.fetch(request).first
        } catch {
            print(FLCError.unableToFetchCategories)
            return nil
        }
    }
    
    static func deleteCalculation(withID id: Int32) {
        guard let calculationToDelete = getCalculation(withID: id) else { return }
        
        if let calculationResults = calculationToDelete.result as? Set<CalculationResult> {
            for calculationResult in calculationResults { context.delete(calculationResult) }
        }
        context.delete(calculationToDelete)
        Persistence.shared.saveContext()
    }
    
    static func reassignCalculationsId() {
        guard let calculations = loadCalculations() else { return }
        for (index, calc) in calculations.enumerated() { calc.id = Int32(index + 1) }
        Persistence.shared.saveContext()
    }
    
    static func createCalculationRecord(with calculationData: CalculationData, totalPriceData: [TotalPriceData], pickedLogisticsType: FLCLogisticsType, isConfirmed: Bool = false) {
        let calc = Calculation(context: context)
        
        calc.calculationDate = Date()
        calc.calculationConfirmDate = Date()
        calc.id = Int32(CoreDataManager.loadCalculations()?.count ?? 0)
        calc.toLocation = calculationData.toLocation
        calc.toLocationCode = calculationData.toLocationCode
        calc.deliveryType = calculationData.deliveryType
        calc.goodsType = calculationData.goodsType
        calc.fromLocation = calculationData.fromLocation
        calc.deliveryTypeCode = calculationData.deliveryTypeCode
        calc.countryTo = calculationData.countryTo
        calc.countryFrom = calculationData.countryFrom
        calc.weight = calculationData.weight
        calc.volume = calculationData.volume
        calc.invoiceAmount = calculationData.invoiceAmount
        calc.invoiceCurrency = calculationData.invoiceCurrency
        calc.totalPrice = totalPriceData.first(where: { $0.isFavourite })?.totalPrice
        calc.isConfirmed = isConfirmed
        calc.needCustomsClearance = calculationData.needCustomClearance
        
        for totalPriceDataItem in totalPriceData {
            let calcResult = CalculationResult(context: context)
            
            calcResult.logisticsType = totalPriceDataItem.logisticsType.rawValue
            calcResult.totalPrice = totalPriceDataItem.totalPrice
            calcResult.totalTime = totalPriceDataItem.totalTime
            calcResult.cargoHandling = totalPriceDataItem.cargoHandling
            calcResult.customsClearance = totalPriceDataItem.customsClearance
            calcResult.customsWarehousePrice = totalPriceDataItem.customsWarehousePrice
            calcResult.deliveryFromWarehousePrice = totalPriceDataItem.deliveryFromWarehousePrice
            calcResult.deliveryFromWarehouseTime = totalPriceDataItem.deliveryFromWarehouseTime
            calcResult.deliveryToWarehousePrice = totalPriceDataItem.deliveryToWarehousePrice
            calcResult.deliveryToWarehouseTime = totalPriceDataItem.deliveryToWarehouseTime
            calcResult.russianDeliveryPrice = totalPriceDataItem.russianDeliveryPrice
            calcResult.russianDeliveryTime = totalPriceDataItem.russianDeliveryTime
            calcResult.groupageDocs = totalPriceDataItem.groupageDocs
            calcResult.insurance = totalPriceDataItem.insurance
            calcResult.isFavourite = totalPriceDataItem.isFavourite
            calcResult.isConfirmed = (pickedLogisticsType == totalPriceDataItem.logisticsType) && isConfirmed ? true : false
            
            calcResult.calculation = calc
            calc.addToResult(calcResult)
        }
        Persistence.shared.saveContext()
    }
}
