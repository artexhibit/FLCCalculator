import UIKit

struct FLCManager: Codable, Hashable {
    let id: Int
    let name: String
    let position: String
    let mobilePhone: String
    let landlinePhone: String
    let telegram: String
    let whatsapp: String
    let email: String
    let avatarRef: String
    let dataDate: String
    private var avatarData: Data?
    
    var avatar: UIImage? {
        get {
            guard let avatarData = avatarData else { return nil }
            return UIImage(data: avatarData)
        }
        set {
            avatarData = newValue?.pngData()
        }
    }
    
    init(id: Int, name: String, position: String, mobilePhone: String, landlinePhone: String, telegram: String, whatsapp: String, email: String, avatarRef: String, dataDate: String, avatarData: Data? = nil) {
        self.id = id
        self.name = name
        self.position = position
        self.mobilePhone = mobilePhone
        self.landlinePhone = landlinePhone
        self.telegram = telegram
        self.whatsapp = whatsapp
        self.email = email
        self.avatarRef = avatarRef
        self.dataDate = dataDate
        self.avatarData = avatar?.pngData()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case position
        case mobilePhone
        case landlinePhone
        case telegram
        case whatsapp
        case email
        case avatarRef
        case dataDate
        case avatarData
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(position)
        hasher.combine(mobilePhone)
        hasher.combine(landlinePhone)
        hasher.combine(telegram)
        hasher.combine(whatsapp)
        hasher.combine(email)
        hasher.combine(avatarRef)
        hasher.combine(dataDate)
    }
}

extension FLCManager: CoreDataStorable { static var coreDataKey: String { Keys.cdManagers } }
extension FLCManager: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.managers }
    static var collectionNameKey: String { Keys.managers } }
