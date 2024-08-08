import Foundation

struct UsefulInfoHelper {
    static let usefulInfoServices: [UsefulInfoContent] = [
        UsefulInfoContent(type: .bonusSystem, image: Icons.rubleSign, title: UsefulInfoVCStrings.bonusSystem, urlString: nil),
        UsefulInfoContent(type: .sanctionsCheck, image: Icons.circle, title: UsefulInfoVCStrings.sanctionsCheck, urlString: UsefulInfoVCStrings.sanctionsCheckLink),
        UsefulInfoContent(type: .fashionSupplierBase, image: Icons.person, title: UsefulInfoVCStrings.fashionSupplierBase, urlString: UsefulInfoVCStrings.fashionSupplierBaseLink)
    ]
    
    static let usefulInfoAboutCompany: [UsefulInfoContent] = [
        UsefulInfoContent(type: .contacts, image: Icons.phoneBubble, title: UsefulInfoVCStrings.contacts, urlString: nil)
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

