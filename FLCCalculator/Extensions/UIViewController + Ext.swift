import SwiftUI

extension UIViewController {
    func configureTapGesture(selector: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func configurePanGesture(selector: Selector) {
        let panGesture = UIPanGestureRecognizer(target: self, action: selector)
        panGesture.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(panGesture)
    }
    
    private struct Preview: UIViewControllerRepresentable {
        
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController { viewController }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
    
    func showPreview() -> some View { Preview(viewController: self).edgesIgnoringSafeArea(.all) }
    
    //struct ViewControllerProvider: PreviewProvider {
    //  static var previews: some View { CalculationResultVC().showPreview() }
    //}
}
