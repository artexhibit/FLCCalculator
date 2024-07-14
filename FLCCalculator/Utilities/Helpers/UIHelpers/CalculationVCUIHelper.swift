import UIKit

struct CalculationVCUIHelper {
    @MainActor
    static func performCalculateButton(transportView: FLCTransportParametersView, cargoView: FLCCargoParametersView, pickedDestinationCode: String, departureCity: String, leadingConstraint: NSLayoutConstraint, vc: UIViewController) {
        guard CalculationHelper.confirmDataIsValid(in: transportView) else { return }
        
        guard PriceCalculationManager.isCalculationDataAvailable() else {
            AppDelegateHelper.updateCalculationData()
            FLCPopupView.showOnMainThread(title: "Не все тарифы загружены. Повторите через несколько минут", style: .error)
            return
        }
        let data = CalculationHelper.getCalculationData(transportView: transportView, cargoView: cargoView, pickedDestinationCode: pickedDestinationCode, departureCity: departureCity)
        
        CalculationResultHelper.createCalculationResultVC(data: data, from: vc)
        FLCUIHelper.move(view: cargoView, constraint: leadingConstraint, vc: vc, direction: .forward, times: 2, duration: 0.25)
        vc.navigationController?.removeVCFromStack(vc: vc)
    }
}
