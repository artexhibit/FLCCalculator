import Foundation

protocol FirebaseIdentifiable: Hashable, Codable {
    static var collectionNameKey: String { get }
    static var fieldNameKey: String { get }
}

protocol CoreDataStorable: Codable, Hashable {
    static var coreDataKey: String { get }
}
