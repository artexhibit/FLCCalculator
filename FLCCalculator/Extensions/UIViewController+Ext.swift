import SwiftUI
import SafariServices

extension UIViewController {
    func configureTapGesture(selector: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func configurePanGesture(selector: Selector) {
        let panGesture = UIPanGestureRecognizer(target: self, action: selector)
        panGesture.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(panGesture)
    }
    
    func showConfetti() {
        let confetti = FLCConfettiLayer(view: self.view)
        self.view.layer.addSublayer(confetti)
        confetti.addBehaviors()
        confetti.addAnimations()
        
        HapticManager.addSuccessHaptic(delay: 1)
        HapticManager.addSuccessHaptic(delay: 1.4)
    }
    
    func setNavBarColor(color: UIColor) {
        let textChangeColor = [NSAttributedString.Key.foregroundColor: color]
        self.navigationController?.navigationBar.titleTextAttributes = textChangeColor
        self.navigationController?.navigationBar.largeTitleTextAttributes = textChangeColor
    }
    
    func presentSafariVC(with urlString: String?) {
        guard let url = URL(string: urlString ?? "") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .flcOrange
        present(safariVC, animated: true)
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