import Foundation

struct RussianDelivery: Codable {
    fileprivate let take: DeliveryMainCost
    fileprivate let deliver: DeliveryMainCost
    fileprivate let auto: DeliveryMainCost
    fileprivate let add1: DeliveryAdditionalCost
    fileprivate let add3: DeliveryAdditionalCost
    fileprivate let periodsDays: PeriodsDays?
    
    enum CodingKeys: String, CodingKey {
        case take = "take"
        case deliver = "deliver"
        case auto = "auto"
        case add1 = "ADD_1"
        case add3 = "ADD_3"
        case periodsDays = "periods_days"
    }
    
    func getPrice() -> Double { take.price + deliver.price + auto.price + add1.price + add3.price }
    func getDays() -> String? {
        if let stringValue = periodsDays?.stringValue ?? periodsDays?.intValue.map({ String($0) }) {
            return stringValue
        }
        return nil
    }
}

struct DeliveryMainCost: Codable {
    let title: String
    let subtitle: String
    let price: Double
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        title = try container.decode(String.self)
        subtitle = try container.decode(String.self)
        price = try container.decode(Double.self)
    }
}

struct DeliveryAdditionalCost: Codable {
    let price: Double
    
    enum CodingKeys: String, CodingKey { case price = "3" }
}

struct PeriodsDays: Codable {
    let stringValue: String?
    let intValue: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            self.stringValue = stringValue
            self.intValue = nil
        } else {
            self.stringValue = nil
            self.intValue = try? container.decode(Int.self)
        }
    }
}
