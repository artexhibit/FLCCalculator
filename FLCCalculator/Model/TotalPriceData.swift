import Foundation

struct TotalPriceData: Hashable {
    var logisticsType: FLCLogisticsType = .chinaTruck
    var totalPrice: String? = nil
    var totalTime: String? = nil
    var cargoHandling: String? = nil
    var customsClearance: String? = nil
    var customsWarehousePrice: String? = nil
    var deliveryFromWarehousePrice: String? = nil
    var deliveryFromWarehouseTime: String? = nil
    var deliveryToWarehousePrice: String? = nil
    var deliveryToWarehouseTime: String? = nil
    var russianDeliveryPrice: String? = nil
    var russianDeliveryTime: String? = nil
    var groupageDocs: String? = nil
    var insurance: String? = nil
    var isFavourite: Bool = false
}
