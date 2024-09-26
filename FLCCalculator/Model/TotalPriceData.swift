import Foundation

struct TotalPriceData: Codable, Hashable {
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
    var insurancePercentage: Double? = nil
    var insuranceRatio: Double? = nil
    var insuranceAgentVisit: Double? = nil
    var minLogisticsProfit: Double? = nil
    var cargoHandlingPricePerKg: Double? = nil
    var cargoHandlingMinPrice: Double? = nil
    var isConfirmed: Bool = false
}

extension TotalPriceData {
    func toDictionary() -> [String: Any] {
        return [
            "logisticsType": logisticsType.rawValue,
            "totalPrice": totalPrice ?? "",
            "totalTime": totalTime ?? "",
            "cargoHandling": cargoHandling ?? "",
            "customsClearance": customsClearance ?? "",
            "customsWarehousePrice": customsWarehousePrice ?? "",
            "deliveryFromWarehousePrice": deliveryFromWarehousePrice ?? "",
            "deliveryFromWarehouseTime": deliveryFromWarehouseTime ?? "",
            "deliveryToWarehousePrice": deliveryToWarehousePrice ?? "",
            "deliveryToWarehouseTime": deliveryToWarehouseTime ?? "",
            "russianDeliveryPrice": russianDeliveryPrice ?? "",
            "russianDeliveryTime": russianDeliveryTime ?? "",
            "groupageDocs": groupageDocs ?? "",
            "insurance": insurance ?? "",
            "insurancePercentage": insurancePercentage ?? 0,
            "insuranceRatio": insuranceRatio ?? 0,
            "insuranceAgentVisit": insuranceAgentVisit ?? 0,
            "minLogisticsProfit": minLogisticsProfit ?? 0,
            "cargoHandlingPricePerKg": cargoHandlingPricePerKg ?? 0,
            "cargoHandlingMinPrice": cargoHandlingMinPrice ?? 0,
            "isConfirmed": isConfirmed
        ]
    }
}

extension CalculationResult {
    func toDTO() -> TotalPriceData {
        return TotalPriceData(
            logisticsType: FLCLogisticsType(rawValue: self.logisticsType ?? "") ?? .chinaTruck,
            totalPrice: self.totalPrice,
            totalTime: self.totalTime,
            cargoHandling: self.cargoHandling,
            customsClearance: self.customsClearance,
            customsWarehousePrice: self.customsWarehousePrice,
            deliveryFromWarehousePrice: self.deliveryFromWarehousePrice,
            deliveryFromWarehouseTime: self.deliveryFromWarehouseTime,
            deliveryToWarehousePrice: self.deliveryToWarehousePrice,
            deliveryToWarehouseTime: self.deliveryToWarehouseTime,
            russianDeliveryPrice: self.russianDeliveryPrice,
            russianDeliveryTime: self.russianDeliveryTime,
            groupageDocs: self.groupageDocs,
            insurance: self.insurance,
            insurancePercentage: self.insurancePercentage,
            insuranceRatio: self.insuranceRatio,
            insuranceAgentVisit: self.insuranceAgentVisit,
            minLogisticsProfit: self.minLogisticsProfit,
            cargoHandlingPricePerKg: self.cargoHandlingPricePerKg,
            cargoHandlingMinPrice: self.cargoHandlingMinPrice,
            isConfirmed: self.isConfirmed
        )
    }
}
