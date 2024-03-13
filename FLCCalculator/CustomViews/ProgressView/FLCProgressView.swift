import UIKit

class FLCProgressView: UIProgressView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        progressViewStyle = .default
        progressTintColor = .accent
        trackTintColor = .lightGray.withAlphaComponent(0.2)
        layer.opacity = 0
        animateIn()
    }
    
    private func animateIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2) { self.layer.opacity = 1 }
        }
    }
    
    func setProgress(_ option: FLCProgressViewOption, times: Float = 1.0) {
        let value: Float = (1.0 / 9) * times
        var newProgress: Float = 0.0
        
        switch option {
        case .increase:
            newProgress = self.progress + value
        case .decrease:
            newProgress = self.progress - value
        }
        self.setProgress(newProgress, animated: true)
    }
}
