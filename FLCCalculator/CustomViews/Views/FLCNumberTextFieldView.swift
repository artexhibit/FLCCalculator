import UIKit

class FLCNumberTextFieldView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func configureLabelContainer() {
//            labelContainerView.translatesAutoresizingMaskIntoConstraints = false
//            labelContainerView.backgroundColor = .red
//            
//            labelContainerCenterY = labelContainerView.centerYAnchor.constraint(equalTo: centerYAnchor)
//            
//            NSLayoutConstraint.activate([
//                labelContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//                labelContainerCenterY
//            ])
//        }
//        
//        private func configureSmallLabel() {
//            smallLabel.translatesAutoresizingMaskIntoConstraints = false
//            
//            smallLabel.font = UIFont.preferredFont(forTextStyle: .title2)
//            smallLabel.adjustsFontSizeToFitWidth = true
//            smallLabel.minimumScaleFactor = 12
//            smallLabel.text = placeholder
//            smallLabel.textColor = .placeholderText
//            smallLabel.layer.opacity = 0
//            
//            labelContainerView.addSubview(smallLabel)
//            
//            NSLayoutConstraint.activate([
//                smallLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor),
//                smallLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 5),
//                smallLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -5),
//                smallLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor)
//                
//            ])
//        }
//        
//        private func showSmallLabel() {
//            labelContainerCenterY.isActive = false
//            labelContainerCenterY = labelContainerView.centerYAnchor.constraint(equalTo: topAnchor)
//            labelContainerCenterY.isActive = true
//            
//            labelContainerView.layer.zPosition = 1
//            
//            UIView.animate(withDuration: 0.5) {
//                self.labelContainerView.transform = CGAffineTransform(scaleX: 1, y: 1)
//                self.smallLabel.layer.opacity = 1
//                self.layoutIfNeeded()
//            }
//        }
}
