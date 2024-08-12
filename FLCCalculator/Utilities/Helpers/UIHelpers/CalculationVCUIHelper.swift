import UIKit

struct CalculationVCUIHelper {
    
    @MainActor
    static func performCalculateButton(transportView: FLCTransportParametersView, cargoView: FLCCargoParametersView, pickedDestinationCode: String, departureCity: String, leadingConstraint: NSLayoutConstraint, vc: UIViewController) {
        guard CalculationHelper.confirmDataIsValid(in: transportView) else { return }
        
        guard PriceCalculationManager.isCalculationDataAvailable() else {
            FLCPopupView.showOnMainThread(title: FLCPopupMessages.downloadTariffs, style: .spinner)
            
            Task {
                do {
                   try await AppDelegateHelper.updateCalculationData()
                   try await AppDelegateHelper.updateCurrencyData()
                    
                    FLCPopupView.removeFromMainThread()
                    FLCPopupView.showOnMainThread(systemImage: FLCIcon.checkmark.icon, title: FLCPopupMessages.tariffsDownloaded)
                    
                    showCalculationResult(transportView: transportView, cargoView: cargoView, pickedDestinationCode: pickedDestinationCode, departureCity: departureCity, leadingConstraint: leadingConstraint, vc: vc)
                } catch {
                    FLCPopupView.showOnMainThread(title: FLCPopupMessages.tariffsNotDowloaded, style: .error)
                }
            }
            return
        }
        showCalculationResult(transportView: transportView, cargoView: cargoView, pickedDestinationCode: pickedDestinationCode, departureCity: departureCity, leadingConstraint: leadingConstraint, vc: vc)
    }
    
    private static func showCalculationResult(transportView: FLCTransportParametersView, cargoView: FLCCargoParametersView, pickedDestinationCode: String, departureCity: String, leadingConstraint: NSLayoutConstraint, vc: UIViewController) {
        let data = CalculationHelper.getCalculationData(transportView: transportView, cargoView: cargoView, pickedDestinationCode: pickedDestinationCode, departureCity: departureCity)
        
        CalculationResultHelper.createCalculationResultVC(data: data, from: vc)
        FLCUIHelper.move(view: cargoView, constraint: leadingConstraint, vc: vc, direction: .forward, times: 2, duration: 0.25)
        vc.navigationController?.removeVCFromStack(vc: vc)
    }
}
