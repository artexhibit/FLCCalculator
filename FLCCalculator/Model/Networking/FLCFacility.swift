import Foundation

struct FLCFacility: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    let name: String
    let address: String
    let workingHours: String
    let phoneNumber: String
    let email: String?
    let avatarRef: [String]
    let routes: [String: String]
    let localisationData: [String: FacilityLanguageData]?
    
    init(latitude: Double, longitude: Double, name: String, address: String, workingHours: String, phoneNumber: String, email: String? = nil, avatarRef: [String] = [], routes: [String: String] = [:]) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.address = address
        self.workingHours = workingHours
        self.phoneNumber = phoneNumber
        self.email = email
        self.avatarRef = avatarRef
        self.routes = routes
        self.localisationData = nil
    }
    
    struct FacilityLanguageData: Codable, Hashable {
        let name: String
        let address: String
        let workingHours: String
    }
}

extension FLCFacility: CoreDataStorable { static var coreDataKey: String { Keys.cdFacilities } }

extension FLCFacility: FirebaseIdentifiable {
    static var fieldNameKey: String { Keys.offices }
    static var collectionNameKey: String { Keys.facilities }
}
