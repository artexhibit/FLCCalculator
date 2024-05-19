import Foundation
import CoreData

struct CoreDataManager {
    private static let context = Persistence.shared.container.viewContext
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    
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
    
    static func  getCalculationResults(forCalculationID id: Int32) -> Set<CalculationResult>? {
        guard let calculation = CoreDataManager.getCalculation(withID: id) else { return nil }
        return calculation.result as? Set<CalculationResult>
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
        calc.isConfirmed = isConfirmed
        calc.totalPrice = totalPriceData.first(where: { $0.isConfirmed })?.totalPrice
        calc.needCustomsClearance = calculationData.needCustomClearance
        calc.exchangeRate = calculationData.exchangeRate
        
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
            calcResult.insurancePercentage = totalPriceDataItem.insurancePercentage ?? 0
            calcResult.insuranceRatio = totalPriceDataItem.insurancePercentage ?? 0
            calcResult.cargoHandlingPricePerKg = totalPriceDataItem.cargoHandlingPricePerKg ?? 0
            calcResult.cargoHandlingMinPrice = totalPriceDataItem.cargoHandlingMinPrice ?? 0
            calcResult.isConfirmed = (pickedLogisticsType == totalPriceDataItem.logisticsType) && isConfirmed ? true : false
            
            calcResult.calculation = calc
            calc.addToResult(calcResult)
        }
        Persistence.shared.saveContext()
    }
    
    static func updateItemsInCoreData<T: CoreDataStorable>(items: [T]) -> [T]? {
        let deletionResult = deleteAllItems(ofType: T.self)
        if deletionResult {
            storeItemsToCoreData(items: items)
            return retrieveItemsFromCoreData()
        }
        return nil
    }
    
    static func updateItemInCoreData<T: CoreDataStorable>(item: T) -> T? {
        let deletionResult = deleteAllItems(ofType: T.self)
        
        if deletionResult {
            storeItemToCoreData(item: item)
            return retrieveItemFromCoreData()
        }
        return nil
    }
    
    static func deleteAllItems<T: CoreDataStorable>(ofType type: T.Type) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.coreDataKey)
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 { return true }
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)
            try context.save()
            return true
        } catch {
            print(FLCError.unableToDeleteItemsInCoreData.rawValue)
            return false
        }
    }
    
    static func retrieveItemsFromCoreData<T: CoreDataStorable>() -> [T]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.coreDataKey)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            guard let result = results?.first, let data = result.value(forKey: Keys.cdDataAttribute) as? Data else { return nil }
            let items = try decoder.decode([T].self, from: data)
            return items
        } catch {
            print(FLCError.unableToFetchOrDecodeFromCoreData.rawValue)
            return nil
        }
    }
    
    static func retrieveItemFromCoreData<T: CoreDataStorable>() -> T? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.coreDataKey)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            
            guard let result = results?.first, let data = result.value(forKey: Keys.cdDataAttribute) as? Data else { return nil }
            let item = try decoder.decode(T.self, from: data)
            return item
        } catch {
            print(FLCError.unableToFetchOrDecodeFromCoreData.rawValue)
            return nil
        }
    }
    
    private static func storeItemsToCoreData<T: CoreDataStorable>(items: [T]) {
        let entity = NSEntityDescription.entity(forEntityName: T.coreDataKey, in: context)!
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        do {
            let data = try encoder.encode(items)
            managedObject.setValue(data, forKey: Keys.cdDataAttribute)
            try context.save()
        } catch {
            print(FLCError.unableToEncodeOrSavetoCoreData.rawValue)
        }
    }
    
    private static func storeItemToCoreData<T: CoreDataStorable>(item: T) {
        let entity = NSEntityDescription.entity(forEntityName: T.coreDataKey, in: context)!
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        do {
            let data = try encoder.encode(item)
            managedObject.setValue(data, forKey: Keys.cdDataAttribute)
            try context.save()
        } catch {
            print(FLCError.unableToEncodeOrSavetoCoreData.rawValue)
        }
    }
}
