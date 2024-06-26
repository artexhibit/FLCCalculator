import UIKit

struct CalculationsVCHelper {
    static func createStoredCalculationData(pickedCalculation: Calculation, results: Set<CalculationResult>?) -> CalculationData {
        var totalPrices = [TotalPriceData]()
        
        results?.forEach({ result in
            let totalPrice = TotalPriceData(
                logisticsType: FLCLogisticsType(rawValue: result.logisticsType ?? "") ?? .chinaTruck,
                totalPrice: result.totalPrice ?? "",
                totalTime: result.totalTime ?? "",
                cargoHandling: result.cargoHandling ?? "",
                customsClearance: result.customsClearance ?? "",
                customsWarehousePrice: result.customsWarehousePrice ?? "",
                deliveryFromWarehousePrice: result.deliveryFromWarehousePrice ?? "",
                deliveryFromWarehouseTime: result.deliveryFromWarehouseTime ?? "",
                deliveryToWarehousePrice: result.deliveryToWarehousePrice ?? "",
                deliveryToWarehouseTime: result.deliveryToWarehouseTime ?? "",
                russianDeliveryPrice: result.russianDeliveryPrice ?? "",
                russianDeliveryTime: result.russianDeliveryTime ?? "",
                groupageDocs: result.groupageDocs ?? "",
                insurance: result.insurance ?? "",
                insurancePercentage: result.insurancePercentage,
                insuranceRatio: result.insurancePercentage,
                insuranceAgentVisit: result.insuranceAgentVisit,
                minLogisticsProfit: result.minLogisticsProfit,
                cargoHandlingPricePerKg: result.cargoHandlingPricePerKg,
                cargoHandlingMinPrice: result.cargoHandlingMinPrice,
                isConfirmed: result.isConfirmed)
            
            totalPrices.append(totalPrice)
        })
        
        let calculationData = CalculationData(
            id: pickedCalculation.id, 
            countryFrom: pickedCalculation.countryFrom ?? "",
            countryTo: pickedCalculation.countryTo ?? "",
            deliveryType: pickedCalculation.deliveryType ?? "",
            deliveryTypeCode: pickedCalculation.deliveryTypeCode ?? "", 
            departureAirport: pickedCalculation.departureAirport ?? "",
            fromLocationCode: pickedCalculation.fromLocationCode ?? "",
            fromLocation: pickedCalculation.fromLocation ?? "",
            toLocation: pickedCalculation.toLocation ?? "",
            toLocationCode: pickedCalculation.toLocationCode ?? "",
            goodsType: pickedCalculation.goodsType ?? "",
            volume: pickedCalculation.volume,
            weight: pickedCalculation.weight,
            invoiceAmount: pickedCalculation.invoiceAmount,
            invoiceCurrency: pickedCalculation.invoiceCurrency ?? "",
            needCustomClearance: pickedCalculation.needCustomsClearance,
            totalPrices: totalPrices,
            availableLogisticsTypes: getAvailableLogisticsTypes(for: pickedCalculation),
            isFromCoreData: true,
            isConfirmed: pickedCalculation.isConfirmed,
            exchangeRate: pickedCalculation.exchangeRate)
        
        return calculationData
    }
    
    private static func getAvailableLogisticsTypes(for pickedCalculation: Calculation) -> [FLCLogisticsType] {
        guard let types: [FLCLogisticsType] = CoreDataManager.retrieveItemsFromCoreData(entityName: String(describing: type(of: pickedCalculation)), key: FLCLogisticsType.coreDataKey) else { return [FLCLogisticsType.chinaTruck] }
        return types
    }
    
    static func showPermissionsVC(in vc: UIViewController) {
        if !UserDefaultsManager.permissionsScreenWasShown { vc.presentNewVC(ofType: PermissionsVC.self) }
    }
}
