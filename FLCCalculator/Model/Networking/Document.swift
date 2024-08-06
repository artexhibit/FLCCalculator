import UIKit

struct Document: Codable, Hashable {
    let title: String
    let fileName: String
    let docDate: String
    let localisationData: [String: DocumentLanguageData]?
    
    init(title: String, fileName: String, docDate: String) {
        self.title = title
        self.fileName = fileName
        self.docDate = docDate
        self.localisationData = nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(fileName)
        hasher.combine(docDate)
        hasher.combine(localisationData)
    }
}

struct DocumentLanguageData: Codable, Hashable {
    let title: String
}

extension Document: CoreDataStorable { static var coreDataKey: String { Keys.cdDocuments } }
extension Document: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.documents }
    static var collectionNameKey: String { Keys.documents } }
