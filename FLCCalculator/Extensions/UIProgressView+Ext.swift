import UIKit

extension UIProgressView {    
    func setProgress(_ option: ProgressViewOption, times: Float = 1.0) {
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
