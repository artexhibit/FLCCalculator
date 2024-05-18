import Foundation

protocol FirebaseIdentifiable: Hashable, Codable {
    static var collectionNameKey: String { get }
    static var fieldNameKey: String { get }
}

protocol UserDefaultsStorable: Codable, Hashable {
    static var userDefaultsKey: String { get }
}
