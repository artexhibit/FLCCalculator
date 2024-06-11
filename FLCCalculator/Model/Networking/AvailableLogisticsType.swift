import UIKit

struct AvailableLogisticsType: Codable, Hashable {
    let country: String
    let logisticsTypeName: String
    let isAvailable: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(country)
        hasher.combine(logisticsTypeName)
        hasher.combine(isAvailable)
    }
}

extension AvailableLogisticsType: CoreDataStorable { static var coreDataKey: String { Keys.cdAvailableLogisticsTypes } }
extension AvailableLogisticsType: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.availableLogisticsTypes }
    static var collectionNameKey: String { Keys.availableLogisticsTypes } }
