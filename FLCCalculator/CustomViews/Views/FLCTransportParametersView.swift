import UIKit

class FLCTransportParametersView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .cyan
        translatesAutoresizingMaskIntoConstraints = false
    }
}
