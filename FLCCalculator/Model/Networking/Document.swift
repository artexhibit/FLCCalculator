import UIKit

struct Document: Codable, Hashable {
    let title: String
    let fileName: String
    let docDate: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case fileName
        case docDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(fileName)
        hasher.combine(docDate)
    }
}

extension Document: UserDefaultsStorable { static var userDefaultsKey: String { Keys.documents } }
extension Document: FirebaseIdentifiable { static var collectionNameKey: String { Keys.documents } }
