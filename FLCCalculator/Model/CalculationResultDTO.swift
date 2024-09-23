import Foundation

struct CalculationResultDTO: Codable {
    let cargoHandling: String
    let cargoHandlingMinPrice: Double
    let cargoHandlingPricePerKg: Double
    let customsClearance: String
    let customsWarehousePrice: String
    let deliveryFromWarehousePrice: String
    let deliveryFromWarehouseTime: String
    let deliveryToWarehousePrice: String
    let deliveryToWarehouseTime: String
    let groupageDocs: String
    let insurance: String
    let insuranceAgentVisit: Double
    let insurancePercentage: Double
    let insuranceRatio: Double
    let isConfirmed: Bool
    let logisticsType: String
    let minLogisticsProfit: Double
    let russianDeliveryPrice: String
    let russianDeliveryTime: String
    let totalPrice: String
    let totalTime: String
}

extension CalculationResult {
    func toDTO() -> CalculationResultDTO {
        return CalculationResultDTO(
            cargoHandling: self.cargoHandling ?? "",
            cargoHandlingMinPrice: self.cargoHandlingMinPrice,
            cargoHandlingPricePerKg: self.cargoHandlingPricePerKg,
            customsClearance: self.customsClearance ?? "",
            customsWarehousePrice: self.customsWarehousePrice ?? "",
            deliveryFromWarehousePrice: self.deliveryFromWarehousePrice ?? "",
            deliveryFromWarehouseTime: self.deliveryFromWarehouseTime ?? "",
            deliveryToWarehousePrice: self.deliveryToWarehousePrice ?? "",
            deliveryToWarehouseTime: self.deliveryToWarehouseTime ?? "",
            groupageDocs: self.groupageDocs ?? "",
            insurance: self.insurance ?? "",
            insuranceAgentVisit: self.insuranceAgentVisit,
            insurancePercentage: self.insurancePercentage,
            insuranceRatio: self.insuranceRatio,
            isConfirmed: self.isConfirmed,
            logisticsType: self.logisticsType ?? "",
            minLogisticsProfit: self.minLogisticsProfit,
            russianDeliveryPrice: self.russianDeliveryPrice ?? "",
            russianDeliveryTime: self.russianDeliveryTime ?? "",
            totalPrice: self.totalPrice ?? "",
            totalTime: self.totalTime ?? ""
        )
    }
}
