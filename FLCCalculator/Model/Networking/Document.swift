import UIKit

struct Document: Codable, Hashable {
    let title: String
    let fileName: String
    let docDate: String
    let isDownloaded: Bool
    
    init(title: String, fileName: String, docDate: String, isDownloaded: Bool) {
        self.title = title
        self.fileName = fileName
        self.docDate = docDate
        self.isDownloaded = isDownloaded
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        fileName = try container.decode(String.self, forKey: .fileName)
        docDate = try container.decode(String.self, forKey: .docDate)
        isDownloaded = false
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case fileName
        case docDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(fileName)
        hasher.combine(docDate)
        hasher.combine(isDownloaded)
    }
}

extension Document: UserDefaultsStorable { static var userDefaultsKey: String { Keys.documents } }
extension Document: FirebaseIdentifiable { static var collectionNameKey: String { Keys.documents } }
