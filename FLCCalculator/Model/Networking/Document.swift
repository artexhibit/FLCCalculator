import UIKit

struct Document: Codable, Hashable {
    let title: String
    let fileName: String
    let docDate: String
    let localisationData: DocumentLocalisationData
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(fileName)
        hasher.combine(docDate)
        hasher.combine(localisationData)
    }
}

struct DocumentLocalisationData: Codable, Hashable {
    let title: [String: String]
}

extension Document: CoreDataStorable { static var coreDataKey: String { Keys.cdDocuments } }
extension Document: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.documents }
    static var collectionNameKey: String { Keys.documents } }
