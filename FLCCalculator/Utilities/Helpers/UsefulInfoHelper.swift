import Foundation

struct UsefulInfoHelper {
    static let usefulInfoContents: [UsefulInfoContent] = [
        UsefulInfoContent(type: .bonusSystem, image: Icons.rubleSign, title: "Бонусный счет", urlString: nil),
        UsefulInfoContent(type: .sanctionsCheck, image: Icons.circle, title: "Санкции", urlString: "https://cargointegrator.com"),
        UsefulInfoContent(type: .fashionSupplierBase, image: Icons.person, title: "База поставщиков индустрии моды", urlString: "https://manufactures.free-lines.ru"),
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

