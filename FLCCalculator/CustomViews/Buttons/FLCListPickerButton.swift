import UIKit

class FLCListPickerButton: UIButton {

    private let smallLabelView = FLCSmallLabelView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholderText: String) {
        self.init(frame: .zero)
        smallLabelView.configureSmallLabel(with: placeholderText)
        smallLabelView.constraint(in: self)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(smallLabelView)
        
        layer.cornerRadius = 13
        tintColor = .label
        setTitleColor(.label, for: .normal)
        backgroundColor = UIColor.accent.withAlphaComponent(0.6)
        
        smallLabelView.frame = self.frame
    }
}
