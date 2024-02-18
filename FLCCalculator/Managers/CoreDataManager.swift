import Foundation
import CoreData

struct CoreDataManager {
    private static let context = Persistence.shared.container.viewContext
    
    static func loadCalculations() -> [Calculation]? {
        let request: NSFetchRequest<Calculation> = Calculation.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print(FLCError.unableToFetch)
            return nil
        }
    }
}
