import Foundation
import CoreData

struct CoreDataManager {
    private static let context = Persistence.shared.container.viewContext
    
    static func loadCalculations() -> [Calculation]? {
        let request: NSFetchRequest<Calculation> = Calculation.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print(FLCError.unableToFetchCategories)
            return nil
        }
    }
    
    static func createCalculationRecord(with calculationData: CalculationData, totalPriceData: [TotalPriceData]) {
        let calc = Calculation(context: context)
        calc.calculationDate = Date()
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
        calc.totalPrice = totalPriceData.first(where: { $0.isFavourite })?.totalPrice
        calc.needCustomsClearance = calculationData.needCustomClearance
        
        Persistence.shared.saveContext()
    }
}
