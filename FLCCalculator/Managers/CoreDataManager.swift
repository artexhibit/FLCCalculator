import Foundation
import CoreData

struct CoreDataManager {
    static let context = Persistence.shared.container.viewContext
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    
    static func loadCalculations(sortBy key: String = "calculationDate", ascending: Bool = true) -> [Calculation]? {
        let request: NSFetchRequest<Calculation> = Calculation.fetchRequest()
        let mainSortDescriptor = NSSortDescriptor(key: key, ascending: ascending)
        
        request.sortDescriptors = [mainSortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print(FLCError.unableToFetchCategories)
            return nil
        }
    }
    
    static func loadCalculationsWithCondition(condition: String) -> [Calculation]? {
        let fetchRequest: NSFetchRequest<Calculation> = Calculation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: condition)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print(FLCError.unableToFetchCategories)
            return nil
        }
    }
    
    static func getCalculation<T>(withID id: T) -> Calculation? {
        let request: NSFetchRequest<Calculation> = Calculation.fetchRequest()
        
        if let id = id as? Int32 {
            request.predicate = NSPredicate(format: "id == %d", id)
        } else if let id = id as? UUID {
            request.predicate = NSPredicate(format: "cloudID == %@", id as NSUUID)
        } else {
            return nil
        }
        return try? context.fetch(request).first
    }
    
    static func getCalculationResults(forCalculationID id: Int32) -> Set<CalculationResult>? {
        guard let calculation = CoreDataManager.getCalculation(withID: id) else { return nil }
        return calculation.result as? Set<CalculationResult>
    }
    
    static func deleteCalculation<T>(withID id: T) {
        guard let calculationToDelete = getCalculation(withID: id) else { return }
        context.delete(calculationToDelete)
        Persistence.shared.saveContext()
    }
    
    static func reassignCalculationsID() {
        guard let calculations = loadCalculations() else { return }
        for (index, calc) in calculations.enumerated() { calc.id = Int32(index + 1) }
        Persistence.shared.saveContext()
    }
    
    static func createCalculationRecord(with calculationData: CalculationData, totalPriceData: [TotalPriceData], pickedLogisticsType: FLCLogisticsType, isConfirmed: Bool = false) {
        let calc = Calculation(context: context)
        let fromLocation = FLCCountryWarehouse(rawValue: calculationData.fromLocation).map { $0 != .russia ? $0.localizedDescription : calculationData.fromLocation } ?? calculationData.fromLocation
        let toLocation = FLCCountryWarehouse(localizedString: calculationData.toLocation) == .russia ? FLCCountryWarehouse(localizedString: calculationData.toLocation)?.rawValue ?? "" : calculationData.toLocation
        
        calc.calculationDate = Date()
        calc.calculationConfirmDate = Date()
        calc.cloudID = calculationData.cloudID
        calc.id = Int32(CoreDataManager.loadCalculations()?.count ?? 0)
        calc.toLocation = toLocation
        calc.toLocationCode = calculationData.toLocationCode
        calc.deliveryType = calculationData.deliveryType.rawValue
        calc.goodsType = calculationData.goodsType.rawValue
        calc.fromLocation = fromLocation
        calc.departureAirport = calculationData.departureAirport
        calc.fromLocationCode = calculationData.fromLocationCode
        calc.deliveryTypeCode = calculationData.deliveryTypeCode
        calc.countryTo = calculationData.countryTo.rawValue
        calc.countryFrom = calculationData.countryFrom.rawValue
        calc.weight = calculationData.weight
        calc.volume = calculationData.volume
        calc.invoiceAmount = calculationData.invoiceAmount
        calc.invoiceCurrency = calculationData.invoiceCurrency
        calc.isConfirmed = isConfirmed
        calc.totalPrice = totalPriceData.first(where: { $0.isConfirmed })?.totalPrice
        calc.needCustomsClearance = calculationData.needCustomClearance
        calc.exchangeRate = calculationData.exchangeRate
        calc.logisticsTypes = encodeItemsToData(items: calculationData.availableLogisticsTypes)
        
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
            calcResult.insuranceRatio = totalPriceDataItem.insuranceRatio ?? 0
            calcResult.insuranceAgentVisit = totalPriceDataItem.insuranceAgentVisit ?? 0
            calcResult.minLogisticsProfit = totalPriceDataItem.minLogisticsProfit ?? 0
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
    
    static func retrieveItemsFromCoreData<T: CoreDataStorable>(entityName: String = T.coreDataKey, key: String = Keys.cdDataAttribute) -> [T]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            guard let result = results?.first, let data = result.value(forKey: key) as? Data else { return nil }
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
    
    private static func storeItemsToCoreData<T: CoreDataStorable>(items: [T], entityName: String = T.coreDataKey) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            print(FLCError.entityNotFound.rawValue)
            return
        }
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
        guard let entity = NSEntityDescription.entity(forEntityName: T.coreDataKey, in: context) else {
            print(FLCError.entityNotFound.rawValue)
            return
        }
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        do {
            let data = try encoder.encode(item)
            managedObject.setValue(data, forKey: Keys.cdDataAttribute)
            try context.save()
        } catch {
            print(FLCError.unableToEncodeOrSavetoCoreData.rawValue)
        }
    }
    
    private static func encodeItemsToData<T: Codable>(items: [T]) -> Data? {
        do {
            return try JSONEncoder().encode(items)
        } catch {
            print(FLCError.unableToEncodeOrSavetoCoreData.rawValue)
            return nil
        }
    }
    
    static func decodeDataToItems<T: Codable>(data: Data) -> [T]? {
        do {
            let items = try JSONDecoder().decode([T].self, from: data)
            return items
        } catch {
            print(FLCError.unableToEncodeOrSavetoCoreData.rawValue)
            return nil
        }
    }
}
