import Foundation

struct UsefulInfoHelper {
    static let usefulInfoServices: [UsefulInfoContent] = [
        UsefulInfoContent(type: .bonusSystem, image: FLCIcon.rubleSign.icon, title: UsefulInfoVCStrings.bonusSystem, urlString: nil),
        UsefulInfoContent(type: .sanctionsCheck, image: FLCIcon.circle.icon, title: UsefulInfoVCStrings.sanctionsCheck, urlString: UsefulInfoVCStrings.sanctionsCheckLink),
        UsefulInfoContent(type: .fashionSupplierBase, image: FLCIcon.person.icon, title: UsefulInfoVCStrings.fashionSupplierBase, urlString: UsefulInfoVCStrings.fashionSupplierBaseLink)
    ]
    
    static let usefulInfoAboutCompany: [UsefulInfoContent] = [
        UsefulInfoContent(type: .contacts, image: FLCIcon.phoneBubble.icon, title: UsefulInfoVCStrings.contacts, urlString: nil)
    ]
    
    static func getUsefulInfoDocuments() async -> [Document] {
        do {
            if let storedDocuments: [Document] = CoreDataManager.retrieveItemsFromCoreData() {
                return storedDocuments
            } else {
                let documents: [Document] = try await FirebaseManager.getDataFromFirebase() ?? CalculationInfo.defaultUsefulInfoDocuments
                let _ = CoreDataManager.updateItemsInCoreData(items: documents)
                return documents
            }
        } catch {
            return []
        }
    }
}

