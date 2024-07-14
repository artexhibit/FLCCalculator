import Foundation

struct FirebaseDataUpdateItem: Codable {
    let item: FLCFirebaseDataUpdateItem
    var updateDate: String
}

extension FirebaseDataUpdateItem: UserDefaultsStorable { static var userDefaultsKey: String { Keys.firebaseDataUpdateItem } }
