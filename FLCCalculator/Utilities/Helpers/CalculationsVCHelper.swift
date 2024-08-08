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
            countryFrom: FLCCountryOption(rawValue: pickedCalculation.countryFrom ?? "") ?? .china,
            countryTo: FLCCountryOption(rawValue: pickedCalculation.countryTo ?? "") ?? .russia,
            deliveryType: FLCDeliveryType(rawValue: pickedCalculation.deliveryType ?? "") ?? .exwShipperClient,
            deliveryTypeCode: pickedCalculation.deliveryTypeCode ?? "",
            departureAirport: pickedCalculation.departureAirport ?? "",
            fromLocationCode: pickedCalculation.fromLocationCode ?? "",
            fromLocation: pickedCalculation.fromLocation ?? "",
            toLocation: pickedCalculation.toLocation ?? "",
            toLocationCode: pickedCalculation.toLocationCode ?? "",
            goodsType: FLCGoodsType(rawValue: pickedCalculation.goodsType ?? "") ?? .autoAccessories,
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
        let userCredentials = KeychainManager.shared.read(type: FLCUserCredentials.self)
        guard let isHaveValidToken = userCredentials?.isTokenValid else { return }
        if !UserDefaultsManager.permissionsScreenWasShown && isHaveValidToken { vc.presentNewVC(ofType: PermissionsVC.self) }
    }
}
