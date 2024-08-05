import Foundation

struct UsefulInfoHelper {
    static let usefulInfoServices: [UsefulInfoContent] = [
        UsefulInfoContent(type: .bonusSystem, image: Icons.rubleSign, title: UsefulInfoStrings.bonusSystem, urlString: nil),
        UsefulInfoContent(type: .sanctionsCheck, image: Icons.circle, title: UsefulInfoStrings.sanctionsCheck, urlString: UsefulInfoStrings.sanctionsCheckLink),
        UsefulInfoContent(type: .fashionSupplierBase, image: Icons.person, title: UsefulInfoStrings.fashionSupplierBase, urlString: UsefulInfoStrings.fashionSupplierBaseLink)
    ]
    
    static let usefulInfoAboutCompany: [UsefulInfoContent] = [
        UsefulInfoContent(type: .contacts, image: Icons.phoneBubble, title: UsefulInfoStrings.contacts, urlString: nil)
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

